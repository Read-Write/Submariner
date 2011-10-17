#import "SBEpisode.h"
#import "NSString+Time.h"
#import "NSString+Hex.h"
#import "SBServer.h"
#import "SBPodcast.h"


@implementation SBEpisode

@synthesize statusImage;

- (NSImage *)statusImage {
    NSImage *result = [NSImage imageNamed:@"pending"];
    
    if([self.episodeStatus isEqualToString:@"new"] || [self.episodeStatus isEqualToString:@"completed"])
        result = [NSImage imageNamed:@"on"];
    
    if([self.episodeStatus isEqualToString:@"downloading"] || [self.episodeStatus isEqualToString:@"skipped"])
        result = [NSImage imageNamed:@"pending"];
    
    if([self.episodeStatus isEqualToString:@"error"] || [self.episodeStatus isEqualToString:@"deleted"])
        result = [NSImage imageNamed:@"off"];
    
    return result;
}


- (NSURL *)streamURL {
    NSMutableString *params = nil;
    NSURL *finalURL = nil;
    
    // the default URL parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.server.username forKey:@"u"];
    [parameters setValue:[@"enc:" stringByAppendingString:[NSString stringToHex:self.server.password]] forKey:@"p"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiVersion"] forKey:@"v"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"clientIdentifier"] forKey:@"c"];
    [parameters setValue:self.streamID forKey:@"id"];
    
    finalURL = [NSURL URLWithString:[self.server.url stringByAppendingPathComponent:@"rest/stream.view"]];
    
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
    
    if (parameters != nil) {
        
        NSString *urlWithParams = [[finalURL absoluteString] stringByAppendingFormat:@"?%@", params];
        finalURL = [NSURL URLWithString:urlWithParams];
    }
    
    // check strange missing slash 
    if(finalURL != nil) {
        if([[finalURL absoluteString] rangeOfString:@"://"].location == NSNotFound)
            finalURL = [NSURL URLWithString:[[finalURL absoluteString] stringByReplacingOccurrencesOfString:@":/" withString:@"://"]];
    }
    
    return finalURL;
}


- (NSURL *)downloadURL {
    NSMutableString *params = nil;
    NSURL *finalURL = nil;
    
    // the default URL parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.server.username forKey:@"u"];
    [parameters setValue:[@"enc:" stringByAppendingString:[NSString stringToHex:self.server.password]] forKey:@"p"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiVersion"] forKey:@"v"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"clientIdentifier"] forKey:@"c"];
    [parameters setValue:self.streamID forKey:@"id"];
    
    finalURL = [NSURL URLWithString:[self.server.url stringByAppendingPathComponent:@"rest/download.view"]];
    
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
    
    if (parameters != nil) {
        NSString *urlWithParams = [[finalURL absoluteString] stringByAppendingFormat:@"?%@", params];
        finalURL = [NSURL URLWithString:urlWithParams];
    }
    
    // check strange missing slash 
    if(finalURL != nil) {
        if([[finalURL absoluteString] rangeOfString:@"://"].location == NSNotFound)
            finalURL = [NSURL URLWithString:[[finalURL absoluteString] stringByReplacingOccurrencesOfString:@":/" withString:@"://"]];
    }
    
    return finalURL;
}


- (NSString *)artistString {
    return self.podcast.itemName;
}

- (NSString *)albumString {
    return self.episodeDescription;
}

@end
