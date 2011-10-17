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
#import "NXOAuth2.h"
#else
#import <OAuth2Client/NXOAuth2.h>
#endif

#import "SCSoundCloudAPIConfiguration.h"
#import "SCSoundCloudAPIAuthenticationDelegate.h"
#import "SCLoginViewController.h"

#if !TARGET_OS_IPHONE
#ifndef __GESTALT__
#include <Gestalt.h>
#endif
#endif


#import "SCSoundCloudAPIAuthentication.h"


@protocol SCSoundCloudAPIPrivateAuthenticationDelegate <NSObject, SCSoundCloudAPIAuthenticationDelegate>

- (NXOAuth2TrustMode)soundCloudAPITrustModeForHostname:(NSString *)hostname;
- (NSArray *)soundCloudAPITrustedCertificatesDERDataForHostname:(NSString *)hostname;

@end


@interface SCSoundCloudAPIAuthentication () <NXOAuth2ClientDelegate>
@property (assign, getter=isAuthenticated) BOOL authenticated;
@property (retain, readonly) id<SCSoundCloudAPIPrivateAuthenticationDelegate> privateDelegate;
#if TARGET_OS_IPHONE
- (void)displayLoginViewControllerWithURL:(NSURL *)URL;
- (void)dismissLoginViewController:(UIViewController *)viewController;
#endif
@end


@implementation SCSoundCloudAPIAuthentication

#pragma mark Lifecycle

- (id)initWithAuthenticationDelegate:(id<SCSoundCloudAPIAuthenticationDelegate>)aDelegate
					apiConfiguration:(SCSoundCloudAPIConfiguration *)aConfiguration;
{
	if (self = [super init]) {
		delegate = aDelegate;
        
		configuration = [aConfiguration retain];
		
		oauthClient = [[NXOAuth2Client alloc] initWithClientID:configuration.clientID
												  clientSecret:configuration.clientSecret
												  authorizeURL:configuration.authURL
													  tokenURL:configuration.accessTokenURL
													  delegate:self];
		oauthClient.userAgent = [SCSoundCloudAPIConfiguration userAgentString];
	}
	return self;
}

- (void)dealloc;
{
	[configuration release];
	[oauthClient release];
	[super dealloc];
}


#pragma mark Accessors

@synthesize oauthClient;
@synthesize configuration;
@synthesize authenticated;

- (id<SCSoundCloudAPIPrivateAuthenticationDelegate>)privateDelegate;
{
	return (id<SCSoundCloudAPIPrivateAuthenticationDelegate>)delegate;
}

#pragma mark Public

- (void)requestAuthentication;
{
	[oauthClient requestAccess];
}

- (void)resetAuthentication;
{
	oauthClient.accessToken = nil;
	
#if TARGET_OS_IPHONE
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSURL *authURL = self.configuration.authURL;
	NSArray *cookies = [cookieStorage cookiesForURL:authURL];
	for (NSHTTPCookie *cookie in cookies) {
		[cookieStorage deleteCookie:cookie];
	}
#endif
}

- (BOOL)handleRedirectURL:(NSURL *)redirectURL;
{
	return [oauthClient openRedirectURL:redirectURL];
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password;
{
	[oauthClient authenticateWithUsername:username password:password];
}

- (NSInteger)trustModeForHostname:(NSString *)hostname;
{
	if ([self.privateDelegate respondsToSelector:@selector(soundCloudAPITrustModeForHostname:)]) {
		return [self.privateDelegate soundCloudAPITrustModeForHostname:hostname];
	}
	return NXOAuth2TrustModeSystem;
}

- (NSArray *)trustedCertificatesDERDataForHostname:(NSString *)hostname;
{
	if ([self.privateDelegate respondsToSelector:@selector(soundCloudAPITrustedCertificatesDERDataForHostname:)]) {
		return [self.privateDelegate soundCloudAPITrustedCertificatesDERDataForHostname:hostname];
	}
	NSAssert(NO, @"You need to implement soundCloudAPITrustedCertificatesDERDataForHostname: in the delegate if you specify NXOAuth2TrustModeSpecificCertificate");
	return nil;
}

#pragma mark NXOAuth2ClientDelegate

//TODO: Error handling if using the LoginViewController

- (void)oauthClientNeedsAuthentication:(NXOAuth2Client *)client;
{
	NSURL *authorizationURL = nil;
	if (configuration.redirectURL) {
		authorizationURL = [client authorizationURLWithRedirectURL:configuration.redirectURL];
	}
    if ([delegate respondsToSelector:@selector(soundCloudAPIPreparedAuthorizationURL:)]) {
        [delegate soundCloudAPIPreparedAuthorizationURL:authorizationURL];
    }
#if TARGET_OS_IPHONE
    [self displayLoginViewControllerWithURL:authorizationURL];
#endif
         
}

- (void)oauthClientDidLoseAccessToken:(NXOAuth2Client *)client;
{
	self.authenticated = NO;
    if ([delegate respondsToSelector:@selector(soundCloudAPIDidResetAuthentication)]){
        [delegate soundCloudAPIDidResetAuthentication];
    }
}

- (void)oauthClientDidGetAccessToken:(NXOAuth2Client *)client;
{
	self.authenticated = YES;
    if ([delegate respondsToSelector:@selector(soundCloudAPIDidAuthenticate)]) {
        [delegate soundCloudAPIDidAuthenticate];
    }
}

- (void)oauthClient:(NXOAuth2Client *)client didFailToGetAccessTokenWithError:(NSError *)error;
{
    if ([delegate respondsToSelector:@selector(soundCloudAPIDidFailToGetAccessTokenWithError:)]) {
        [delegate soundCloudAPIDidFailToGetAccessTokenWithError:error];
    }
}

- (NXOAuth2TrustMode)connection:(NXOAuth2Connection *)connection trustModeForHostname:(NSString *)hostname;
{
    return [self trustModeForHostname:hostname];
}

- (NSArray *)connection:(NXOAuth2Connection *)connection trustedCertificatesForHostname:(NSString *)hostname;
{
    return [self trustedCertificatesDERDataForHostname:hostname];
}


#if TARGET_OS_IPHONE

#pragma mark Login ViewController

- (void)displayLoginViewControllerWithURL:(NSURL *)URL;
{    
    SCLoginViewController *loginViewController = [[[SCLoginViewController alloc] initWithURL:URL authentication:self] autorelease];
    
    /*
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:loginViewController] autorelease];
    navController.navigationBar.tintColor = [UIColor orangeColor];
    if ([navController respondsToSelector:@selector(setModalPresentationStyle:)]){
        [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    } */
	
	if ([delegate respondsToSelector:@selector(soundCloudAPIWillDisplayLoginViewController:)]) {
		[delegate soundCloudAPIWillDisplayLoginViewController:loginViewController];
	}
	
    if ([delegate respondsToSelector:@selector(soundCloudAPIDisplayViewController:)]) {
        [delegate soundCloudAPIDisplayViewController:loginViewController];
        
    } else if (![delegate respondsToSelector:@selector(soundCloudAPIPreparedAuthorizationURL:)]) {
        //do the presentation yourself when the delegate really does not respond to any of the callbacks for doing it himself
        NSArray *windows = [[UIApplication sharedApplication] windows];
        UIWindow *window = nil;
        if (windows.count > 0) window = [windows objectAtIndex:0];
        if ([window respondsToSelector:@selector(rootViewController)]) {
            UIViewController *rootViewController = [window rootViewController];
            [rootViewController presentModalViewController: loginViewController animated:YES];
        } else {
			NSAssert(NO, @"If you're not on iOS4 you need to implement -soundCloudAPIDisplayViewController: or show your own authentication controller in -soundCloudAPIPreparedAuthorizationURL:");
        }
    }
}

- (void)dismissLoginViewController:(UIViewController *)viewController;
{
    if ([delegate respondsToSelector:@selector(soundCloudAPIDismissViewController:)]) {
        [delegate soundCloudAPIDismissViewController:viewController];
    }
    
    else if (![delegate respondsToSelector:@selector(soundCloudAPIPreparedAuthorizationURL:)]
        && ![delegate respondsToSelector:@selector(soundCloudAPIDisplayViewController:)]) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        UIWindow *window = nil;
        if (windows.count > 0) window = [windows objectAtIndex:0];
        if ([window respondsToSelector:@selector(rootViewController)]) {
            UIViewController *rootViewController = [window rootViewController];
            [rootViewController dismissModalViewControllerAnimated:YES];
        } else {
			NSAssert(NO, @"If you're not on iOS4 you need to implement -soundCloudAPIDismissViewController: or show your own authentication controller in -soundCloudAPIPreparedAuthorizationURL:");
		}
    }
}

#endif

@end
