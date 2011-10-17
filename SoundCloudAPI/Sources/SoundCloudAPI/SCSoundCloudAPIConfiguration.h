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

#define kSoundCloudAPIBaseURL				@"https://api.soundcloud.com"
#define kSoundCloudAPIAccessTokenURL        @"https://api.soundcloud.com/oauth2/token"
#define kSoundCloudAuthURL                  @"https://soundcloud.com/connect"

#define kSoundCloudSandboxAPIBaseURL        @"https://api.sandbox-soundcloud.com"
#define kSoundCloudSandboxAPIAccessTokenURL @"https://api.sandbox-soundcloud.com/oauth2/token"
#define kSoundCloudSandboxAuthURL           @"https://sandbox-soundcloud.com/connect"


@interface SCSoundCloudAPIConfiguration : NSObject {
	NSURL   *apiBaseURL;
	NSURL   *accessTokenURL;
	NSURL   *authURL;
	
	NSString    *clientID;
	NSString    *clientSecret;
	NSURL       *redirectURL;
}

+ (id)configurationForProductionWithClientID:(NSString *)clientID
                                clientSecret:(NSString *)clientSecret
                                 redirectURL:(NSURL *)redirectURL;

+ (id)configurationForSandboxWithClientID:(NSString *)clientID
                             clientSecret:(NSString *)clientSecret
                              redirectURL:(NSURL *)redirectURL;


- (id)initWithClientID:(NSString *)clientID
          clientSecret:(NSString *)clientSecret
           redirectURL:(NSURL *)redirectURL
            apiBaseURL:(NSURL *)apiBaseURL
        accessTokenURL:(NSURL *)accessTokenURL
               authURL:(NSURL *)authURL;

+ (NSString *)userAgentString;

@property (nonatomic, retain) NSURL *apiBaseURL;
@property (nonatomic, retain) NSURL *accessTokenURL;
@property (nonatomic, retain) NSURL *authURL;
@property (nonatomic, retain) NSString *clientID;
@property (nonatomic, retain) NSString *clientSecret;
@property (nonatomic, retain) NSURL *redirectURL;

@end


/**
 * consumerKey, consumerSecret and callbackURL are terms from the OAuth1 days.
 * you should switch over to the OAuth2 terminology
 */

@interface SCSoundCloudAPIConfiguration (Deprecation)

+ (id)configurationForProductionWithConsumerKey:(NSString *)consumerKey
                                 consumerSecret:(NSString *)consumerSecret
                                    callbackURL:(NSURL *)callbackURL __attribute__((deprecated));

+ (id)configurationForSandboxWithConsumerKey:(NSString *)consumerKey
                              consumerSecret:(NSString *)consumerSecret
                                 callbackURL:(NSURL *)callbackURL __attribute__((deprecated));


- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              callbackURL:(NSURL *)callbackURL
               apiBaseURL:(NSURL *)apiBaseURL
           accessTokenURL:(NSURL *)accessTokenURL
                  authURL:(NSURL *)authURL __attribute__((deprecated));

@property (nonatomic, retain) NSString *consumerKey __attribute__((deprecated));
@property (nonatomic, retain) NSString *consumerSecret __attribute__((deprecated));
@property (nonatomic, retain) NSURL *callbackURL __attribute__((deprecated));


@end