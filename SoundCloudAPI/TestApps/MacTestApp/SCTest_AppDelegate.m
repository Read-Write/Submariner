/*
 * Copyright 2009 Ullrich Schäfer, Gernot Poetsch for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

#import "SCTest_AppDelegate.h"

#import "JSONKit.h"

#import "SCParameterTableDataSource.h"

@interface SCTest_AppDelegate(private)
- (void)commonAwake;
- (void)_registerMyApp;
@end

@implementation SCTest_AppDelegate

#pragma mark Lifecycle

- (void)awakeFromNib;
{
	assert(fetchProgressIndicator != nil);
	assert(httpMethodCombo != nil);
	assert(newParameterAddButton != nil);
	assert(newParameterKeyField != nil);
	assert(newParameterRemoveButton != nil);
	assert(newParameterValueField != nil);
	assert(parametersTableView != nil);
	assert(resourceField != nil);
	assert(responseField != nil);
	assert(sendRequestButton != nil);
	[self commonAwake];
}

- (void)commonAwake;
{
	SCSoundCloudAPIConfiguration *scAPIConfig = nil;
#ifdef kUseProduction
	scAPIConfig = [SCSoundCloudAPIConfiguration configurationForProductionWithClientID:kTestAppClientID
                                                                          clientSecret:kTestAppClientSecret
                                                                           redirectURL:[NSURL URLWithString:kRedirectURL]];
#else
	scAPIConfig = [SCSoundCloudAPIConfiguration configurationForSandboxWithClientID:kTestAppClientID
                                                                       clientSecret:kTestAppClientSecret
                                                                        redirectURL:[NSURL URLWithString:kRedirectURL]];
#endif
	
	scAPI = [[SCSoundCloudAPI alloc] initWithDelegate:self
							   authenticationDelegate:self
									 apiConfiguration:scAPIConfig];
	[scAPI setResponseFormat:SCResponseFormatJSON];
	
	parametersDataSource = [[SCParameterTableDataSource alloc] init];
	[parametersTableView setDataSource:parametersDataSource];
	
	[self _registerMyApp];
	
	[scAPI checkAuthentication];
}	

- (void)dealloc;
{
	[scAPI release];
	[parametersDataSource release];
	[super dealloc];
}

#pragma mark URL handling

- (void)_registerMyApp;
{
	NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
	[em setEventHandler:self 
			andSelector:@selector(getUrl:withReplyEvent:) 
		  forEventClass:kInternetEventClass 
			 andEventID:kAEGetURL];
	
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	OSStatus result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"x-wrapper-test", (CFStringRef)bundleID);
	if(result != noErr) {
		NSLog(@"could not register to \"x-wrapper-test\" URL scheme");
	}
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
	// Get the URL
	NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject] 
						stringValue];
	
	if([urlStr hasPrefix:kRedirectURL]) {
		NSLog(@"handling oauth callback");
		NSURL *url = [NSURL URLWithString:urlStr];
		[scAPI handleRedirectURL:url];
	}
}

#pragma mark Actions

- (IBAction)addParameter:(id)sender {
	NSString *key = [newParameterKeyField stringValue];
	NSString *value = [newParameterValueField stringValue];
	[parametersDataSource addParameterWithKey:key
										value:value];
	[parametersTableView reloadData];
}

- (IBAction)removeParameter:(id)sender {
    [parametersDataSource removeParametersAtIndexes:[parametersTableView selectedRowIndexes]];
	[parametersTableView reloadData];
}

- (IBAction)sendRequest:(id)sender {
	[fetchProgressIndicator startAnimation:nil];
	
	[scAPI performMethod:[httpMethodCombo stringValue]
			  onResource:[resourceField stringValue]
		  withParameters:[parametersDataSource parameterDictionary]
				 context:nil
				userInfo:nil];
}

- (IBAction)postTest:(id)sender;
{
	// sample from http://www.freesound.org/samplesViewSingle.php?id=1375
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1375_sleep_90_bpm_nylon2" ofType:@"wav"];
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	
	NSMutableDictionary *parameters = [[parametersDataSource parameterDictionary] mutableCopy];
	[parameters setObject:fileURL forKey:@"track[asset_data]"];
	
	[fetchProgressIndicator startAnimation:nil];
	[scAPI performMethod:@"POST"
			  onResource:[resourceField stringValue]
		  withParameters:parameters
				 context:nil
				userInfo:nil];
	[parameters release];
}

- (IBAction)deleteAllMyTracks:(id)sender;
{
	[scAPI performMethod:@"GET"
			  onResource:@"me/tracks"
		  withParameters:nil
				 context:@"deleteMyTracks"
				userInfo:nil];
}

- (void)deleteTracks:(NSArray *)tracks;
{
	for(NSDictionary *track in tracks) {
		[scAPI performMethod:@"DELETE"
				  onResource:[NSString stringWithFormat:@"tracks/%@", [track objectForKey:@"id"]]
			  withParameters:nil
					 context:nil
					userInfo:nil];
	}
}


#pragma mark request delegates

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFinishWithData:(NSData *)data context:(id)context userInfo:(id)userInfo;
{
	[fetchProgressIndicator stopAnimation:nil];
	[postProgress setDoubleValue:0];
	
	if([context isEqualToString:@"deleteMyTracks"]) {
		[self deleteTracks:[data objectFromJSONData]];
		return;
	}
	
	[responseField setString:[[data objectFromJSONData] description]];
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFailWithError:(NSError *)error context:(id)context userInfo:(id)userInfo;
{
	[fetchProgressIndicator stopAnimation:nil];
	[postProgress setDoubleValue:0];
	if ([[error domain] isEqualToString:NSURLErrorDomain]){
		if (error.code == NSURLErrorNotConnectedToInternet) {
			// inform the user and offer him to retry
			[sendRequestButton setTitle:@"No internet"];
			[postTestButton setTitle:@"No internet"];
		}
	} else if ([[error domain] isEqualToString:SCAPIErrorDomain]) {
	} else if ([[error domain] isEqualToString:NXOAuth2ErrorDomain]) {
	}
	NSString *message = [NSString stringWithFormat:@"Request finished with Error: \n%@", [error localizedDescription]];
	NSLog(@"%@", message);
	[responseField setString:message];
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveData:(NSData *)data context:(id)context userInfo:(id)userInfo;
{
	NSLog(@"Did Recieve Data");
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveBytes:(unsigned long long)loadedBytes total:(unsigned long long)totalBytes context:(id)context userInfo:(id)userInfo;
{
	NSLog(@"Did receive Bytes %qu of %qu", loadedBytes, totalBytes);
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didSendBytes:(unsigned long long)sendBytes total:(unsigned long long)totalBytes context:(id)context userInfo:(id)userInfo;
{
	NSLog(@"Did send Bytes %qu of %qu", sendBytes, totalBytes);
	[postProgress setDoubleValue:100 * sendBytes / totalBytes];
}



#pragma mark SoundCloudAPI authorization delegate

- (void)soundCloudAPIPreparedAuthorizationURL:(NSURL *)authorizationURL;
{
	[[NSWorkspace sharedWorkspace] openURL:authorizationURL];
}

- (void)soundCloudAPIDidAuthenticate;
{
	// authenticated
	[sendRequestButton setEnabled:YES];
	// not the most elegant way to enable/disable the ui
	// but this is up to you (the developer of apps) to prove your cocoa skills :)
	[postTestButton setEnabled:YES];
}

- (void)soundCloudAPIDidResetAuthentication;
{
	[sendRequestButton setEnabled:NO];
	[postTestButton setEnabled:NO];
}

- (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;
{
	if ([[error domain] isEqualToString:NSURLErrorDomain]){
		if (error.code == NSURLErrorNotConnectedToInternet) {
			// inform the user and offer him to retry
			[sendRequestButton setTitle:@"No internet"];
			[postTestButton setTitle:@"No internet"];
		}
	} else if ([[error domain] isEqualToString:SCAPIErrorDomain]) {
	} else if ([[error domain] isEqualToString:NXOAuth2ErrorDomain]) {
	}
	NSString *message = [NSString stringWithFormat:@"Request finished with Error: \n%@", [error localizedDescription]];
	NSLog(@"%@", message);
	[responseField setString:message];
}

@end
