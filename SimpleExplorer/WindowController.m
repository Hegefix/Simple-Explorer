//
//  WindowController.m
//  SimpleExplorer
//
//  Created by Виктор on 21.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "WindowController.h"

NSString *const BackNotification = @"back";
NSString *const CopyNotification = @"copy";
NSString *const PasteNotification = @"paste";
NSString *const DeleteNotification = @"delete";
NSString *const CreateNotification = @"create";
NSString *const RenameNotification = @"rename";

static NSString *const BackIdentifier = @"backID";
static NSString *const CopyIdentifier = @"copyID";
static NSString *const PasteIdentifier = @"pasteID";
static NSString *const DeleteIdentifier = @"deleteID";
static NSString *const CreateIdentifier = @"createID";
static NSString *const RenameIdentifier = @"renameID";

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self->imageBack = [NSImage imageNamed:@"back"];
    self->imageCopy = [NSImage imageNamed:@"copy"];
    self->imagePaste = [NSImage imageNamed:@"paste"];
    self->imageDelete = [NSImage imageNamed:@"delete"];
    self->imageCreate = [NSImage imageNamed:@"create"];
    self->imageRename = [NSImage imageNamed:@"rename"];
    
    self->toolbar.delegate = self;
    
    [self->toolbar insertItemWithItemIdentifier:BackIdentifier atIndex:0];
    [self->toolbar insertItemWithItemIdentifier:CopyIdentifier atIndex:1];
    [self->toolbar insertItemWithItemIdentifier:PasteIdentifier atIndex:2];
    [self->toolbar insertItemWithItemIdentifier:DeleteIdentifier atIndex:3];
    [self->toolbar insertItemWithItemIdentifier:CreateIdentifier atIndex:4];
    [self->toolbar insertItemWithItemIdentifier:RenameIdentifier atIndex:5];
}

#pragma mark - ToolbarDelegate -

- (NSArray<NSString *> *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return nil;
}

- (NSArray<NSString *> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    NSArray<NSString *> *array = [NSArray arrayWithObjects:BackIdentifier, CopyIdentifier, PasteIdentifier, DeleteIdentifier, CreateIdentifier, RenameIdentifier,  nil];
    return array;
}

- (NSArray<NSString *> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    NSArray<NSString *> *array = [NSArray arrayWithObjects:BackIdentifier, CopyIdentifier, PasteIdentifier, DeleteIdentifier, CreateIdentifier, RenameIdentifier,  nil];
    return array;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    
    NSToolbarItem *barItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    if ([itemIdentifier isEqualToString:BackIdentifier]) {
        barItem.label = @"Назад";
        barItem.toolTip = @"Вернутся в предыдущий каталог";
        barItem.image = self->imageBack;
        barItem.target = self;
        barItem.action = @selector(toolbarAction:);
    } else if ([itemIdentifier isEqualToString:CopyIdentifier]) {
        barItem.label = @"Копировать";
        barItem.toolTip = @"Копировать файл или папку";
        barItem.image = self->imageCopy;
        barItem.target = self;
        barItem.action = @selector(toolbarAction:);
    } else if ([itemIdentifier isEqualToString:PasteIdentifier]) {
        barItem.label = @"Вставить";
        barItem.toolTip = @"Вставить файл или папку";
        barItem.image = self->imagePaste;
        barItem.target = self;
        barItem.action = @selector(toolbarAction:);
    } else if ([itemIdentifier isEqualToString:DeleteIdentifier]) {
        barItem.label = @"Удалить";
        barItem.toolTip = @"Удалить файл или папку";
        barItem.image = self->imageDelete;
        barItem.target = self;
        barItem.action = @selector(toolbarAction:);
    } else if ([itemIdentifier isEqualToString:CreateIdentifier]) {
        barItem.label = @"Создать папку";
        barItem.toolTip = @"Создать новую папку";
        barItem.image = self->imageCreate;
        barItem.target = self;
        barItem.action = @selector(toolbarAction:);
    } else if ([itemIdentifier isEqualToString:RenameIdentifier]) {
        barItem.label = @"Переименовать";
        barItem.toolTip = @"Переименовать файл или папку";
        barItem.image = self->imageRename;
        barItem.target = self;
        barItem.action = @selector(toolbarAction:);
    }
    return barItem;
}

#pragma mark - Обработчик тулбара -

- (void)toolbarAction:(id)sender {
    
    NSNotificationCenter *NC = [NSNotificationCenter defaultCenter];
    NSToolbarItem *barItem = (NSToolbarItem *)sender;
    if ([barItem.itemIdentifier isEqualToString:BackIdentifier]) {
        [NC postNotificationName:BackNotification object:sender];
    } if ([barItem.itemIdentifier isEqualToString:CopyIdentifier]) {
        [NC postNotificationName:CopyNotification object:sender];
    } if ([barItem.itemIdentifier isEqualToString:PasteIdentifier]) {
        [NC postNotificationName:PasteNotification object:sender];
    } if ([barItem.itemIdentifier isEqualToString:DeleteIdentifier]) {
        [NC postNotificationName:DeleteNotification object:sender];
    } if ([barItem.itemIdentifier isEqualToString:CreateIdentifier]) {
        [NC postNotificationName:CreateNotification object:sender];
    } if ([barItem.itemIdentifier isEqualToString:RenameIdentifier]) {
        [NC postNotificationName:RenameNotification object:sender];
    }
}


@end
