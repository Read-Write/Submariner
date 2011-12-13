//
//  SBCoverSplitView.h
//  Submariner
//
//  Created by Rafaël Warnault on 12/12/11.
//  Copyright (c) 2011 OPALE. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SBCoverSplitView : NSSplitView <NSSplitViewDelegate> {
    IBOutlet NSView *handleView;
}

@end
