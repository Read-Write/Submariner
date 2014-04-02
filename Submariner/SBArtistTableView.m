//
//  SBArtistTableView.m
//  Submariner
//
//  Created by Rafaël Warnault on 15/10/11.
//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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



