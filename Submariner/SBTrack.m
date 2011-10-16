#import "SBTrack.h"
#import "SBArtist.h"
#import "SBServer.h"
#import "SBCover.h"
#import "SBAlbum.h"
#import "NSURL+Parameters.h"
#import "NSString+Time.h"


@implementation SBTrack


@synthesize durationString;
@synthesize artistString;
@synthesize albumString;
@synthesize playingImage;
@synthesize coverImage;
@synthesize onlineImage;




+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *result = nil;
    if([key isEqualToString:@"durationString"]) {
        result = [NSSet setWithObjects:@"duration", nil];
    }
    if([key isEqualToString:@"playingImage"]) {
        result = [NSSet setWithObjects:@"isPlaying", nil];
    }
    if([key isEqualToString:@"onlineImage"]) {
        result = [NSSet setWithObjects:@"isLocal", nil];
    }
    return result;
}

- (void)awakeFromInsert {
    if(self.cover == nil) {
        [self setCover:[SBCover insertInManagedObjectContext:self.managedObjectContext]];
    }
}


- (NSString *)durationString {
    NSString *string = nil;
    
    [self willAccessValueForKey:@"duration"];
    string = [NSString stringWithTime:[self.duration intValue]];
    [self didAccessValueForKey:@"duration"];
    
    return string;
}

- (NSURL *)streamURL {
    NSMutableString *params = nil;
    NSURL *finalURL = nil;
    
    // the default URL parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.server.username forKey:@"u"];
    [parameters setValue:self.server.password forKey:@"p"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiVersion"] forKey:@"v"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"clientIdentifier"] forKey:@"c"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"maxBitRate"] forKey:@"maxBitRate"];
    [parameters setValue:self.id forKey:@"id"];
    
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
    [parameters setValue:self.server.password forKey:@"p"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiVersion"] forKey:@"v"];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"clientIdentifier"] forKey:@"c"];
    [parameters setValue:self.id forKey:@"id"];
    
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


- (NSImage *)playingImage {
    if([self.isPlaying boolValue])
        return [NSImage imageNamed:@"playing"];
    
    return nil;
}

- (NSImage *)coverImage {
    return [self.album imageRepresentation];
}

- (NSString *)artistString {
    artistString = [self.album.artist itemName];
    
    if(artistString == nil) {
        artistString = self.artistName;
    }
    
    return artistString;
}

- (NSString *)albumString {
    NSString *ret = nil;
    ret = [self.album itemName];
    
    if(ret == nil) {
        ret = self.albumName;
    }
    
    return ret;
}


- (NSImage *)onlineImage {
    if(![self.isLocal boolValue]) {
        if (self.localTrack != nil) {
            return [NSImage imageNamed:@"cached"];
        } else {
            return [NSImage imageNamed:@"online"];
        }
    }
    
    return nil;
}


@end
