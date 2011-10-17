//
//  SCSoundCloudAPI+TestApp.m
//  iPhoneTestApp
//
//  Created by Ullrich Schäfer on 09.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCSoundCloudAPI+TestApp.h"


@implementation SCSoundCloudAPI (TestApp)

- (id)meWithContext:(id)context;
{
	return [self performMethod:@"GET"
					onResource:@"/me"
				withParameters:nil
					   context:context
					  userInfo:nil];
}

- (id)postTrackWithTitle:(NSString *)title
				 fileURL:(NSURL *)fileURL
				isPublic:(BOOL)public
				 context:(id)context;
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:title forKey:@"track[title]"];
	[parameters setObject:(public ? @"public" : @"private") forKey:@"track[sharing]"];
	[parameters setObject:fileURL forKey:@"track[asset_data]"];
	
	return [self performMethod:@"POST"
					onResource:@"tracks"
				withParameters:parameters
					   context:context
					  userInfo:nil];
}

- (id)postTrackWithId:(NSNumber *)trackId
		toGroupWithId:(NSNumber *)groupId
			  context:(id)context;
{
	NSString *resource = [NSString stringWithFormat:@"/groups/%@/contributions/%@", groupId, trackId];
	return [self performMethod:@"PUT"
					onResource:resource
				withParameters:nil
					   context:@"addToGroup"
					  userInfo:nil];
}

@end
