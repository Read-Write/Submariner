//
//  DXOperationActivity.h
//  DicomX
//
//  Created by nark on 18/03/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBOperationActivity : NSObject {
    NSString *operationName;
    NSString *operationInfo;
    NSNumber *operationPercent;
    NSNumber *operationCurrent;
    NSNumber *operationTotal;
    BOOL indeterminated;
}

@property (readwrite, retain) NSString *operationName;
@property (readwrite, retain) NSString *operationInfo;
@property (readwrite, retain) NSNumber *operationPercent;
@property (readwrite, retain) NSNumber *operationCurrent;
@property (readwrite, retain) NSNumber *operationTotal;
@property (readwrite) BOOL indeterminated;


@end
