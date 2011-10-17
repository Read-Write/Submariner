/*
 * Copyright 2010 nxtbgthng for SoundCloud Ltd.
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

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif


@class SCSoundCloudAPI;
@class SCLoginViewController;

@protocol SCSoundCloudAPIAuthenticationDelegate <NSObject>

@optional
- (void)soundCloudAPIDidAuthenticate;
- (void)soundCloudAPIDidResetAuthentication;
- (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;

- (void)soundCloudAPIPreparedAuthorizationURL:(NSURL *)authorizationURL;

#if TARGET_OS_IPHONE
//TODO: PresentViewConttroller
- (void)soundCloudAPIWillDisplayLoginViewController:(SCLoginViewController *)soundCloudViewController;
- (void)soundCloudAPIDisplayViewController:(UIViewController *)soundCloudViewController;
- (void)soundCloudAPIDismissViewController:(UIViewController *)soundCloudViewController;
#endif

@end
