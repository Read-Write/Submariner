//
//  SBMergeArtistController.h
//  Submariner
//
//  Created by Rafaël Warnault on 24/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSheetController.h"

@interface SBMergeArtistsController : SBSheetController {
    NSArray *artists;
    
    IBOutlet NSPopUpButton *artistPopUpButton;
}

@property (readwrite, retain) NSArray *artists;

@end
