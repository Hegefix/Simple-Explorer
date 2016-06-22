//
//  FileManager.h
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutlineViewDataSource.h"
#import "TableViewDataSource.h"
#import "TreeNode.h"
#import "Item.h"

extern NSString *const CopyKey;
extern NSString *const PasteKey;
extern NSString *const DeleteKey;
extern NSString *const RenameKey;
extern NSString *const CreateKey;

@interface FileManager : NSObject
{
    NSFileManager *fileManager;
    OutlineViewDataSource *outlineDataSource;
    TableViewDataSource *tableDataSource;
}

@property (strong) Item *copiedItem;

- (instancetype)initWithOutlineViewDS:(OutlineViewDataSource *)oData TableViewDS:(TableViewDataSource *)tData;
- (void)contentsOfRootCatalog;
- (void)contentsOfCatalogForNode:(TreeNode *)node;
- (void)fillTheTableViewForNode:(TreeNode *)node;
- (BOOL)checkItemName:(Item *)item;
- (void)copyItem:(Item *)item;
- (BOOL)pasteItem:(Item *)item;
- (void)deleteItem:(Item *)item;
- (void)renameItem:(Item *)item NewPath:(NSString *)newPath;
- (void)createFolder:(Item *)item;

@end
