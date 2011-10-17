//
//  SCSoundCloudAPI+TestApp.h
//  iPhoneTestApp
//
//  Created by Ullrich Schäfer on 09.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "SCAPI.h"


@interface SCSoundCloudAPI (TestApp)

- (id)meWithContext:(id)context;

- (id)postTrackWithTitle:(NSString *)title
				 fileURL:(NSURL *)fileURL
				isPublic:(BOOL)isPublic
				 context:(id)context;

- (id)postTrackWithId:(NSNumber *)trackId
		toGroupWithId:(NSNumber *)groupId
			  context:(id)context;

@end
