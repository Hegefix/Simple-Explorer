//
//  TreeNode.h
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface TreeNode : NSObject
{
    Item *item;
    NSMutableArray <TreeNode *> *childrens;
    TreeNode *parent;
}

@property (readwrite) Item *item;
@property (readonly) TreeNode *parent;

- (instancetype)initWithItem:(Item *)aItem;
- (void)addChildrenNode:(TreeNode *)node;       //добавляет дочерний узел
- (NSInteger)getChildrenCount;                  //возвращает количеество дочерних узлов для текущего узла
- (void)clearChildren;                          //убрать все дочерние узлы
- (TreeNode *)getChildrenNodeForIndex:(NSInteger)index;

@end
