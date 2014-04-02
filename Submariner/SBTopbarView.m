//
//  SBTopbarView.m
//  Submariner
//
//  Created by Rafaël Warnault on 11/12/11.
//  Copyright (c) 2011 Read-Write.fr. All rights reserved.
//

#import "SBTopbarView.h"



#define DEFAULT_TOPBAR_ITEM_WIDTH 40


@interface SBTopbarView (Private)
- (NSMutableDictionary *)itemAtPosition:(CGPoint)position;
- (void)unselectAll;
- (NSInteger)indexForItem:(NSDictionary *)item;
@end


@implementation SBTopbarView


@synthesize delegate = _delegate;
@synthesize items = _items;


#pragma mark - Lifecycle


//- (id)initWithFrame:(NSRect)frameRect
//{
//    self = [super initWithFrame:frameRect];
//    if (self) {
//        _delegate = nil;
//        _items = [[NSMutableArray alloc] init];
//    }
//    
//    return self;
//}

- (void)dealloc {
    [_delegate release];
    [_items release];
    [super dealloc];
}


- (void)setSelectedIndex:(NSInteger)index {
    // changes selectected values
    NSMutableDictionary *item = [self.items objectAtIndex:index];
    
    if(item) {
        [self willChangeValueForKey:@"items"];
        [self unselectAll];
        [item setValue:[NSNumber numberWithBool:YES] forKey:kSBTopbarItemSelected];
        [self didChangeValueForKey:@"items"];
        
        // redraw
        [self setNeedsDisplay:YES];
    }
}


#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(SBTopbarViewDelegate)]) {
        
        CGFloat offset = 0;
        NSInteger counter = 0;
        if(!self.items && self.items.count == 0) {
            NSArray *dataSourceItems = [self.delegate itemsArrayForTopbarView:self];
            self.items = [NSMutableArray arrayWithArray:dataSourceItems];
        }
        
        for(NSMutableDictionary *item in self.items) {
            NSString *itemIdentifier    = [item valueForKey:kSBTopbarItemIdentifier];
            NSImage *itemImage          = [item valueForKey:kSBTopbarItemImage];
            //SEL itemAction              = [[item valueForKey:kSBTopbarItemAction] pointerValue];
            BOOL itemIsSelected         = [[item valueForKey:kSBTopbarItemSelected] boolValue];
            
            CGFloat originX = 0;
            originX = self.bounds.origin.x+offset;

            // draw background
            NSRect backgroundRect = NSMakeRect(originX, self.bounds.origin.y+1, DEFAULT_TOPBAR_ITEM_WIDTH, self.bounds.size.height);
            if(itemIsSelected) {
                NSGradient *bottomGlowGradient =
                [[[NSGradient alloc]
                  initWithColorsAndLocations:
                  [NSColor colorWithDeviceWhite:0.6 alpha:1.0], 0.0,
                  [NSColor colorWithDeviceWhite:0.4 alpha:1.0], 0.6,
                  [NSColor colorWithDeviceWhite:0.3 alpha:1.0], 0.9,
                nil] autorelease];
                
                [bottomGlowGradient drawInRect:backgroundRect relativeCenterPosition:NSMakePoint(0, -0.2)];
            }
            
            // draw image
            CGContextRef zCgContextRef = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
            
            if(itemIsSelected) {
                NSSize imageSize = itemImage.size;
                CGContextSaveGState(zCgContextRef);
                CGContextSetShadow (zCgContextRef, CGSizeMake(1, -1), 2);
                
                [[itemImage imageTintedWithColor:[NSColor whiteColor]] drawAtPoint:NSMakePoint(originX+(DEFAULT_TOPBAR_ITEM_WIDTH-imageSize.width)/2,(DEFAULT_TOPBAR_ITEM_WIDTH-imageSize.height)/2) 
                              fromRect:NSZeroRect 
                             operation:NSCompositeSourceOver
                              fraction:1.0];
                
                CGContextRestoreGState(zCgContextRef);
                
                // draw item top light
                NSRect topLightRect = NSMakeRect(originX, DEFAULT_TOPBAR_ITEM_WIDTH-1, DEFAULT_TOPBAR_ITEM_WIDTH, 1);
                [[NSColor darkGrayColor] set];
                NSRectFill(topLightRect);
                
            } else {
                NSSize imageSize = itemImage.size;
                CGContextSaveGState(zCgContextRef);
                CGContextSetShadowWithColor (zCgContextRef, CGSizeMake(0, -1), 0, CGColorCreateGenericGray(0.8, 1.0));
                
                [[itemImage imageTintedWithColor:[NSColor darkGrayColor]] drawAtPoint:NSMakePoint(originX+(DEFAULT_TOPBAR_ITEM_WIDTH-imageSize.width)/2,(DEFAULT_TOPBAR_ITEM_WIDTH-imageSize.height)/2) 
                              fromRect:NSZeroRect 
                             operation:NSCompositeSourceOver
                              fraction:1.0];
                
                CGContextRestoreGState(zCgContextRef);
            }
            
            
            // draw separators
            if(counter != [self.items count]-1) {

//                NSRect separatorRect = NSMakeRect(originX+DEFAULT_TOPBAR_ITEM_WIDTH, self.bounds.origin.y+1, 1, self.bounds.size.height);
//                [[NSColor colorWithDeviceWhite:0.6 alpha:1.0] setFill];
//                NSRectFill(separatorRect);
                
                offset = offset + DEFAULT_TOPBAR_ITEM_WIDTH;
                counter++;
            }
        }
    }
}


- (void)mouseUp:(NSEvent *)theEvent {
    
    NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSMutableDictionary *item = [self itemAtPosition:NSPointToCGPoint(clickPoint)];
    if(item != nil && [item isKindOfClass:[NSMutableDictionary class]]) {
        
        // changes selectected values
        [self willChangeValueForKey:@"items"];
        [self unselectAll];
        [item setValue:[NSNumber numberWithBool:YES] forKey:kSBTopbarItemSelected];
        [self didChangeValueForKey:@"items"];
        
        // redraw
        [self setNeedsDisplay:YES];
        
        // inform delegate
        if(self.delegate && [self.delegate conformsToProtocol:@protocol(SBTopbarViewDelegate)]) {
            NSInteger index = [self indexForItem:item];
            [self.delegate topbarView:self didSelectItemAtIndex:index];
        }
    }
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}


- (NSMutableDictionary *)itemAtPosition:(CGPoint)position {
    
    NSMutableDictionary *result = nil;
    CGFloat originX = position.x;
    CGFloat offset = 1;
    NSInteger index = 0;
    
    for(NSMutableDictionary *item in self.items) {
        offset = index * DEFAULT_TOPBAR_ITEM_WIDTH;
        if(originX >= offset && originX <= offset + DEFAULT_TOPBAR_ITEM_WIDTH)
            result = item;
        index++;
    }
    return result;
}

- (NSInteger)indexForItem:(NSDictionary *)item {
    NSInteger counter = 0;
    for(NSMutableDictionary *anItem in self.items) {
        if([anItem isEqualToDictionary:item]) {
            return counter;
        }
        counter ++;
    }
    return counter;
}

- (void)unselectAll {
    for(NSMutableDictionary *item in self.items) {
        [item setValue:[NSNumber numberWithBool:NO] forKey:kSBTopbarItemSelected];
    }
}


@end
