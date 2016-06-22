//
//  TableViewDataSource.h
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Item.h"

extern NSString *const TableNameColumnIdentifier;
extern NSString *const TableDateColumnIdentifier;
extern NSString *const TableSizeColumnIdentifier;

@interface TableViewDataSource : NSObject <NSTableViewDataSource,NSTableViewDelegate>
{
    NSMutableArray <Item *> *contents;
    NSImage *folderImage;
    NSImage *fileImage;
}

- (instancetype) init;
- (void)addItem:(Item *)item;
- (Item *)itemAtIndex:(NSInteger)index;
- (void)replaceItemAtIndex:(NSInteger)index WithItem:(Item *)newItem;
- (void)removeItem:(Item *)item;
- (void)removeAllItems;
- (void)sortingContentsArray;

@end
