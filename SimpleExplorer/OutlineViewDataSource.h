//
//  OutlineViewDataSource.h
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Item.h"
#import "TreeNode.h"

extern NSString *const NameColumnIdentifier;

@interface OutlineViewDataSource : NSObject <NSOutlineViewDataSource,NSOutlineViewDelegate>
{
    TreeNode *root;
    NSImage *folderImage;
    NSImage *fileImage;
}

- (instancetype)initWithItem:(Item *)aItem;
- (void)addNode:(TreeNode *)node;

@end
