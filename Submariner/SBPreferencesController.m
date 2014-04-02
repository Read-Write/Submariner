//
//  UPreferences.m
//  DicomX
//
//  Created by nark on 20/03/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBPreferencesController.h"
#import "SBAppDelegate.h"
#import "DDHotKeyCenter.h"



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
    
    NSInteger selectedBehavior = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerBehavior"];
    [playerBehaviorMatrix selectCellAtRow:selectedBehavior column:0];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"maxBitRate" 
                                               options:NSKeyValueObservingOptionNew 
                                               context:nil];
    
    NSInteger code = [[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerKeyCode"];
    NSUInteger flags = [[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerKeyFlags"];
    KeyCombo key = SRMakeKeyCombo(code, flags);
    [hotKeyControl setKeyCombo:key];
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"maxBitRate"];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(object == [NSUserDefaults standardUserDefaults] && [keyPath isEqualToString:@"maxBitRate"]) {
        NSInteger newTag = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        if(newTag < 320 && newTag > 0) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Submariner limitation"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Submariner is not able to caculate the progression time below 320 kbit/s bitrate efficiently depending of the transcoded source bitrate. You could not seek into the timeline and time information will be unreliable. However, Subamriner will stream, play and cache download your track properly with the desired bitrate."];
            
            [alert setAlertStyle:NSInformationalAlertStyle];
            [alert runModal];
        }
    }
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


- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    NSLog(@"newKeyCombo code : %d", newKeyCombo.code);
    NSLog(@"newKeyCombo flag : %u", newKeyCombo.flags);
    
    if(newKeyCombo.code != -1 && newKeyCombo.flags != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:newKeyCombo.code forKey:@"PlayerKeyCode"];
        [[NSUserDefaults standardUserDefaults] setInteger:newKeyCombo.flags forKey:@"PlayerKeyFlags"];
    } else {
        NSInteger code = [[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerKeyCode"];
        NSUInteger flags = [[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerKeyFlags"];
        
        [[[SBAppDelegate sharedInstance] hotKeyCenter] unregisterHotKeyWithKeyCode:code modifierFlags:flags];
    }
}


@end
