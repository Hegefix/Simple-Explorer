//
//  TableViewDataSource.m
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "TableViewDataSource.h"

NSString *const TableNameColumnIdentifier = @"namecolumn";
NSString *const TableDateColumnIdentifier = @"datecolumn";
NSString *const TableSizeColumnIdentifier = @"sizecolumn";

@implementation TableViewDataSource

- (instancetype)init {
    
    self=[super init];
    if (self!=nil) {
        self->contents = [NSMutableArray array];
        self->folderImage = [NSImage imageNamed:@"folder"];
        self->fileImage = [NSImage imageNamed:@"file"];
    }
    return self;
}

- (void)addItem:(Item *)item {
    [self->contents addObject:item];
}

- (Item *)itemAtIndex:(NSInteger)index {
    return [self->contents objectAtIndex:index];
}

- (void)replaceItemAtIndex:(NSInteger)index WithItem:(Item *)newItem {
    [self->contents replaceObjectAtIndex:index withObject:newItem];
}

- (void)removeAllItems {
    [self->contents removeAllObjects];
}

- (void)sortingContentsArray {
    [self->contents sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (((Item *)obj1).isFile == true && ((Item *)obj2).isFile!=true) {
            return NSOrderedDescending;
        } else if (((Item *)obj1).isFile != true && ((Item *)obj2).isFile == true) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
}

- (void)removeItem:(Item *)item {
    [self->contents removeObject:item];
}

#pragma mark - NSTableViewDataSource -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self->contents.count;
}

/*- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    Item *item=[self->contents objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:TableNameColumnIdentifier]) {
        return item.name;
    } else if ([tableColumn.identifier isEqualToString:TableDateColumnIdentifier]) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        dateFormatter.dateStyle=NSDateFormatterShortStyle;
        dateFormatter.timeStyle=NSDateFormatterShortStyle;
        return [dateFormatter stringFromDate:item.changeDate];
    } else if ([tableColumn.identifier isEqualToString:TableSizeColumnIdentifier]) {
        return item.size;
    }
    return nil;
}*/

#pragma mark - NSTableViewDelegate -

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    Item *item = [self->contents objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:TableNameColumnIdentifier]) {
        
        NSView *viewCont = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 35)];
        
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(3, 3, 32, 32)];
        [imageView setImage:(item.isFile)?self->fileImage:self->folderImage];
        [viewCont addSubview:imageView];
        
        NSTextField *txt = [[NSTextField alloc] initWithFrame:NSMakeRect(40, 5, 200, 30)];
        txt.stringValue = item.name;
        [txt setBordered:false];
        [txt setEditable:false];
        [txt setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [viewCont addSubview:txt];
        
        return viewCont;
        
    } else if ([tableColumn.identifier isEqualToString:TableDateColumnIdentifier]) {
        
        NSTextField *txt=[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 160, 35)];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        if (item.changeDate == nil) {
            item.changeDate = [NSDate date];
        }
        
        txt.stringValue = [dateFormatter stringFromDate:item.changeDate];
        [txt setBordered:false];
        [txt setEditable:false];
        [txt setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        return txt;
        
    } else if ([tableColumn.identifier isEqualToString:TableSizeColumnIdentifier]) {
        NSTextField *txt = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 160, 35)];
        
        if (item.isFile) {
            txt.stringValue = [NSString stringWithFormat:@"%@",item.size];
        } else {
            txt.stringValue = [NSString stringWithFormat:@""];
        }
        
        [txt setBordered:false];
        [txt setEditable:false];
        [txt setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        return txt;
        
    }
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 35;
}

@end
