//
//  NSOutlineView+Expand.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "NSOutlineView+Expand.h"




@interface SBSourceList (PrivateHelper)
- (void)_expandAllItems;
- (void)_expandURIs:(NSArray *)someURIs;
- (void)_reloadURIs:(NSArray *)someURIs;
@end





@implementation SBSourceList (Expand)

- (void)expandAllItems {
    [self performSelector:@selector(_expandAllItems) withObject:nil afterDelay:0.0f];
}

- (void)expandURIs:(NSArray *)someURIs {
    [self performSelector:@selector(_expandURIs:) withObject:someURIs afterDelay:0.0f];
}

- (void)reloadURIs:(NSArray *)someURIs {
    [self performSelector:@selector(_reloadURIs:) withObject:someURIs afterDelay:0.0f];
}

@end





@implementation SBSourceList (PrivateHelper)

- (void)_expandAllItems {
    [self expandItem:nil expandChildren:YES];
}


- (void)_expandURIs:(NSArray *)someURIs {
    
    //Get items from the preferences
    NSMutableArray *notFoundNested = [NSMutableArray array];
    BOOL foundAtLeastOne = NO;
    NSEnumerator *collectionsToExpandEnum = [someURIs objectEnumerator];
    NSString *nextCollectionURI;
    
    while (nextCollectionURI = [collectionsToExpandEnum nextObject]) {
        NSInteger i, numberOfRows = [self numberOfRows];
        BOOL found = NO;

        for (i = 0; i < numberOfRows; i++ ) {
            if ([[[self delegate] outlineView:self persistentObjectForItem:[self itemAtRow:i]] isEqualToString:nextCollectionURI]) {
                
                [self expandItem:[self itemAtRow:i]];
                foundAtLeastOne = YES;
                found = YES;
                break;
            }
        }
        
        if (found == NO) {
            [notFoundNested addObject:nextCollectionURI];
        }
    }
    
    if (foundAtLeastOne && [notFoundNested count])
        [self expandURIs:notFoundNested];
}


- (void)_reloadURIs:(NSArray *)someURIs {
    
    //Get items from the preferences
    NSMutableArray *notFoundNested = [NSMutableArray array];
    BOOL foundAtLeastOne = NO;
    NSEnumerator *collectionsToExpandEnum = [someURIs objectEnumerator];
    NSString *nextCollectionURI;
    
    while (nextCollectionURI = [collectionsToExpandEnum nextObject]) {
        NSInteger i, numberOfRows = [self numberOfRows];
        BOOL found = NO;
        
        for (i = 0; i < numberOfRows; i++ ) {
            
            if ([[[self delegate] outlineView:self 
                      persistentObjectForItem:[self itemAtRow:i]] isEqualToString:nextCollectionURI]) {
                
                [self reloadItem:[self itemAtRow:i] reloadChildren:YES];
                foundAtLeastOne = YES;
                found = YES;
                break;
            }
        }
        
        if (found == NO) {
            [notFoundNested addObject:nextCollectionURI];
        }
    }
    
    if (foundAtLeastOne && [notFoundNested count])
        [self reloadURIs:notFoundNested];
}



@end