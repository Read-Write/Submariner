//
//  UPreferences.m
//  DicomX
//
//  Created by nark on 20/03/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBPreferencesController.h"



@implementation SBPreferencesController


#pragma mark -
#pragma mark Class Methods

+ (NSString *)nibName
{
    return @"Preferences";
}



#pragma mark -
#pragma mark Instance Methods

-(void)awakeFromNib{
	[self.window setContentSize:[playerPreferenceView frame].size];
	[[self.window contentView] addSubview:playerPreferenceView];
	[bar setSelectedItemIdentifier:@"Player"];
	[self.window center];
    
    // create download popup
//    NSString *downloadLocation = [[[NSUserDefaults standardUserDefaults] valueForKey:@"downloadLocation"] stringByResolvingSymlinksInPath];
//    NSImage *fileIcon = [[NSWorkspace sharedWorkspace] iconForFile:downloadLocation];
//    NSString *downloadLocationName = [downloadLocation lastPathComponent];
//    
//    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:downloadLocationName action:nil keyEquivalent:@""];
//    [item setOnStateImage:fileIcon];
//    
//    [downloadLocationPopUp insertItemWithTitle:downloadLocationName atIndex:0];
//    [downloadLocationPopUp selectItemAtIndex:0];
    NSInteger selectedBehavior = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerBehavior"];
    [playerBehaviorMatrix selectCellAtRow:selectedBehavior column:0];
}



-(NSView *)viewForTag:(NSInteger)tag {
    NSView *view = nil;
	switch(tag) {
		case 0: default:    view = playerPreferenceView; break;
		case 1:             view = serversPreferenceView; break;
		case 2:             view = playerPreferenceView; break;
		case 3:             view = appearancePreferenceView; break;
        case 4:             view = updatesPreferenceView; break;
        case 5:             view = subsonicPreferenceView; break;
	}
    return view;
}


-(NSRect)newFrameForNewContentView:(NSView *)view {
	
    NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [self.window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;    
    NSRect frame = [self.window frame];
    
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}



-(NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	return [[toolbar items] valueForKey:@"itemIdentifier"];
}


-(IBAction)switchView:(id)sender {
	
	NSInteger tag = [sender tag];
	
	NSView *view = [self viewForTag:tag];
	NSView *previousView = [self viewForTag: currentViewTag];
	currentViewTag = tag;
	NSRect newFrame = [self newFrameForNewContentView:view];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.1];
	
	if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
	    [[NSAnimationContext currentContext] setDuration:1.0];
	
	[[[self.window contentView] animator] replaceSubview:previousView with:view];
	[[self.window animator] setFrame:newFrame display:YES];
	
	[NSAnimationContext endGrouping];
	
}


- (IBAction)setPlayerBehavior:(id)sender {
    NSInteger selectedBehavior = [sender selectedRow];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:selectedBehavior] 
                                             forKey:@"playerBehavior"];
}


- (IBAction)chooseDownloadLocation:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSString *downloadLocation = [[[NSUserDefaults standardUserDefaults] valueForKey:@"downloadLocation"] stringByResolvingSymlinksInPath];
    
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
    
    [openPanel beginSheetForDirectory:downloadLocation
                                file:nil
                                types:nil
                       modalForWindow:[self window]
                        modalDelegate:self
                       didEndSelector:@selector(downloadPanelDidEnd:returnCode:contextInfo:)
                          contextInfo:nil];
}


- (void)downloadPanelDidEnd: (NSOpenPanel *)panel returnCode: (NSInteger)returnCode contextInfo: (void *)contextInfo {
    
    if(returnCode == NSAlertDefaultReturn) {
        NSString *newLocation = [panel directory];
        [[NSUserDefaults standardUserDefaults] setObject:newLocation forKey:@"downloadLocation"];
        
        [downloadLocationPopUp removeItemAtIndex:0];
        
        NSString *downloadLocation = [[[NSUserDefaults standardUserDefaults] valueForKey:@"downloadLocation"] stringByResolvingSymlinksInPath];
        NSImage *fileIcon = [[NSWorkspace sharedWorkspace] iconForFile:downloadLocation];
        NSString *downloadLocationName = [downloadLocation lastPathComponent];
        
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:downloadLocationName action:nil keyEquivalent:@""];
        [item setOnStateImage:fileIcon];
        
        [downloadLocationPopUp insertItemWithTitle:downloadLocationName atIndex:0];
        [downloadLocationPopUp selectItemAtIndex:0];
    }
}


@end
