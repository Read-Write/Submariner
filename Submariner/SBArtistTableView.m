//
//  SBArtistTableView.m
//  Submariner
//
//  Created by Rafaël Warnault on 15/10/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBArtistTableView.h"
#import "NSGradient+SourceList.h"


@implementation SBArtistTableView

#pragma mark -
#pragma mark Drawing methods

- (id)_highlightColorForCell:(NSCell *)cell;
{
    return nil;
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
    NSRange aVisibleRowIndexes = [self rowsInRect:clipRect];
    NSIndexSet *aSelectedRowIndexes = [self selectedRowIndexes];
    NSInteger aRow = aVisibleRowIndexes.location;
    NSInteger anEndRow = aRow + aVisibleRowIndexes.length;
    
    NSColor *aColor = [NSColor blackColor];
    [aColor set];
    
    BOOL isKey = [[[self window] firstResponder] isEqual:self]; 
    NSGradient *gradient = [NSGradient sourceListSelectionGradient:isKey];
    
    // draw highlight for the visible, selected rows
    [NSGraphicsContext saveGraphicsState];
    for(aRow; aRow < anEndRow; aRow++) {
        if([aSelectedRowIndexes containsIndex:aRow]) {
            
            
            NSRect aRowRect = [self rectOfRow:aRow];
            [gradient drawInRect:aRowRect angle:90];
            
            NSRect bottomLineRect = NSMakeRect(aRowRect.origin.x, 
                                               aRowRect.origin.y+aRowRect.size.height, 
                                               aRowRect.size.width, 
                                               1);
            
            if(isKey) {
                [[NSColor colorWithCalibratedRed:0.1567 green:0.3942 blue:0.7096 alpha:1.0000] set];
            } else {
                [[NSColor colorWithCalibratedRed:0.5020 green:0.5518 blue:0.6759 alpha:1.0000] set];
            }
            //NSFrameRect(bottomLineRect);
            //NSRectFill(bottomLineRect);
            
            NSRect topLineRect = NSMakeRect(aRowRect.origin.x, 
                                            aRowRect.origin.y, 
                                            aRowRect.size.width, 
                                            1);
            if(isKey) {
                [[NSColor colorWithCalibratedRed:0.1701 green:0.4463 blue:0.7877 alpha:1.0000] set];
            } else {
                [[NSColor colorWithCalibratedRed:0.6807 green:0.7196 blue:0.8052 alpha:1.0000] set];
            }
            
            NSFrameRect(topLineRect);
            
            NSRect topLightLineRect = NSMakeRect(aRowRect.origin.x, 
                                                 aRowRect.origin.y+1, 
                                                 aRowRect.size.width, 
                                                 1);
            
            if(isKey) {
                [[NSColor colorWithCalibratedRed:0.3763 green:0.6640 blue:0.8984 alpha:1.0000] set];
            } else {
                [[NSColor colorWithCalibratedRed:0.7171 green:0.7517 blue:0.8476 alpha:1.0000] set];
            }
            NSFrameRect(topLightLineRect);
            
            [self setNeedsDisplay:YES];
        }
    }
    [NSGraphicsContext restoreGraphicsState];
}


@end



