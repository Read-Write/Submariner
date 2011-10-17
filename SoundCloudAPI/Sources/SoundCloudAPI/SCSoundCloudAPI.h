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

#import <Foundation/Foundation.h>

#import "SCSoundCloudAPIDelegate.h"
#import "SCSoundCloudAPIAuthenticationDelegate.h"

@class NXOAuth2Client;
@class SCSoundCloudAPIConfiguration;
@class SCSoundCloudConnection;
@class SCSoundCloudAPIAuthentication;
@class SCAudioStream;

typedef enum {
	SCResponseFormatXML,
	SCResponseFormatJSON
} SCResponseFormat;


@interface SCSoundCloudAPI : NSObject <NSCopying> {
	SCSoundCloudAPIAuthentication *authentication;
	SCResponseFormat responseFormat;				// default is SCResponseFormatJSON
	
	NSMutableDictionary *apiConnections;
	
	id<SCSoundCloudAPIDelegate> delegate;
}

@property (nonatomic, assign) SCResponseFormat responseFormat;
@property (nonatomic, readonly, getter=isAuthenticated) BOOL authenticated;	// this might change dynamically. Not observable, atm


/*!
 * initialize the api object
 */
- (id)initWithDelegate:(id<SCSoundCloudAPIDelegate>)delegate
authenticationDelegate:(id<SCSoundCloudAPIAuthenticationDelegate>)authDelegate
	  apiConfiguration:(SCSoundCloudAPIConfiguration *)configuration;

/*!
 * pass along an existing api object
 */
- (id)copyWithAPIDelegate:(id)apiDelegate;


#pragma mark Connection Handling

/*!
 * invokes a request using the specified HTTP method on the specified resource
 * returns a connection identifier that can be used to cancel the connection
 */
- (id)performMethod:(NSString *)httpMethod
		 onResource:(NSString *)resource
	 withParameters:(NSDictionary *)parameters
			context:(id)context
		   userInfo:(id)userInfo;

#if NX_BLOCKS_AVAILABLE && NS_BLOCKS_AVAILABLE

// WARNING: Compiling SoundCloud API with Blocks. This is an unsupported feature.

- (id)performMethod:(NSString *)httpMethod
         onResource:(NSString *)resource
     withParameters:(NSDictionary *)parameters
             finish:(void (^)(NSData *data))finishBlock 
               fail:(void (^)(NSError *error))failBlock
            context:(id)context
		   userInfo:(id)userInfo;
#endif

/*!
 * cancels the connection with the particular connection identifier
 */
- (void)cancelConnection:(id)connectionId;


#pragma mark Authentication

/*!
 * checks if authenticated, and if not lets you know in the authDelegate
 */
- (void)checkAuthentication;

/*!
 * resets token to nil, and removes it from the keychain
 */
- (void)resetAuthentication;

//TODO: rename -handleRedirectURL: ?
/*!
 * When your app receives the callback via its callback URL, pass it on to this method.
 * Returns YES if the redirectURL was handled
 */
- (BOOL)handleRedirectURL:(NSURL *)redirectURL;

/*!
 * !!!ONLY!!! use this method to pass Username & Password on Credentials flow
 * Normally, you should use -checkAuthentication
 */
- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password;


#pragma mark Streaming

/*!
 * 
 */

- (SCAudioStream *)audioStreamWithURL:(NSURL *)streamURL;

@end
