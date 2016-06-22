//
//  OutlineViewDataSource.m
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "OutlineViewDataSource.h"

NSString *const NameColumnIdentifier=@"NameColumn";

@implementation OutlineViewDataSource

- (instancetype)initWithItem:(Item *)aItem {
    
    self=[super init];
    if (self!=nil) {
        self->root = [[TreeNode alloc] initWithItem:aItem];
        self->folderImage = [NSImage imageNamed:@"folder"];
        self->fileImage = [NSImage imageNamed:@"file"];
    }
    return self;
}

- (void)addNode:(TreeNode *)node {
    [self->root addChildrenNode:node];
}

#pragma mark - NSOutlineViewDataSource -

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    //NSLog(@"numberOfChildren");
    if (item == nil) {
        return [self->root getChildrenCount];
    } else if ([item isKindOfClass:[TreeNode class]]) {
        TreeNode *node = (TreeNode *)item;
        return [node getChildrenCount];
    }
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    //NSLog(@"isItemExpendable");
    if (item == nil) {
        return ([self->root getChildrenCount]>0);
    } else if ([item isKindOfClass:[TreeNode class]]) {
        TreeNode *node = (TreeNode *)item;
        return ([node getChildrenCount]>0);
    }
    return false;
}

/** Возвращает дочерний узел с индексом index для родительского узла item. */

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    //NSLog(@"childOfItem");
    if (item == nil) {
        return [self->root getChildrenNodeForIndex:index];
    } else if ([item isKindOfClass:[TreeNode class]]) {
        TreeNode *node = (TreeNode *)item;
        return [node getChildrenNodeForIndex:index];
    }
    return nil;
}

/** Возвращает значение для конкретного столбца tableColumn для узла item (НЕ РАБОТАЕТ для ViewBased) */

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    //NSLog(@"objectValueForTableColumn");
    if (item == nil) {
        return self->root.item.path;
    } else if ([item isKindOfClass:[TreeNode class]]) {
        TreeNode *node = (TreeNode *)item;
        return node.item.path;
    }
    return nil;
}

#pragma mark - NSOutlineViewDelegate -

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 40;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    //NSLog(@"viewForTableColumn");
    
    if ([item isKindOfClass:[TreeNode class]]) {
        TreeNode *node = (TreeNode *)item;
        
        NSView *viewCont = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 38)];
        
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(3, 3, 32, 32)];
        [imageView setImage:self->folderImage];
        [viewCont addSubview:imageView];
        
        NSTextField *txt = [[NSTextField alloc] initWithFrame:NSMakeRect(40, 4, 160, 30)];
        txt.stringValue = node.item.name;
        [txt setBordered:false];
        [txt setEditable:false];
        [txt setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [viewCont addSubview:txt];
        
        return viewCont;
    }
    return nil;
}

@end
