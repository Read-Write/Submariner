//
//  SBSubsonicDownloadOperation.h
//  Submariner
//
//  Created by Rafaël Warnault on 16/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBOperation.h"


extern NSString *SBSubsonicDownloadStarted;
extern NSString *SBSubsonicDownloadFinished;


@class SBTrackID;
@class SBLibraryID;
@class SBOperationActivity;

@interface SBSubsonicDownloadOperation : SBOperation {
    SBTrackID *trackID;
    SBLibraryID *libraryID;
    
    SBOperationActivity *activity;
    NSString *tmpDestinationPath;
    NSURLResponse *downloadResponse;
    
    NSInteger bytesReceived;
}

@property (retain, readwrite) SBOperationActivity * activity;
@property (readwrite, retain) SBTrackID *trackID;

@end
