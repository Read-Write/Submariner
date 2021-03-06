//
//  NSURL+Parameters.m
//  Sub
//
//  Created by Rafaël Warnault on 23/05/11.
//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
