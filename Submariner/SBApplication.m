//
//  SBApplication.m
//  Submariner
//
//  Created by Rafaël Warnault on 15/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBApplication.h"
#import "SBAppDelegate.h"
#import <IOKit/hidsystem/ev_keymap.h>



@interface SBApplication ()
- (void)mediaKeyEvent:(int)key state:(BOOL)state;
@end



@implementation SBApplication


// init NSUserDefaults defaults settings (first launch)
+ (void)initialize {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *defaults = [[[NSMutableDictionary alloc] init] autorelease];
	
	[defaults setObject:@"submariner" forKey:@"clientIdentifier"];
    [defaults setObject:@"1.5.0" forKey:@"apiVersion"];
    
    [defaults setObject:[NSNumber numberWithInt:1]      forKey:@"playerBehavior"];
	[defaults setObject:[NSNumber numberWithFloat:0.5f] forKey:@"playerVolume"];
    [defaults setObject:[NSNumber numberWithInt:30]     forKey:@"requestTimeout"];
    [defaults setObject:[NSNumber numberWithInt:30]     forKey:@"refreshChatInterval"];
    [defaults setObject:[NSNumber numberWithInt:YES]    forKey:@"jumpInDock"];
    [defaults setObject:[NSNumber numberWithInt:YES]    forKey:@"dockBadges"];
    [defaults setObject:[NSNumber numberWithInt:YES]    forKey:@"enableCacheStreaming"];
    [defaults setObject:[NSNumber numberWithInt:NO]     forKey:@"autoRefreshChat"];
    [defaults setObject:[NSNumber numberWithInt:NO]     forKey:@"autoRefreshNowPlaying"];
    [defaults setObject:[NSNumber numberWithFloat:0.75] forKey:@"coverSize"];
    
	[userDefaults registerDefaults:defaults];
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


/**
 * Listen media key event from Apple Keyboard
 */
- (void)sendEvent:(NSEvent *)event {
    // Catch media key events
    if ([event type] == NSSystemDefined && [event subtype] == 8) {
        
        int keyCode = (([event data1] & 0xFFFF0000) >> 16);
        int keyFlags = ([event data1] & 0x0000FFFF);
        int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
                
        [self mediaKeyEvent:keyCode state:keyState];
        return;
    }
    
    // Continue on to super
    [super sendEvent:event];
}


/**
 * Treat the media key event
 */
- (void)mediaKeyEvent:(int)key state:(BOOL)state {
    switch (key) {
        // Play pressed
        case NX_KEYTYPE_PLAY:
            
            if (state == NO)
                [(SBAppDelegate *)[self delegate] playPause:self];
            
            break;
            
        // Rewind
        case NX_KEYTYPE_FAST:
            if (state == YES)
                [(SBAppDelegate *)[self delegate] nextTrack:self];
            
            break;
            
        // Previous
        case NX_KEYTYPE_REWIND:
            if (state == YES)
                [(SBAppDelegate *)[self delegate] previousTrack:self];
            
            break;
            
    }
    
}

@end
