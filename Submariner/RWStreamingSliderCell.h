//
//  RWStreamingSliderCell.h
//  DoubleSlider
//
//  Created by Rafaël Warnault on 16/10/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface RWStreamingSliderCell : NSSliderCell {
    CGFloat bufferValue;
}

@property (readwrite) CGFloat bufferValue;

@end