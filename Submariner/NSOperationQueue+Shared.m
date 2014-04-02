//
//  NSOperationQueue+Shared.m
//  Submariner
//
//  Created by Rafaël Warnault on 09/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "NSOperationQueue+Shared.h"

@implementation NSOperationQueue (Shared)

+ (NSOperationQueue*) sharedServerQueue
{
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setMaxConcurrentOperationCount:1];
    }
    return sharedQueue;
}

+ (NSOperationQueue*) sharedDownloadQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setMaxConcurrentOperationCount:1];
    }
    return sharedQueue;   
}

@end
