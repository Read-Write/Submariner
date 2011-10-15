//
//  NSURL+Parameters.m
//  Sub
//
//  Created by nark on 23/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "NSURL+Parameters.h"


@implementation NSURL (Parameters)


+ (NSURL *)temporaryFileURL {
    
    NSString * temporaryDirectory = nil;
	NSString * tempDir = NSTemporaryDirectory();
	if (tempDir == nil)
		tempDir = @"/tmp";
	
	NSString *temDirName = [NSString stringWithFormat:@"fr.read-write.Sub-%d", [NSDate timeIntervalSinceReferenceDate]];
	NSString * aTemplate = [tempDir stringByAppendingPathComponent:temDirName];
	const char * fsTemplate = [aTemplate fileSystemRepresentation];
	NSMutableData * bufferData = [NSMutableData dataWithBytes: fsTemplate
													   length: strlen(fsTemplate)+1];
	char * buffer = (char *)[bufferData mutableBytes];
	mkdtemp(buffer);
	temporaryDirectory = [[NSFileManager defaultManager]
                          stringWithFileSystemRepresentation: buffer
                          length: strlen(buffer)];
    
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = [(NSString *)CFUUIDCreateString(nil, uuid) autorelease];
    CFRelease(uuid);
    
    NSString *finalPath = [temporaryDirectory stringByAppendingPathComponent:uuidString];    
    
    return [NSURL URLWithString:finalPath];
}

+ (id)URLWithString:(NSString *)string command:(NSString *)command parameters:(NSDictionary *)parameters {

    NSMutableString *params = nil;
    NSURL *url = nil;
    
    string = [string stringByAppendingPathComponent:command];
    url = [NSURL URLWithString:string];
    
    if (parameters != nil)
    {
        params = [[NSMutableString alloc] init];
        for (id key in parameters)
        {
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CFStringRef value = (CFStringRef)[[parameters objectForKey:key] copy];
            // Escape even the "reserved" characters for URLs 
            // as defined in http://www.ietf.org/rfc/rfc2396.txt
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                               value,
                                                                               NULL, 
                                                                               (CFStringRef)@";?:/@&=+$,", 
                                                                               kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedKey, value];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
    
    if (parameters != nil)
    {
        NSString *urlWithParams = [[url absoluteString] stringByAppendingFormat:@"?%@", params];
        url = [NSURL URLWithString:[urlWithParams stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    }
    
    if(self != nil) {
        // check strange missing slash 
        if([[url absoluteString] rangeOfString:@"://"].location == NSNotFound)
            url = [NSURL URLWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:@":/" withString:@"://"]];
    }
    
    if(params) {
        [params release];
        params = nil;
    }
    
        
    return url;
}


+ (id)URLWithString:(NSString *)string command:(NSString *)command parameters:(NSDictionary *)parameters andParameterString:(NSString *)paramString {

    NSMutableString *params = nil;
    NSURL *url = nil;
    
    // append command
    string = [string stringByAppendingPathComponent:command];
    
    // append parameters dictionary
    if (parameters != nil)
    {
        params = [[NSMutableString alloc] init];
        for (id key in parameters)
        {
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CFStringRef value = (CFStringRef)[[parameters objectForKey:key] copy];
            // Escape even the "reserved" characters for URLs 
            // as defined in http://www.ietf.org/rfc/rfc2396.txt
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                               value,
                                                                               NULL, 
                                                                               (CFStringRef)@";?:/@&=+$,", 
                                                                               kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedKey, value];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
    if (parameters != nil)  {
        string = [string stringByAppendingFormat:@"?%@", params];
        
        // append more string based parameters
        string = [string stringByAppendingString:paramString];
    }

    // check strange missing slash 
    if([[url absoluteString] rangeOfString:@"://"].location == NSNotFound)
        url = [NSURL URLWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:@":/" withString:@"://"]];
    
    // clean
    if(params) {
        [params release];
        params = nil;
    }
    
    
    return [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
}


@end
