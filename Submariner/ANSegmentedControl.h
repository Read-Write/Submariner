//
//  ANSegmentedControl.h
//  test01
//
//  Created by Decors on 11/04/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ANSegmentedControlDelegate;


@interface ANSegmentedControl : NSSegmentedControl <NSAnimationDelegate> {
@private
    NSPoint location;
    id<ANSegmentedControlDelegate> controlDelegate;
}

@property (readonly) IBOutlet id<ANSegmentedControlDelegate> controlDelegate;

-(void)setSelectedSegment:(NSInteger)newSegment animate:(bool)animate;

@end



@protocol ANSegmentedControlDelegate <NSObject>
@required
- (void)segmentedControl:(ANSegmentedControl *)control selectionDidChange:(NSInteger)index;

@end