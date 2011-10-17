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

#import "SCAPI.h"

// define to use production. else use sandbox
#define kUseProduction

#ifdef kUseProduction
	//Production key & secret
	#define kTestAppClientID        @"INHqfaDE8vt4Xr1mRzOmQ"
	#define kTestAppClientSecret    @"MSAO1CJTAMkF2UkfhqKfTIAA0KFyiHFgQpELe5CTs"
#else
	//Sandbox key & secret
	#define kTestAppClientKey       @"INHqfaDE8vt4Xr1mRzOmQ"
	#define kTestAppClientSecret    @"MSAO1CJTAMkF2UkfhqKfTIAA0KFyiHFgQpELe5CTs"
#endif

#define kRedirectURL	@"x-wrapper-test://oauth"	//remember that the myapp protocol also is set in the info.plist


#define appDelegate ((iPhoneTestAppAppDelegate *)[[UIApplication sharedApplication] delegate])

@class iPhoneTestAppViewController;

@interface iPhoneTestAppAppDelegate : NSObject <UIApplicationDelegate, SCSoundCloudAPIAuthenticationDelegate> {
    UIWindow *window;
    iPhoneTestAppViewController *viewController;

	SCSoundCloudAPI *soundCloudAPIMaster;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPhoneTestAppViewController *viewController;

@property (nonatomic, readonly) SCSoundCloudAPI *soundCloudAPIMaster;


@end

