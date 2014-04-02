//
//  SBPodcastItemView.h
//  Submariner
//
//  Created by Rafaël Warnault on 24/08/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SBPodcastItemView : NSView {
	BOOL selected;
}
@property (readwrite) BOOL selected;
@end
