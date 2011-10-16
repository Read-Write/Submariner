//
//  RWStreamingSlider.m
//  DoubleSlider
//
//  Created by Rafaël Warnault on 16/10/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "RWStreamingSlider.h"
#import "RWStreamingSliderCell.h"


@implementation RWStreamingSlider


+ (Class)cellClass {
    return [RWStreamingSliderCell class];
}


- (void)awakeFromNib {
    RWStreamingSliderCell *newCell = [[RWStreamingSliderCell alloc] init];
    id oldCell = [self cell];
    [newCell setImage:[oldCell image]];
    [newCell setMinValue:[oldCell minValue]];
    [newCell setMaxValue:[oldCell maxValue]];
    [newCell setSliderType:[oldCell sliderType]];
    [newCell setAction:[oldCell action]];
    [newCell setTarget:[oldCell target]];
    
    [self setCell:newCell];
    [newCell release];
}

- (IBAction)takeSegondaryFloatValueFrom:(id)sender {
    
    RWStreamingSliderCell *newCell = (RWStreamingSliderCell *)[self cell];
    [newCell setBufferValue:[sender floatValue]];
    [self setNeedsDisplay:YES];
}

@end
