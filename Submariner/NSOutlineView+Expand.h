//
//  NSOutlineView+Expand.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSourceList.h"

@interface SBSourceList (Expand)

- (void)expandAllItems; 
- (void)expandURIs:(NSArray *)someURIs;
- (void)reloadURIs:(NSArray *)someURIs;

@end
