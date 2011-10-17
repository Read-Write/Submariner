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

#import "SCAPIErrors.h"
#import "SCSoundCloudAPIConfiguration.h"
#import "SCSoundCloudAPIAuthentication.h"
#import "SCSoundCloudAPIAuthenticationDelegate.h"
#import "SCSoundCloudAPIDelegate.h"

#import "SCAudioStream.h"

#import "NSString+SoundCloudAPI.h"

#import "SCSoundCloudAPI.h"



@interface SCSoundCloudAPI () <NXOAuth2ConnectionDelegate>

- (NSString *)_responseTypeFromEnum:(SCResponseFormat)responseFormat;
- (NSMutableURLRequest *)_requestForMethod:(NSString *)httpMethod
								onResource:(NSString *)resource;

// private initializer used for NSCopying
- (id)initWithDelegate:(id<SCSoundCloudAPIDelegate>)aDelegate
		authentication:(SCSoundCloudAPIAuthentication *)anAuthentication;
@end


@implementation SCSoundCloudAPI

#pragma mark Lifecycle

- (id)initWithDelegate:(id<SCSoundCloudAPIDelegate>)theDelegate
authenticationDelegate:(id<SCSoundCloudAPIAuthenticationDelegate>)authDelegate
	  apiConfiguration:(SCSoundCloudAPIConfiguration *)configuration;

{
	SCSoundCloudAPIAuthentication *anAuthentication =  [[SCSoundCloudAPIAuthentication alloc] initWithAuthenticationDelegate:authDelegate
																											apiConfiguration:configuration];
	return [self initWithDelegate:theDelegate authentication:anAuthentication];
}

- (id)initWithDelegate:(id<SCSoundCloudAPIDelegate>)aDelegate
		authentication:(SCSoundCloudAPIAuthentication *)anAuthentication;
{
	if (self = [super init]) {
		responseFormat = SCResponseFormatJSON;
		delegate = aDelegate;
		authentication = [anAuthentication retain];
		apiConnections = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc;
{
	for(SCSoundCloudConnection *connection in [apiConnections allValues]) {
		[connection cancel];
	}
	[apiConnections release];
	[authentication release];
	[super dealloc];
}


#pragma mark Accessors

@synthesize responseFormat;

- (BOOL)isAuthenticated;
{
	return authentication.authenticated;
}

#pragma mark Public methods

- (void)checkAuthentication;
{
	[authentication requestAuthentication];
}

- (void)resetAuthentication;
{
	[authentication resetAuthentication];
}

- (BOOL)handleRedirectURL:(NSURL *)redirectURL;
{
	return [authentication handleRedirectURL:redirectURL];
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password;
{
	[authentication authenticateWithUsername:username password:password];
}


#pragma mark Private

- (NSString *)_responseTypeFromEnum:(SCResponseFormat)inResponseFormat;
{
	switch (inResponseFormat) {
		case SCResponseFormatJSON:
			return @"application/json";
		case SCResponseFormatXML:
		default:
			return @"application/xml";
	}	
}

- (NSMutableURLRequest *)_requestForMethod:(NSString *)httpMethod
								onResource:(NSString *)resource;
{
    if (!authentication.configuration.apiBaseURL) {
		NSLog(@"API is not configured with base URL");
		return nil;
	}
	
	NSURL *url = [NSURL URLWithString:resource relativeToURL:authentication.configuration.apiBaseURL];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[request addValue:[self _responseTypeFromEnum:self.responseFormat] forHTTPHeaderField:@"Accept"];
	
	[request setHTTPMethod:[httpMethod uppercaseString]];
    return request;
}

#pragma mark API method

- (id)performMethod:(NSString *)httpMethod
		 onResource:(NSString *)resource
	 withParameters:(NSDictionary *)parameters
			context:(id)context
		   userInfo:(id)userInfo;
{
	NSMutableURLRequest *request = [self _requestForMethod:httpMethod onResource:resource];
	
	NXOAuth2Connection *connection = [[NXOAuth2Connection alloc] initWithRequest:request
															   requestParameters:parameters
																	 oauthClient:authentication.oauthClient
																		delegate:self];
	connection.context = context;
	connection.userInfo = userInfo;
	
    id connectionId = [NSString stringWithUUID];
	[apiConnections setObject:connection forKey:connectionId];
    [connection release];
	return connectionId;
}

#if NX_BLOCKS_AVAILABLE && NS_BLOCKS_AVAILABLE
- (id)performMethod:(NSString *)httpMethod
         onResource:(NSString *)resource
     withParameters:(NSDictionary *)parameters
             finish:(void (^)(NSData *data))finishBlock 
               fail:(void (^)(NSError *error))failBlock
            context:(id)context
		   userInfo:(id)userInfo;
{
    NSMutableURLRequest *request = [self _requestForMethod:httpMethod onResource:resource];
    
	__block NXOAuth2Connection *connection = nil;
    connection = [[NXOAuth2Connection alloc] initWithRequest:request
										   requestParameters:parameters
                                                 oauthClient:authentication.oauthClient
                                                      finish:^(void){
                                                          NSLog(@"Connection: %@", connection);
                                                          finishBlock(connection.data);
                                                      } 
                                                        fail:failBlock];
    connection.delegate = self;
	connection.context = context;
	connection.userInfo = userInfo;
	
    id connectionId = [NSString stringWithUUID];
	[apiConnections setObject:connection forKey:connectionId];
    [connection release];
	return connectionId;
}
#endif

- (void)cancelConnection:(id)connectionId;
{
	SCSoundCloudConnection *connection = [apiConnections objectForKey:connectionId];
	if (connection) {
		[connection cancel];
		[apiConnections removeObjectForKey:connectionId];
	}
}


#pragma mark Streaming

- (SCAudioStream *)audioStreamWithURL:(NSURL *)streamURL;
{
	return [[[SCAudioStream alloc] initWithURL:streamURL authentication:authentication] autorelease];
}


#pragma mark NXOAuth2ConnectionDelegate

- (void)oauthConnection:(NXOAuth2Connection *)connection didFinishWithData:(NSData *)data;
{
	[[connection retain] autorelease];
	[apiConnections removeObjectsForKeys:[apiConnections allKeysForObject:connection]];
	if ([delegate respondsToSelector:@selector(soundCloudAPI:didFinishWithData:context:userInfo:)]) {
		[delegate soundCloudAPI:self didFinishWithData:data context:connection.context userInfo:connection.userInfo];
	}
}

- (void)oauthConnection:(NXOAuth2Connection *)connection didFailWithError:(NSError *)error;
{
	[[connection retain] autorelease];
	[apiConnections removeObjectsForKeys:[apiConnections allKeysForObject:connection]];
	if ([delegate respondsToSelector:@selector(soundCloudAPI:didFailWithError:context:userInfo:)]) {
		[delegate soundCloudAPI:self didFailWithError:error context:connection.context userInfo:connection.userInfo];
	}
}

- (void)oauthConnection:(NXOAuth2Connection *)connection didReceiveData:(NSData *)data;
{
	if ([delegate respondsToSelector:@selector(soundCloudAPI:didReceiveData:context:userInfo:)]) {
		[delegate soundCloudAPI:self didReceiveData:data context:connection.context userInfo:connection.userInfo];
	}
	if ([delegate respondsToSelector:@selector(soundCloudAPI:didReceiveBytes:total:context:userInfo:)]) {
		[delegate soundCloudAPI:self didReceiveBytes:connection.data.length total:connection.expectedContentLength context:connection.context userInfo:connection.userInfo];
	}
}

- (void)oauthConnection:(NXOAuth2Connection *)connection didSendBytes:(unsigned long long)bytesSend ofTotal:(unsigned long long)bytesTotal;
{
	if ([delegate respondsToSelector:@selector(soundCloudAPI:didSendBytes:total:context:userInfo:)]) {
		[delegate soundCloudAPI:self didSendBytes:bytesSend total:bytesTotal context:connection.context userInfo:connection.userInfo];
	}
}

#pragma mark NSCopying

- (id)copy;
{
	SCSoundCloudAPI *copy = [[[self class] alloc] initWithDelegate:delegate
													authentication:authentication];	// same authentication
	copy->responseFormat = responseFormat;
	return copy;
}

- (id)copyWithZone:(NSZone *)zone;
{
	return [self copy];
}

- (id)copyWithAPIDelegate:(id)apiDelegate;
{
	SCSoundCloudAPI *copy = [self copy];	// same authentication
	copy->delegate = apiDelegate;
	return copy;
}


@end

