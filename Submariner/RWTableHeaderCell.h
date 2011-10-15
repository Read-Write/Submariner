//
//  RWTableHeaderCell.h
//  iPlay
//
//  Created by nark on 02/03/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RWTableHeaderCell : NSTableHeaderCell {

	BOOL _ascending;
	NSInteger _priority;
}

- (id)initWithCell:(NSTableHeaderCell*)cell;
- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority;

@end
