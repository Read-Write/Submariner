#import "SBPodcast.h"

@implementation SBPodcast


@synthesize statusImage;

- (NSImage *)statusImage {
    NSImage *result = [NSImage imageNamed:@"pending"];
    
    if([self.channelStatus isEqualToString:@"new"] || [self.channelStatus isEqualToString:@"completed"])
        result = [NSImage imageNamed:@"on"];
    
    if([self.channelStatus isEqualToString:@"downloading"] || [self.channelStatus isEqualToString:@"skipped"])
        result = [NSImage imageNamed:@"pending"];
    
    if([self.channelStatus isEqualToString:@"error"] || [self.channelStatus isEqualToString:@"deleted"])
        result = [NSImage imageNamed:@"off"];
    
    return result;
}

@end
