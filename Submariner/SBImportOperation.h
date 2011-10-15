//
//  SBImportOperation.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBOperation.h"


@class SBLibraryID;
@class SBTrackID;

@interface SBImportOperation : SBOperation {
@private
    NSArray *filePaths;
    SBLibraryID *libraryID;
    SBTrackID *remoteTrackID;
    BOOL copy;
    BOOL remove;
}
@property (readwrite) BOOL copy;
@property (readwrite) BOOL remove;
@property (readwrite, retain) NSArray *filePaths;
@property (readwrite, retain) SBLibraryID *libraryID;
@property (readwrite, retain) SBTrackID *remoteTrackID;
@end
