//
//  ThreadedCoreDataOperation.m
//  MultiThreadedCoreData
//
//  Created by James Abley on 09/07/2010.
//  Copyright 2010 Mobile IQ Ltd. All rights reserved.
//

#import "SBOperation.h"



@interface SBOperation(PrivateMethods)
- (void)mergeThreadedContextChangesIntoMainContext:(NSNotification *)notification;
@end



@implementation SBOperation


@synthesize mainContext = mainContext_;
@synthesize threadedContext = threadedContext_;



#pragma mark -
#pragma mark LifeCycle

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    if ((self = [super init])) {
        mainContext_  = context;
        executing = NO;
        finished = NO;
    }

    return self;
}





#pragma mark -
#pragma mark Concurrency

- (BOOL)isConcurrent
{
    return YES;
}


- (BOOL)isFinished {
    return finished;
}


- (BOOL)isExecuting {
    return executing;
}




#pragma mark -
#pragma mark Helper

/* Respect Apple guidelines, this operation can run concurrently */
- (void)start {
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}


- (void)finish
{    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}





#pragma mark -
#pragma mark CoreData Operation

- (NSManagedObjectContext*)threadedContext {
    if (!threadedContext_) {
        threadedContext_ = [[NSManagedObjectContext alloc] init];
        [threadedContext_ setPersistentStoreCoordinator:[mainContext_ persistentStoreCoordinator]];
        [threadedContext_ setMergePolicy:[mainContext_ mergePolicy]];
        [threadedContext_ setRetainsRegisteredObjects:YES];
    }
    return threadedContext_;
}

- (void)saveThreadedContext {
    
//    if(![NSThread isMainThread]) {
//        [self performSelectorOnMainThread:@selector(saveThreadedContext) 
//                               withObject:nil waitUntilDone:YES];
//    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    if ([[self threadedContext] hasChanges]) {
                
        [defaultCenter addObserver:self
                          selector:@selector(mergeThreadedContextChangesIntoMainContext:)
                              name:NSManagedObjectContextDidSaveNotification
                            object:self.threadedContext];
#if DEBUG                
        NSLog(@"INFO : 1. New Data will be saved...");
#endif
        NSError *error = nil;


        BOOL contextDidSave = [[self threadedContext] save:&error];
        
        if (!contextDidSave) {
            
            // If the context failed to save, log out as many details as possible.
            NSLog(@"FATAL : Failed to save to data store: %@", [error localizedDescription]);
            
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            
            if (detailedErrors != nil && [detailedErrors count] > 0) {
                
                for (NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            } else {
                NSLog(@"  %@", [error userInfo]);
            }
        }
        
        [defaultCenter removeObserver:self name:NSManagedObjectContextDidSaveNotification object:[self threadedContext]];
    }
    [self finish];
}

#pragma mark -
#pragma mark PrivateMethods
- (void)mergeThreadedContextChangesIntoMainContext:(NSNotification *)notification {
    
#if DEBUG   
    NSLog(@"INFO : 2. Database Merging Changes...");
#endif
    
    if ([notification object] == mainContext_) {
        // main context save, no need to perform the merge
        return;
    }
    
    if(![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(mergeThreadedContextChangesIntoMainContext:) 
                               withObject:notification 
                            waitUntilDone:YES];
        return;
    }
    
    [mainContext_ performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                   withObject:notification
                                waitUntilDone:YES];
}



@end