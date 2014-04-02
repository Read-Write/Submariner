//
//  RWVolumeSlider.m
//  Submariner
//
//  Created by Rafaël Warnault on 16/10/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "RWVolumeSlider.h"
#import "RWVolumeSliderCell.h"

@implementation RWVolumeSlider

+ (Class)cellClass {
    return [RWVolumeSliderCell class];
}


- (void)awakeFromNib {
    RWVolumeSliderCell *newCell = [[RWVolumeSliderCell alloc] init];
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

@end
