//
//  FileManager.m
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "FileManager.h"

NSString *const CopyKey=@"Копировать";
NSString *const PasteKey=@"Вставить";
NSString *const DeleteKey=@"Удалить";
NSString *const RenameKey=@"Переименовать";
NSString *const CreateKey=@"Создать папку";

@implementation FileManager

- (instancetype)initWithOutlineViewDS:(OutlineViewDataSource *)oData TableViewDS:(TableViewDataSource *)tData {
    
    self = [super init];
    if (self != nil) {
        self->fileManager = [NSFileManager defaultManager];
        self->outlineDataSource = oData;
        self->tableDataSource = tData;
    }
    return self;
}

#pragma mark - Заполнение OutlineView -

- (void)contentsOfRootCatalog {
    
    Item *root = [[Item alloc] initWithPath:@"/" isFile:false];
    
    //заполняем каталогами
    NSArray <NSString *> *content = [self->fileManager contentsOfDirectoryAtPath:root.path error:nil];
    for (int i=0;i<content.count;i++) {
        
        NSString *dir = [content objectAtIndex:i];
        BOOL isDir;
        NSString *path = [NSString stringWithFormat:@"/%@",dir];
        [self->fileManager fileExistsAtPath:path isDirectory:&isDir];
        if (isDir) {
            TreeNode *node = [[TreeNode alloc] initWithItem:[[Item alloc] initWithPath:path isFile:!isDir]];
            [self->outlineDataSource addNode:node];
            
            //проверяем есть ли подкаталоги
            NSArray <NSString *> *contentsOfDir = [self->fileManager contentsOfDirectoryAtPath:node.item.path error:nil];
            for (int j=0;j<contentsOfDir.count;j++) {
                
                NSString *subDir = [contentsOfDir objectAtIndex:j];
                BOOL isSubDir = false;
                NSString *subPath = [NSString stringWithFormat:@"%@/%@",node.item.path,subDir];
                [self->fileManager fileExistsAtPath:subPath isDirectory:&isSubDir];
                if (isSubDir) {
                    
                    //если есть подкаталоги, добавляет обманный узел
                    [node addChildrenNode:[[TreeNode alloc] initWithItem:[[Item alloc] initWithPath:@"?" isFile:false]]];
                    break;
                }
            }
        }
    }
}

- (void)contentsOfCatalogForNode:(TreeNode *)node {
    
    //удаляем обманный узел вместе со всем содержимым
    [node clearChildren];
    
    //заполняем каталогами
    NSArray <NSString *> *content = [self->fileManager contentsOfDirectoryAtPath:node.item.path error:nil];
    for (int i=0;i<content.count;i++) {
        
        NSString *dir = [content objectAtIndex:i];
        BOOL isDir;
        NSString *path = [NSString stringWithFormat:@"%@/%@",node.item.path,dir];
        [self->fileManager fileExistsAtPath:path isDirectory:&isDir];
        if (isDir) {
            TreeNode *aNode = [[TreeNode alloc] initWithItem:[[Item alloc] initWithPath:path isFile:!isDir]];
            [node addChildrenNode:aNode];
            
            //проверяем есть ли подкаталоги
            NSArray <NSString *> *contentsOfDir = [self->fileManager contentsOfDirectoryAtPath:aNode.item.path error:nil];
            for (int j=0;j<contentsOfDir.count;j++) {
                
                NSString *subDir = [contentsOfDir objectAtIndex:j];
                BOOL isSubDir = false;
                NSString *subPath = [NSString stringWithFormat:@"%@/%@",aNode.item.path,subDir];
                [self->fileManager fileExistsAtPath:subPath isDirectory:&isSubDir];
                if (isSubDir) {
                    
                    //если подкаталоги есть - добавляем обманный узел
                    [aNode addChildrenNode:[[TreeNode alloc] initWithItem:[[Item alloc] initWithPath:@"?" isFile:false]]];
                }
            }
        }
    }
}

#pragma mark - Заполнение TableView -

- (void)fillTheTableViewForNode:(TreeNode *)node {
    
    [self->tableDataSource removeAllItems];
    NSArray <NSString *> *content = [self->fileManager contentsOfDirectoryAtPath:node.item.path error:nil];
    
    for (int i=0;i<content.count;i++) {
        
        NSString *itemName = [content objectAtIndex:i];
        BOOL isDir;
        NSString *path = [NSString stringWithFormat:@"%@/%@",node.item.path,itemName];
        [self->fileManager fileExistsAtPath:path isDirectory:&isDir];
        Item *item = [[Item alloc] initWithPath:path isFile:!isDir];
        [self->tableDataSource addItem:item];
        
    }
    
    //сортировка таблицы
    [self->tableDataSource sortingContentsArray];
}

#pragma mark - Копирование файла -

- (void)copyItem:(Item *)item {
    NSLog(@"Copy: %@",item.path);
    
    if (self.copiedItem != nil) {
        
        NSError *error = nil;
        [self->fileManager removeItemAtPath:self.copiedItem.name error:&error];
        if (error != nil && error.code != 0) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            self.copiedItem = nil;
        }
    }
    
    NSError *error = nil;
    [self->fileManager copyItemAtPath:item.path toPath:item.name error:&error];
    if (error != nil && error.code != 0) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        self.copiedItem = item;
    }
}

- (BOOL)pasteItem:(Item *)item {
    NSLog(@"Paste: %@",item.path);
    
    if (self.copiedItem == nil) {
        return false;
    } else {
        
        NSError *error = nil;
        NSLog(@"Paste item %@ to path:%@", self.copiedItem.name, item.path);
        [self->fileManager copyItemAtPath:self.copiedItem.name toPath:item.path error:&error];
        if (error != nil && error.code != 0) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            
            NSError *error = nil;
            [self->fileManager removeItemAtPath:self.copiedItem.name error:&error];
            if (error != nil && error.code != 0) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                self.copiedItem = nil;
            }
        }
    }
    return true;
}

#pragma mark - Удаление файла -

- (void)deleteItem:(Item *)item {
    NSLog(@"Delete %@",item.path);
    
    NSError *error = nil;
    [self->fileManager removeItemAtPath:item.path error:&error];
    if (error != nil && error.code != 0) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - Переименование файла -

- (void)renameItem:(Item *)item NewPath:(NSString *)newPath {
    NSLog(@"Rename: %@ New path: %@",item.path,newPath);
    
    NSError *error = nil;
    [self->fileManager moveItemAtPath:item.path toPath:newPath error:&error];
    if (error != nil && error.code != 0) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - Создание файла -

- (void)createFolder:(Item *)item {
    NSLog(@"Create: %@",item.path);
    
    NSError *error = nil;
    [self->fileManager createDirectoryAtPath:item.path
                 withIntermediateDirectories:false
                                  attributes:nil
                                       error:&error];
    if (error !=nil && error.code !=0) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (BOOL)checkItemName:(Item *)item {
    
    if (self.copiedItem == nil || item.isFile) {
        return false;
    } else {
        
        NSError *error = nil;
        NSArray <NSString *> *contents = [self->fileManager contentsOfDirectoryAtPath:item.path error:&error];
        for (NSString *dir in contents) {
            if ([dir isEqualToString:self.copiedItem.name]) {
                return true;
            }
        }
        return false;
    }
}

@end
