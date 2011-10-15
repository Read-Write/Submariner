//
//  NSURL+Parameters.h
//  Sub
//
//  Created by nark on 23/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (Parameters)
+ (id)URLWithString:(NSString *)string command:(NSString *)command parameters:(NSDictionary *)parameters;
+ (id)URLWithString:(NSString *)string command:(NSString *)command parameters:(NSDictionary *)parameters andParameterString:(NSString *)params;

+ (NSURL *)temporaryFileURL;

@end
