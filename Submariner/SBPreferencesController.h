//
//  UPreferences.h
//  DicomX
//
//  Created by nark on 20/03/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBWindowController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface SBPreferencesController : SBWindowController <NSToolbarDelegate> {

	IBOutlet NSToolbar  *bar;
	IBOutlet NSView *generalPreferenceView;
	IBOutlet NSView *serversPreferenceView;
    IBOutlet NSView *playerPreferenceView;
    IBOutlet NSView *appearancePreferenceView;
	IBOutlet NSView *updatesPreferenceView;
	IBOutlet NSView *subsonicPreferenceView;
    IBOutlet NSMatrix *playerBehaviorMatrix;
    IBOutlet NSPopUpButton *downloadLocationPopUp;
    IBOutlet SRRecorderControl *hotKeyControl;
    
	NSInteger currentViewTag;
}

- (IBAction)switchView:(id)sender;
- (IBAction)chooseDownloadLocation:(id)sender;
- (IBAction)setPlayerBehavior:(id)sender;
- (NSView *)viewForTag:(NSInteger)tag;
- (NSRect)newFrameForNewContentView:(NSView *)view;

@end
