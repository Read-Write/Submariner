/*
 * Copyright 2010 Ullrich Schäfer, Gernot Poetsch for SoundCloud Ltd.
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

#import "JSONKit.h"

#import "iPhoneTestAppViewController.h"
#import "iPhoneTestAppAppDelegate.h"

#import "SCSoundCloudAPI+TestApp.h"


@interface iPhoneTestAppViewController(private)
-(void)commonAwake;
-(void)updateUserInfoFromData:(NSData *)data;
@end


@implementation iPhoneTestAppViewController

#pragma mark Lifecycle

- (void)awakeFromNib;
{
	scAPI = [appDelegate.soundCloudAPIMaster copyWithAPIDelegate:self];
}


- (void)dealloc;
{ 
	[uploadConnectionId release];
	[scAPI release];
	[super dealloc];
}


#pragma mark Accessors

@synthesize postButton, trackNameField;


#pragma mark Private

- (void)requestUserInfo;
{
	[scAPI meWithContext:@"userInfo"];
}

- (void)updateUserInfoFromData:(NSData *)data;
{
	id object = [data objectFromJSONData];
	
	if([object isKindOfClass:[NSDictionary class]]) {
		NSDictionary *userInfoDictionary = (NSDictionary *)object;
		[usernameLabel setText:[userInfoDictionary objectForKey:@"username"]];
		[trackNumberLabel setText:[NSString stringWithFormat:@"%d", [[userInfoDictionary objectForKey:@"private_tracks_count"] integerValue]]];
	}
}


#pragma mark Actions

-(IBAction)sendRequest:(id)sender;
{
	// sample from http://www.freesound.org/samplesViewSingle.php?id=1375
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"1375_sleep_90_bpm_nylon2" ofType:@"wav"];
	NSURL *dataURL = [NSURL fileURLWithPath:dataPath];
	
	[progresBar setProgress:0];
	if (uploadConnectionId) {
		[scAPI cancelConnection:uploadConnectionId];
		[uploadConnectionId release]; uploadConnectionId = nil;
	}
	uploadConnectionId = [[scAPI postTrackWithTitle:[trackNameField text]
											fileURL:dataURL
										   isPublic:NO
											context:@"upload"] retain];
}

-(void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
    // Release anything that's not essential, such as cached data
}


#pragma mark SCSoundCloudAPIDelegate

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFinishWithData:(NSData *)data context:(id)context userInfo:(id)userInfo;
{
	if([context isEqualToString:@"userInfo"]) {
		[self updateUserInfoFromData:data];
	}
	if([context isEqualToString:@"upload"]) {
		[uploadConnectionId release]; uploadConnectionId = nil;
		[self requestUserInfo];
		
		return; // comment this line to add the track to the field recordings group http://sandbox-soundcloud.com/groups/field-recordings
		
		NSDictionary *newTrack = [data objectFromJSONData];
		
		NSNumber *groupId = [NSNumber numberWithInt:8];	// check group id for production
		NSNumber *trackId = [newTrack objectForKey:@"id"];

		[scAPI postTrackWithId:trackId toGroupWithId:groupId context:@"addToGroup"];
	}
	if ([context isEqualToString:@"addToGroup"]) {
		NSLog(@"%@", [data objectFromJSONData]);
	}
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFailWithError:(NSError *)error context:(id)context userInfo:(id)userInfo;
{
	if ([error.domain isEqualToString:NSURLErrorDomain]) {
		if (error.code == 401) {
			NSLog(@"401 - not authenticated");
		}
	}
	if ([context isEqualToString:@"upload"]) {
		[uploadConnectionId release]; uploadConnectionId = nil;
	}
	// check error code. if it's a http error get it from the userdict (see SCAPIErrors.h)
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[error localizedDescription]
												   delegate:nil
										  cancelButtonTitle:@"Ignore"
										  otherButtonTitles:@"Retry (dummy)", nil];
	[alert show];
	[alert release];
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveData:(NSData *)data context:(id)context userInfo:(id)userInfo;
{}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveBytes:(unsigned long long)loadedBytes total:(unsigned long long)totalBytes context:(id)context userInfo:(id)userInfo;
{}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didSendBytes:(unsigned long long)sendBytes total:(unsigned long long)totalBytes context:(id)context userInfo:(id)userInfo;
{
	if([context isEqual:@"upload"]) {
		[progresBar setProgress: ((float)sendBytes) / totalBytes];
	}
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

@end
