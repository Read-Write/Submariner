//
//  SBTopbarView.h
//  Submariner
//
//  Created by Rafaël Warnault on 11/12/11.
//  Copyright (c) 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImage+Additions.h"


/* SBTopbar item dictionnary entry keys */
#define kSBTopbarItemIdentifier     @"kSBTopbarItemIdentifier"
#define kSBTopbarItemImage          @"kSBTopbarItemImage"
#define kSBTopbarItemImageActive    @"kSBTopbarItemImageActive"
#define kSBTopbarItemAction         @"kSBTopbarItemAction"
#define kSBTopbarItemSelected       @"kSBTopbarItemSelected"

@protocol SBTopbarViewDelegate;

@interface SBTopbarView : NSView {
    id<SBTopbarViewDelegate> _delegate;
    NSMutableArray *_items; // an array of mutable dict which represent item
}

@property (nonatomic, retain) IBOutlet id<SBTopbarViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *items;

- (void)setSelectedIndex:(NSInteger)index;

@end



@protocol SBTopbarViewDelegate <NSObject>
@required
- (NSArray *)itemsArrayForTopbarView:(SBTopbarView *)topbar;
- (void)topbarView:(SBTopbarView *)topbar didSelectItemAtIndex:(NSInteger)index; 
@end


