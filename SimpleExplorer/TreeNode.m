//
//  TreeNode.m
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

@synthesize item;
@synthesize parent;

- (instancetype)initWithItem:(Item *)aItem {
    
    self=[super init];
    if (self!=nil) {
        self->item = aItem;
        self->childrens = [NSMutableArray array];
        self->parent = nil;
    }
    return self;
}

- (void)addChildrenNode:(TreeNode *)node {
    node->parent = self;
    [self->childrens addObject:node];
}

/** Возвращает количество дочерних узлов */

- (NSInteger)getChildrenCount {
    return self->childrens.count;
}

/** Удаляет все дочерние узлы для текущего узла */

- (void)clearChildren {
    [self->childrens removeAllObjects];
}

/** Возвращает дочерний узел по индексу */

- (TreeNode *)getChildrenNodeForIndex:(NSInteger)index {
    if (index >= 0 && index < self->childrens.count) {
        return [self->childrens objectAtIndex:index];
    }
    return nil;
}

@end
