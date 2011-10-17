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
 *
 *  DISCLAIMER:
 *    This is just sample code. Please make sure to understand the concepts described
 *    in the documentation of the api wrapper.
 *    The implementation of this class is just for illustration.
 * 
 */

#import "iPhoneTestAppAppDelegate.h"
#import "iPhoneTestAppViewController.h"


@implementation iPhoneTestAppAppDelegate

#pragma mark Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
	[window setRootViewController:viewController];
    [window makeKeyAndVisible];
	
	NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];	
	BOOL didHandleURL = NO;
	if (launchURL) {
		didHandleURL = [self.soundCloudAPIMaster handleRedirectURL:launchURL];	
	}
	
	// do this at the end and seperatly. this way you ensure that your soundCloudController 
	// already is accessible via the appDelegate & that the launchURL (if there's one) has been handled
	[self.soundCloudAPIMaster checkAuthentication];
	
	return didHandleURL; 
}

- (void)dealloc;
{
    [viewController release];
	[soundCloudAPIMaster release];
    [window release];
    [super dealloc];
}


#pragma mark Accessors

@synthesize window;
@synthesize viewController;

- (SCSoundCloudAPI *)soundCloudAPIMaster;
{
	if (!soundCloudAPIMaster) {
#ifdef kUseProduction
		SCSoundCloudAPIConfiguration *scAPIConfig = [SCSoundCloudAPIConfiguration configurationForProductionWithClientID:kTestAppClientID
                                                                                                            clientSecret:kTestAppClientSecret
                                                                                                             redirectURL:[NSURL URLWithString:kRedirectURL]];
#else
		SCSoundCloudAPIConfiguration *scAPIConfig = [SCSoundCloudAPIConfiguration configurationForSandboxWithClientID:kTestAppClientID
                                                                                                         clientSecret:kTestAppClientSecret
                                                                                                          redirectURL:[NSURL URLWithString:kRedirectURL]];
#endif
		
		soundCloudAPIMaster = [[SCSoundCloudAPI alloc] initWithDelegate:nil authenticationDelegate:self apiConfiguration:scAPIConfig];
		// make shure to register the myapp url scheme to your app :)
		
	}
	return soundCloudAPIMaster;
}


#pragma mark -

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
{
	return [soundCloudAPIMaster handleRedirectURL:url];
}

#pragma mark SCSoundCloudAPIAuthenticationDelegate

- (void)soundCloudAPIDidAuthenticate;
{
	viewController.postButton.enabled = YES;
	viewController.trackNameField.enabled = YES;
	// not the most elegant way to enable/disable the ui
	// but this is up to you (the developer of apps) to prove your cocoa skills :)
	
	[viewController requestUserInfo];
}

- (void)soundCloudAPIDidResetAuthentication;
{
	viewController.postButton.enabled = NO;
	viewController.trackNameField.enabled = NO;
	
	// reauthenticate
	[self.soundCloudAPIMaster checkAuthentication];
}

- (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;
{
	if ([error.domain isEqualToString:SCAPIErrorDomain]) {
	} else if ([error.domain isEqualToString:NSURLErrorDomain]) {
		if ([error code] == NSURLErrorNotConnectedToInternet) {
			[viewController.postButton setTitle:@"No internet connection" forState:UIControlStateDisabled];
			[viewController.postButton setEnabled:NO];
		} else {
			NSLog(@"error: %@", [error localizedDescription]);
		}
		
	}
}


@end