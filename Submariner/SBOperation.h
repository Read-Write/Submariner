//
//  ThreadedCoreDataOperation.h
//  MultiThreadedCoreData
//
//  Created by James Abley on 09/07/2010.
//  Copyright 2010 Mobile IQ Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBOperation : NSOperation {

    BOOL executing;
    BOOL finished;
    int ddLogLevel;
    
    NSString *operationName;
    NSMutableArray *computedPaths;
    
    NSManagedObjectContext *mainContext_;
    NSManagedObjectContext *threadedContext_;
}

@property (readonly, retain) NSManagedObjectContext *threadedContext;
@property (retain, readonly) NSManagedObjectContext * mainContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)mainContext;
- (void)saveThreadedContext;
- (void)finish;

@end
