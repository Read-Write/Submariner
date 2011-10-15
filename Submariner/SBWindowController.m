//
//  SBWindowController.m
//  Sub
//
//  Created by nark on 14/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBWindowController.h"


@interface SBWindowController ()
- (void)_enableLayer;
- (void)_disableLayer;
- (void)_showVisualCue;
- (void)_hideVisualCue;
@end

@implementation SBWindowController

@synthesize managedObjectContext;


#pragma mark -
#pragma mark Class Methods

+ (NSString *)nibName
{
    return nil;
}



#pragma mark -
#pragma mark Instance Methods

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithWindowNibName:[[self class] nibName]];
    if (self) {
        managedObjectContext = context;
    }
    return self;
}


- (void)showVisualCue {
//    [self performSelector:@selector(_enableLayer) withObject:nil afterDelay:0.0f];
//    [self performSelector:@selector(_showVisualCue) withObject:nil afterDelay:0.2f];
}

- (void)hideVisualCue {
//    [self performSelector:@selector(_hideVisualCue) withObject:nil afterDelay:0.0f];
//    [self performSelector:@selector(_disableLayer) withObject:nil afterDelay:0.0f];
}



- (void)_showVisualCue {
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[[[self window] contentView] layer] addAnimation:animation forKey:@"layerAnimation"];
    
	blankingView = [[[NSView alloc] initWithFrame:[[[self window] contentView] frame]] autorelease];
	[[[self window] contentView] addSubview:blankingView];
    
    CIFilter *exposureFilter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [exposureFilter setDefaults];
	[exposureFilter setValue:[NSNumber numberWithDouble:-1.25] forKey:@"inputEV"];
    CIFilter *saturationFilter = [CIFilter filterWithName:@"CIColorControls"];
    [saturationFilter setDefaults];
	[saturationFilter setValue:[NSNumber numberWithDouble:0.35] forKey:@"inputSaturation"];
    CIFilter *gloomFilter = [CIFilter filterWithName:@"CIGloom"];
    [gloomFilter setDefaults];
	[gloomFilter setValue:[NSNumber numberWithDouble:0.1] forKey:@"inputIntensity"];
	
    [[blankingView layer] setBackgroundFilters:[NSArray arrayWithObjects:exposureFilter, saturationFilter, gloomFilter, nil]];    
}

- (void)_hideVisualCue {
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[[[self window] contentView] layer] addAnimation:animation forKey:@"layerAnimation"];
    
	[blankingView removeFromSuperview];
	blankingView = nil;
}

- (void)_enableLayer {
    [[[self window] contentView] setWantsLayer:YES];
}

- (void)_disableLayer {
    [[[self window] contentView] setWantsLayer:NO];
}

@end
