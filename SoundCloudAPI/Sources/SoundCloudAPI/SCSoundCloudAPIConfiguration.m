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

#import "SCSoundCloudAPIConfiguration.h"

#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

@interface SCSoundCloudAPIConfiguration ()

+ (NSString *)sysctlValueForName:(NSString *)name;

@end

@implementation SCSoundCloudAPIConfiguration


#pragma mark Class Methods

+ (id)configurationForProductionWithClientID:(NSString *)clientID
                                clientSecret:(NSString *)clientSecret
                                 redirectURL:(NSURL *)redirectURL;
{
	return [[[self alloc] initWithClientID:clientID
                              clientSecret:clientSecret
                               redirectURL:redirectURL
                                apiBaseURL:[NSURL URLWithString:kSoundCloudAPIBaseURL]
                            accessTokenURL:[NSURL URLWithString:kSoundCloudAPIAccessTokenURL]
                                   authURL:[NSURL URLWithString:kSoundCloudAuthURL]] autorelease];
}


+ (id)configurationForSandboxWithClientID:(NSString *)clientID
                             clientSecret:(NSString *)clientSecret
                              redirectURL:(NSURL *)redirectURL;
{
	return [[[self alloc] initWithClientID:clientID
                              clientSecret:clientSecret
                               redirectURL:redirectURL
                                apiBaseURL:[NSURL URLWithString:kSoundCloudSandboxAPIBaseURL]
                            accessTokenURL:[NSURL URLWithString:kSoundCloudSandboxAPIAccessTokenURL]
                                   authURL:[NSURL URLWithString:kSoundCloudSandboxAuthURL]] autorelease];
}


#pragma mark Lifecycle

- (id)initWithClientID:(NSString *)inClientID
          clientSecret:(NSString *)inClientSecret
           redirectURL:(NSURL *)inRedirectURL
            apiBaseURL:(NSURL *)inApiBaseURL
        accessTokenURL:(NSURL *)inAccessTokenURL
               authURL:(NSURL *)inAuthURL;
{
	NSAssert(inClientID, @"No Client ID supplied");
	NSAssert(inClientSecret, @"No Client Secret supplied");
    //NSAssert(inRedirectURL, @"No Redirect URL supplied"); // no redirectURL required when doing user credentials flow
    NSAssert(inApiBaseURL, @"No Api Base URL supplied");
    NSAssert(inAccessTokenURL, @"No Access Token URL supplied");
    NSAssert(inAuthURL, @"No Auth URL supplied");
	
	if (self = [super init]) {
		apiBaseURL = [inApiBaseURL retain];
		accessTokenURL = [inAccessTokenURL retain];
		authURL = [inAuthURL retain];
		
		clientID = [inClientID retain];
		clientSecret = [inClientSecret retain];
		redirectURL = [inRedirectURL retain];
	}
	return self;	
}

-(void)dealloc;
{
	[apiBaseURL release]; apiBaseURL = nil;
	[accessTokenURL release]; accessTokenURL = nil;
	[authURL release]; authURL = nil;
	
	[clientID release]; clientID = nil;
	[clientSecret release]; clientSecret = nil;
	[redirectURL release]; redirectURL = nil;
	[super dealloc];
}

#pragma mark Accessors

@synthesize apiBaseURL, accessTokenURL, authURL;
@synthesize clientID, clientSecret;
@synthesize redirectURL;

#pragma mark User Agent String

+ (NSString *)userAgentString;
{
	NSMutableString *userAgentString = [NSMutableString string];
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	[userAgentString appendFormat:@"%@/%@;", appName, appVersion];
	
	NSString *apiWrapperName = @"SCSoundCloudAPI";
	NSString *apiWrapperVersion = SCAPI_VERSION;
	[userAgentString appendFormat:@" %@/%@;", apiWrapperName, apiWrapperVersion];
	
	NSString *hwModel = nil;
	NSString *hwMachine = [self sysctlValueForName:@"hw.machine"];
#if TARGET_OS_IPHONE
	UIDevice *device = [UIDevice currentDevice];
	hwModel = [device model]; // we take model for device
#else
	hwModel = @"Mac";
#endif
	if (hwModel && hwMachine) {
		[userAgentString appendFormat:@" %@/%@;", hwModel, hwMachine];
	}
	
	NSString *osType = nil;
	NSString *osRelease = nil;
#if TARGET_OS_IPHONE
	osType = [device systemName];
	osRelease = [device systemVersion];
#else
	osType = @"Mac OS X";
	SInt32 versMajor, versMinor, versBugFix;
	Gestalt(gestaltSystemVersionMajor, &versMajor);
	Gestalt(gestaltSystemVersionMinor, &versMinor);
	Gestalt(gestaltSystemVersionBugFix, &versBugFix);
	osRelease = [NSString stringWithFormat:@"%d.%d.%d", versMajor, versMinor, versBugFix];
#endif
	if (osType && osRelease) {
		[userAgentString appendFormat:@" %@/%@;", osType, osRelease];
	}
	
	NSString *darwinType = [self sysctlValueForName:@"kern.ostype"];
	NSString *darwinRelease = [self sysctlValueForName:@"kern.osrelease"];
	if (darwinType && darwinRelease) {
		[userAgentString appendFormat:@" %@/%@", darwinType, darwinRelease];
	}
	
	return userAgentString;
}

+ (NSString *)sysctlValueForName:(NSString *)name;
{
	size_t size;
	const char* cName = [name UTF8String];
	if (sysctlbyname(cName, NULL, &size, NULL, 0) != noErr) return nil;
	
	NSString *value = nil;
	char *cValue = malloc(size);
	if (sysctlbyname(cName, cValue, &size, NULL, 0) == noErr) {
		value = [NSString stringWithCString:cValue encoding:NSUTF8StringEncoding];
	}
	free(cValue);
	return value;
}

@end


// this will go away soon
@implementation SCSoundCloudAPIConfiguration (Deprecation)

+ (id)configurationForProductionWithConsumerKey:(NSString *)consumerKey
                                 consumerSecret:(NSString *)consumerSecret
                                    callbackURL:(NSURL *)callbackURL;
{
    return [self configurationForProductionWithClientID:consumerKey clientSecret:consumerSecret redirectURL:callbackURL];
}

+ (id)configurationForSandboxWithConsumerKey:(NSString *)consumerKey
                              consumerSecret:(NSString *)consumerSecret
                                 callbackURL:(NSURL *)callbackURL;
{
    return [self configurationForSandboxWithClientID:consumerKey clientSecret:consumerSecret redirectURL:callbackURL];
}


- (id)initWithConsumerKey:(NSString *)inConsumerKey
           consumerSecret:(NSString *)inConsumerSecret
              callbackURL:(NSURL *)inCallbackURL
               apiBaseURL:(NSURL *)inApiBaseURL
           accessTokenURL:(NSURL *)inAccessTokenURL
                  authURL:(NSURL *)inAuthURL;
{
    return [self initWithClientID:inConsumerKey clientSecret:inConsumerSecret redirectURL:inCallbackURL apiBaseURL:inApiBaseURL accessTokenURL:inAccessTokenURL authURL:inAuthURL];
}

- (NSString *)consumerKey;
{
    return self.clientID;
}

- (void)setConsumerKey:(NSString *)consumerKey;
{
    self.clientID = consumerKey;
}

- (NSString *)consumerSecret;
{
    return self.clientSecret;
}

- (void)setConsumerSecret:(NSString *)consumerSecret;
{
    self.clientSecret = consumerSecret;
}

- (NSURL *)callbackURL;
{
    return self.redirectURL;
}

- (void)setCallbackURL:(NSURL *)callbackURL;
{
    self.redirectURL = callbackURL;
}

@end
