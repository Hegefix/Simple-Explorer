//
//  ViewController.m
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
{
    OutlineViewDataSource *outlineDataSource;
    TableViewDataSource *tableDataSource;
    FileManager *fileManager;
}

#pragma mark - Инициализация столбцов -

- (void)addColumnToOutlineView {
    
    NSTableColumn *nameColumn = [[NSTableColumn alloc] initWithIdentifier:NameColumnIdentifier];
    nameColumn.title = @"Название";
    nameColumn.minWidth = 250;
    [self->outlineView addTableColumn:nameColumn];
    [self->outlineView setOutlineTableColumn:nameColumn];
    
    //Удаляем ненужные колонки
    NSArray <NSTableColumn *> *columns = self->outlineView.tableColumns;
    for (int i=(int)columns.count-1;i>=0;i--) {
        NSTableColumn *column = [columns objectAtIndex:i];
        if ([column.identifier isEqualToString:NameColumnIdentifier]) {continue;}
        [self->outlineView removeTableColumn:column];
    }
}

- (void)addColumnToTableView {
    
    NSTableColumn *colFileName = [[NSTableColumn alloc] initWithIdentifier:TableNameColumnIdentifier];
    colFileName.title = @"Название";
    colFileName.minWidth = 170;
    [self->tableView addTableColumn:colFileName];
    
    NSTableColumn *colChangeDate = [[NSTableColumn alloc] initWithIdentifier:TableDateColumnIdentifier];
    colChangeDate.title = @"Дата изменения";
    colChangeDate.minWidth = 170;
    [self->tableView addTableColumn:colChangeDate];
    
    NSTableColumn *colFileSize = [[NSTableColumn alloc] initWithIdentifier:TableSizeColumnIdentifier];
    colFileSize.title = @"Размер байты";
    colFileSize.minWidth = 170;
    [self->tableView addTableColumn:colFileSize];
    
    self->tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
    [self->tableView sizeToFit];
}

#pragma mark - Создание контекстных меню -

- (void)addContextMenu {
    
    NSMenu *contextMenuOutline =[ [NSMenu alloc] initWithTitle:@"OutlineView"];
    NSMenu *contextMenuTable = [[NSMenu alloc] initWithTitle:@"TableView"];
    
    NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:CopyKey
                                                      action:@selector(copyItemClick:)
                                               keyEquivalent:@"C"];
    NSMenuItem *pasteItem = [[NSMenuItem alloc] initWithTitle:PasteKey
                                                    action:@selector(pasteItemClick:)
                                             keyEquivalent:@"V"];
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:DeleteKey
                                                      action:@selector(deleteItemClick:)
                                               keyEquivalent:@"D"];
    NSMenuItem *renameItem = [[NSMenuItem alloc] initWithTitle:RenameKey
                                                      action:@selector(renameItemClick:)
                                               keyEquivalent:@"R"];
    NSMenuItem *createItem = [[NSMenuItem alloc] initWithTitle:CreateKey
                                                      action:@selector(createItemClick:)
                                               keyEquivalent:@"A"];
    
    NSMenuItem *copyItem1 = [[NSMenuItem alloc] initWithTitle:CopyKey
                                                    action:@selector(copyItemClick:)
                                             keyEquivalent:@"C"];
    NSMenuItem *pasteItem1 = [[NSMenuItem alloc] initWithTitle:PasteKey
                                                     action:@selector(pasteItemClick:)
                                              keyEquivalent:@"V"];
    NSMenuItem *deleteItem1 = [[NSMenuItem alloc] initWithTitle:DeleteKey
                                                      action:@selector(deleteItemClick:)
                                               keyEquivalent:@"D"];
    NSMenuItem *renameItem1 = [[NSMenuItem alloc] initWithTitle:RenameKey
                                                      action:@selector(renameItemClick:)
                                               keyEquivalent:@"R"];
    NSMenuItem *createItem1 = [[NSMenuItem alloc] initWithTitle:CreateKey
                                                      action:@selector(createItemClick:)
                                               keyEquivalent:@"A"];
    
    [contextMenuOutline addItem:copyItem];
    [contextMenuOutline addItem:pasteItem];
    [contextMenuOutline addItem:deleteItem];
    [contextMenuOutline addItem:renameItem];
    [contextMenuOutline addItem:createItem];
    
    [contextMenuTable addItem:copyItem1];
    [contextMenuTable addItem:pasteItem1];
    [contextMenuTable addItem:deleteItem1];
    [contextMenuTable addItem:renameItem1];
    [contextMenuTable addItem:createItem1];
    
    [self->outlineView setMenu:contextMenuOutline];
    [self->tableView setMenu:contextMenuTable];
}

#pragma mark - ViewController -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Добавление столбца к OutlineView
    [self addColumnToOutlineView];
    
    //Добавление столбца к TableView
    [self addColumnToTableView];
    
    //Инициализируем DataSource
    Item *root = [[Item alloc] initWithPath:@"/" isFile:false];
    self->outlineDataSource = [[OutlineViewDataSource alloc] initWithItem:root];
    self->tableDataSource = [[TableViewDataSource alloc] init];
    
    //инициализируем FileManager
    self->fileManager = [[FileManager alloc] initWithOutlineViewDS:self->outlineDataSource TableViewDS:self->tableDataSource];
    
    //заполняем DataSource чем FileManager
    [self->fileManager contentsOfRootCatalog];
    //[self->fileManager contentsOfCatalogForNode:nil];
    
    //назначаем DataSource
    [self->outlineView setDataSource:self->outlineDataSource];
    [self->outlineView setDelegate:self->outlineDataSource];
    
    [self->tableView setDataSource:self->tableDataSource];
    [self->tableView setDelegate:self->tableDataSource];
    
    //добавляем контекстные меню
    [self addContextMenu];
    
    //подписываемся на уведомления
    NSNotificationCenter *NC = [NSNotificationCenter defaultCenter];
    [NC addObserver:self selector:@selector(receiveSelectionChangeNote:) name:NSOutlineViewSelectionDidChangeNotification object:self->outlineView];
    [NC addObserver:self selector:@selector(receiveItemWillExpandNote:) name:NSOutlineViewItemWillExpandNotification object:self->outlineView];
    
    [NC addObserver:self selector:@selector(receiveBackNote:) name:BackNotification object:nil];
    [NC addObserver:self selector:@selector(receiveCopyNote:) name:CopyNotification object:nil];
    [NC addObserver:self selector:@selector(receivePasteNote:) name:PasteNotification object:nil];
    [NC addObserver:self selector:@selector(receiveDeleteNote:) name:DeleteNotification object:nil];
    [NC addObserver:self selector:@selector(receiveCreateNote:) name:CreateNotification object:nil];
    [NC addObserver:self selector:@selector(receiveRenameNote:) name:RenameNotification object:nil];
    
    //обработчик события для двойного нажатия
    self->tableView.doubleAction = @selector(doubleClickAction:);
    
    //добавляем путь в строку адресса
    self->pathLabel.stringValue = root.path;
}

- (void)viewDidDisappear {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self->fileManager.copiedItem != nil) {
        Item *item = [[Item alloc] initWithPath:self->fileManager.copiedItem.name isFile:self->fileManager.copiedItem.isFile];
        [self->fileManager deleteItem:item];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark - Получатели уведомлений -

- (void)receiveSelectionChangeNote:(NSNotification *)note {
    
    NSInteger index = [self->outlineView selectedRow];
    if (index == -1) return;
    
    TreeNode *node = (TreeNode *)[self->outlineView itemAtRow:index];
    [self->fileManager fillTheTableViewForNode:node];
    [self->tableView reloadData];
    
    self->pathLabel.stringValue = node.item.path;
}

- (void)receiveItemWillExpandNote:(NSNotification *)note {

    NSObject *object = [note.userInfo objectForKey:@"NSObject"];
    if ([object isKindOfClass:[TreeNode class]]) {
        TreeNode *node = (TreeNode*)object;
        [self->fileManager contentsOfCatalogForNode:node];
        self->pathLabel.stringValue = node.item.path;
    }
}

- (void)doubleClickAction:(id)sender {
    
    Item *item = [self->tableDataSource itemAtIndex:[self->tableView selectedRow]];
    if (item.isFile) return;
    
    NSInteger index = [self->outlineView selectedRow];
    TreeNode *selectedNode = [self->outlineView itemAtRow:index];
    if (![self->outlineView isItemExpanded:selectedNode]) {
        [self->outlineView expandItem:selectedNode];
    }
    
    NSInteger tableIndex = [self->tableView selectedRow]+1;
    NSInteger subIndex = index+tableIndex;
    
    [self->outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:subIndex] byExtendingSelection:false];
    
    self->pathLabel.stringValue = item.path;
}

#pragma mark - Получатели уведомлений от toolbar -

- (void)receiveBackNote:(NSNotification *)notification {
    //NSLog(@"%@", notification.name);
    
    NSInteger selectedRow = [self->outlineView selectedRow];
    if (selectedRow == -1) {
        return;
    } else {
        TreeNode *node = [self->outlineView itemAtRow:selectedRow];
        NSInteger rowForItem = [self->outlineView rowForItem:node.parent];
        [self->outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:rowForItem] byExtendingSelection:false];
        [self->outlineView collapseItem:node.parent collapseChildren:true];
    }
}

- (void)receiveCopyNote:(NSNotification *)notification {
    //NSLog(@"%@", notification.name);
    
    NSInteger selectedTableRow = [self->tableView selectedRow];
    if (selectedTableRow == -1) {
        
        NSInteger selectedOutlineRow = [self->outlineView selectedRow];
        if (selectedOutlineRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            TreeNode *node = [self->outlineView itemAtRow:selectedOutlineRow];
            //NSLog(@"%@", node.item.path);
            [self->fileManager copyItem:node.item];
        }
        
    } else {
        Item *item = [self->tableDataSource itemAtIndex:selectedTableRow];
        //NSLog(@"%@", item.path);
        [self->fileManager copyItem:item];
    }
}

- (void)receivePasteNote:(NSNotification *)notification {
    //NSLog(@"%@", notification.name);
    
    if (self->fileManager.copiedItem == nil) {
        return;
    } else {
        
        NSInteger selectedTableRow = [self->tableView selectedRow];
        if (selectedTableRow == -1) {
            
            NSInteger selectedOutlineRow = [self->outlineView selectedRow];
            if (selectedOutlineRow == -1) {
                
                NSAlert *alert = [[NSAlert alloc] init];
                alert.alertStyle = NSInformationalAlertStyle;
                alert.messageText = @"Элемент не выбран";
                alert.informativeText = @"Выберите элемент";
                [alert runModal];
                
            } else {
                
                TreeNode *node = [self->outlineView itemAtRow:selectedOutlineRow];
                if ([node.parent.item.path isEqualToString:@"/"]) {
                    
                    NSString *newPath = [NSString stringWithFormat:@"/%@ (copy)", self->fileManager.copiedItem.name];
                    Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                    //NSLog(@"%@", newItem.path);
                    
                    [self->fileManager pasteItem:newItem];
                    [self->outlineView reloadItem:newItem reloadChildren:true];
                    
                } else {
                    
                    NSString *newPath = [NSString stringWithFormat:@"%@/%@ (copy)", node.item.path, self->fileManager.copiedItem.name];
                    Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                    //NSLog(@"%@", newItem.path);
                    
                    [self->fileManager pasteItem:newItem];
                    [self->outlineView reloadItem:newItem reloadChildren:true];
                    [self->tableDataSource addItem:newItem];
                    [self->tableView reloadData];
                }
            }
            
        } else {
            
            Item *item = [self->tableDataSource itemAtIndex:selectedTableRow];
            if (item.isFile) {
                
                NSAlert *alert = [[NSAlert alloc] init];
                alert.alertStyle = NSInformationalAlertStyle;
                alert.messageText = @"Ошибка";
                alert.informativeText = @"Нельзя скопировать в файл";
                [alert runModal];
                return;
                
            } else {
                
                NSString *newPath = [NSString stringWithFormat:@"%@/%@", item.path, self->fileManager.copiedItem.name];
                Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                //NSLog(@"%@", newItem.path);
                
                [self->fileManager pasteItem:newItem];
                [self->tableDataSource addItem:newItem];
                [self->tableView reloadData];
                
            }
        }
    }
}

- (void)receiveDeleteNote:(NSNotification *)notification {
    //NSLog(@"%@", notification.name);
    
    NSInteger selectedTableRow = [self->tableView selectedRow];
    if (selectedTableRow == -1) {
        
        NSInteger selectedOutlineRow = [self->outlineView selectedRow];
        if (selectedOutlineRow == -1) {
           
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:selectedOutlineRow];
            //NSLog(@"Удалить %@", node.item.path);
            
            [self->fileManager deleteItem:node.item];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
            
        }
        
    } else {
        
        Item *item = [self->tableDataSource itemAtIndex:selectedTableRow];
        //NSLog(@"Удалить %@", item.path);
        
        [self->fileManager deleteItem:item];
        [self->tableDataSource removeItem:item];
        [self->tableView reloadData];
        
    }
}

- (void)receiveCreateNote:(NSNotification *)notification {
    //NSLog(@"%@", notification.name);
    
    NSInteger selectedTableRow = [self->tableView selectedRow];
    if (selectedTableRow == -1) {
        
        NSInteger selectedOutlineRow = [self->outlineView selectedRow];
        if (selectedOutlineRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:selectedOutlineRow];
            
            RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
            NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
            wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
            wind.title = @"Введите имя папки";
            NSInteger result = [NSApp runModalForWindow:wind];
            
            NSString *newPath;
            if (result == 1000) {
                NSString *newName = renameView.text.stringValue;
                newPath = [NSString stringWithFormat:@"%@/%@",node.item.path,newName];
            } else if (result == 1001) {
                return;
            }
            
            Item *newItem = [[Item alloc] initWithPath:newPath isFile:false];
            //NSLog(@"создать %@", newItem.path);
            
            [self->fileManager createFolder:newItem];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
            [self->tableDataSource addItem:newItem];
            [self->tableView reloadData];
        }
        
    } else {
        
        Item *item = [self->tableDataSource itemAtIndex:selectedTableRow];
        //NSLog(@"создать %@", item.path);
        
        RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
        NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
        wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
        wind.title = @"Введите имя папки";
        NSInteger result = [NSApp runModalForWindow:wind];
        
        NSString *newPath;
        if (result == 1000) {
            NSString *newName = renameView.text.stringValue;
            newPath = [NSString stringWithFormat:@"%@/%@",item.path,newName];
        } else if (result == 1001) {
            return;
        }
        
        Item *newItem = [[Item alloc] initWithPath:newPath isFile:false];
        NSLog(@"создать %@", newItem.path);
        
        [self->fileManager createFolder:newItem];
        [self->tableDataSource addItem:newItem];
        [self->tableView reloadData];
    }
}

- (void)receiveRenameNote:(NSNotification *)notification {
    //NSLog(@"%@", notification.name);
    
    NSInteger selectedTableRow = [self->tableView selectedRow];
    if (selectedTableRow == -1) {
        
        NSInteger selectedOutlineRow = [self->outlineView selectedRow];
        if (selectedOutlineRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:selectedOutlineRow];
            //NSLog(@"Rename %@", node.item.path);
            
            RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
            NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
            wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
            wind.title = @"Введите новое имя";
            renameView.text.stringValue = node.item.name;
            NSInteger result = [NSApp runModalForWindow:wind];
            
            NSString *newPath;
            if (result == 1000) {
                NSString *newName = renameView.text.stringValue;
                newPath = [self getNewPathForItem:node.item NewName:newName];
            } else if (result == 1001) {
                return;
            }
            
            [self->fileManager renameItem:node.item NewPath:newPath];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
        }
        
    } else {
        
        Item *item = [self->tableDataSource itemAtIndex:selectedTableRow];
        //NSLog(@"Rename %@", item.path);
        
        RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
        NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
        wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
        wind.title = @"Введите новое имя";
        renameView.text.stringValue = item.name;
        NSInteger result = [NSApp runModalForWindow:wind];
        
        NSString *newPath;
        if (result == 1000) {
            NSString *newName = renameView.text.stringValue;
            newPath = [self getNewPathForItem:item NewName:newName];
        } else if (result == 1001) {
            return;
        }
        
        [self->fileManager renameItem:item NewPath:newPath];
        Item *newItem = [[Item alloc] initWithPath:newPath isFile:item.isFile];
        [self->tableDataSource replaceItemAtIndex:selectedTableRow WithItem:newItem];
        [self->tableView reloadData];
    }
}

#pragma mark - Обработчики нажатий контекстного меню -

- (void)copyItemClick:(id)sender {              //доделать "копировать", реализовать метод файл менеджера
    
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    if ([menuItem.menu.title isEqualToString:@"OutlineView"]) {
        
        NSInteger clickedRow = [self->outlineView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:clickedRow];
            [self->fileManager copyItem:node.item];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
        }
        
    } else if ([menuItem.menu.title isEqualToString:@"TableView"]) {
        
        NSInteger clickedRow = [self->tableView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            Item *item = [self->tableDataSource itemAtIndex:clickedRow];
            [self->fileManager copyItem:item];
            //[self->tableView reloadData];   //? ничего ж не меняется по сути
        }
    }
}

- (void)pasteItemClick:(id)sender {             //доделать "вставить", реализовать метод файл менеджера
    
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    if ([menuItem.menu.title isEqualToString:@"OutlineView"]) {
        
        NSInteger clickedRow = [self->outlineView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:clickedRow];
            
            if ([self->fileManager checkItemName:node.item]) {
                
                NSString *newPath = [NSString stringWithFormat:@"%@/%@ (copy)", node.item.path, self->fileManager.copiedItem.name];
                Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                node.item = newItem;
                [self->fileManager pasteItem:newItem];
                [self->outlineView reloadItem:node reloadChildren:true];
                
            } else {
                
                [self->fileManager pasteItem:node.item];
                [self->outlineView reloadItem:node reloadChildren:true];
            }
        }
        
    } else if ([menuItem.menu.title isEqualToString:@"TableView"]) {
        
        NSInteger clickedRow = [self->tableView clickedRow];
        if (clickedRow == -1) {
            
            TreeNode *node = [self->outlineView itemAtRow:[self->outlineView selectedRow]];
            
            if ([self->fileManager checkItemName:node.item]) {
                
                NSString *newPath = [NSString stringWithFormat:@"%@/%@ (copy)", node.item.path, self->fileManager.copiedItem.name];
                Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                if([self->fileManager pasteItem:newItem]) {
                    [self->tableDataSource addItem:newItem];
                    [self->tableView reloadData];
                } else {
                    return;
                }
            
            } else {
                
                NSString *newPath = [NSString stringWithFormat:@"%@/%@", node.item.path, self->fileManager.copiedItem.name];
                Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                if([self->fileManager pasteItem:newItem]) {
                    [self->tableDataSource addItem:newItem];
                    [self->tableView reloadData];
                } else {
                    return;
                }
            }
            
        } else {
            
            Item *item = [self->tableDataSource itemAtIndex:clickedRow];
            if (item.isFile) {
                
                NSAlert *alert = [[NSAlert alloc] init];
                alert.alertStyle = NSInformationalAlertStyle;
                alert.messageText = @"Ошибка";
                alert.informativeText = @"Нельзя скопировать в файл";
                [alert runModal];
                return;
                
            } else {
                
                if ([self->fileManager checkItemName:item]) {
                    
                    NSString *newPath = [NSString stringWithFormat:@"%@/%@ (copy)", item.path, self->fileManager.copiedItem.name];
                    Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                    if([self->fileManager pasteItem:newItem]) {
                        [self->tableDataSource addItem:newItem];
                        [self->tableView reloadData];
                    } else {
                        return;
                    }
                    
                } else {
                    
                    NSString *newPath = [NSString stringWithFormat:@"%@/%@", item.path, self->fileManager.copiedItem.name];
                    Item *newItem = [[Item alloc] initWithPath:newPath isFile:self->fileManager.copiedItem.isFile];
                    if([self->fileManager pasteItem:newItem]) {
                        [self->tableDataSource addItem:newItem];
                        [self->tableView reloadData];
                    } else {
                        return;
                    }
                }
            }
        }
    }
}

- (void)deleteItemClick:(id)sender {        //удаление работает!
    
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    if ([menuItem.menu.title isEqualToString:@"OutlineView"]) {
        
        NSInteger clickedRow = [self->outlineView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:clickedRow];
            [self->fileManager deleteItem:node.item];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
            
        }
    } else if ([menuItem.menu.title isEqualToString:@"TableView"]) {
        
        NSInteger clickedRow = [self->tableView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            Item *item = [self->tableDataSource itemAtIndex:clickedRow];
            [self->fileManager deleteItem:item];
            [self->tableDataSource removeItem:item];
            [self->tableView reloadData];
            
        }
    }
}

- (void)renameItemClick:(id)sender {             //переименование работает!
    
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    if ([menuItem.menu.title isEqualToString:@"OutlineView"]) {
        
        NSInteger clickedRow = [self->outlineView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:clickedRow];
            
            RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
            NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
            wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
            wind.title = @"Введите новое имя";
            renameView.text.stringValue = node.item.name;
            NSInteger result = [NSApp runModalForWindow:wind];
            
            NSString *newPath;
            if (result == 1000) {
                NSString *newName = renameView.text.stringValue;
                newPath = [self getNewPathForItem:node.item NewName:newName];
            } else if (result == 1001) {
                return;
            }
            
            [self->fileManager renameItem:node.item NewPath:newPath];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
        }
    } else if ([menuItem.menu.title isEqualToString:@"TableView"]) {
        
        NSInteger clickedRow = [self->tableView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            Item *item = [self->tableDataSource itemAtIndex:clickedRow];
            
            RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
            NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
            wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
            wind.title = @"Введите новое имя";
            renameView.text.stringValue = item.name;
            NSInteger result = [NSApp runModalForWindow:wind];
            
            NSString *newPath;
            if (result == 1000) {
                NSString *newName = renameView.text.stringValue;
                newPath = [self getNewPathForItem:item NewName:newName];
            } else if (result == 1001) {
                return;
            }

            [self->fileManager renameItem:item NewPath:newPath];
            Item *newItem = [[Item alloc] initWithPath:newPath isFile:item.isFile];
            [self->tableDataSource replaceItemAtIndex:clickedRow WithItem:newItem];
            [self->tableView reloadData];
        }
    }
}

- (void)createItemClick:(id)sender {            //создание папки работает!
    
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    if ([menuItem.menu.title isEqualToString:@"OutlineView"]) {
        
        NSInteger clickedRow = [self->outlineView clickedRow];
        if (clickedRow == -1) {
            
            NSAlert *alert = [[NSAlert alloc] init];
            alert.alertStyle = NSInformationalAlertStyle;
            alert.messageText = @"Элемент не выбран";
            alert.informativeText = @"Выберите элемент";
            [alert runModal];
            
        } else {
            
            TreeNode *node = [self->outlineView itemAtRow:clickedRow];
            
            RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
            NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
            wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
            wind.title = @"Введите имя папки";
            NSInteger result = [NSApp runModalForWindow:wind];
            
            NSString *newPath;
            if (result == 1000) {
                NSString *newName = renameView.text.stringValue;
                newPath = [NSString stringWithFormat:@"%@/%@",node.item.path,newName];
            } else if (result == 1001) {
                return;
            }
            
            Item *newItem = [[Item alloc] initWithPath:newPath isFile:false];
            [self->fileManager createFolder:newItem];
            [self->outlineView reloadItem:node.parent reloadChildren:true];
        }
    } else if ([menuItem.menu.title isEqualToString:@"TableView"]) {
        
        NSInteger clickedRow = [self->tableView clickedRow];
        if (clickedRow == -1) {
            
            TreeNode *node = [self->outlineView itemAtRow:[self->outlineView selectedRow]];
            Item *item = node.item;
            
            RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
            NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
            wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
            wind.title = @"Введите имя папки";
            NSInteger result = [NSApp runModalForWindow:wind];
            
            NSString *newPath;
            if (result == 1000) {
                NSString *newName = renameView.text.stringValue;
                newPath = [NSString stringWithFormat:@"%@/%@",item.path,newName];
            } else if (result == 1001) {
                return;
            }
            
            Item *newItem = [[Item alloc] initWithPath:newPath isFile:false];
            [self->fileManager createFolder:newItem];
            [self->tableDataSource addItem:newItem];
            [self->tableView reloadData];
            
        } else {
            
            Item *item = [self->tableDataSource itemAtIndex:clickedRow];
            if (item.isFile) {
                
                NSAlert *alert = [[NSAlert alloc] init];
                alert.alertStyle = NSInformationalAlertStyle;
                alert.messageText = @"Ошибка";
                alert.informativeText = @"Нельзя скопировать в файл";
                [alert runModal];
                return;

            } else {
                
                RenameModalViewController *renameView = [[RenameModalViewController alloc] init];
                NSWindow *wind = [NSWindow windowWithContentViewController:renameView];
                wind.styleMask = NSBorderlessWindowMask|NSTitledWindowMask;
                wind.title = @"Введите имя папки";
                NSInteger result = [NSApp runModalForWindow:wind];
                
                NSString *newPath;
                if (result == 1000) {
                    NSString *newName = renameView.text.stringValue;
                    newPath = [NSString stringWithFormat:@"%@/%@",item.path,newName];
                } else if (result == 1001) {
                    return;
                }
                
                Item *newItem = [[Item alloc] initWithPath:newPath isFile:false];
                [self->fileManager createFolder:newItem];
                [self->tableDataSource addItem:newItem];
                [self->tableView reloadData];
                
            }
        }
    }
}

#pragma mark - Изменение строки -

/** Метод принимает итем и новое имя, возвращает готовый путь для переименованого итема */

- (NSString *)getNewPathForItem:(Item *)item NewName:(NSString *)newName {
    
    NSArray <NSString *> *arr = [item.path componentsSeparatedByString:@"/"];
    NSString *oldName = [arr lastObject];
    NSArray <NSString *> *arr1 = [item.path componentsSeparatedByString:oldName];
    NSString *str = [arr1 firstObject];
    NSString *newPath = [NSString stringWithFormat:@"%@%@",str,newName];
    
    //NSLog(@"Old Path %@",item.path);
    //NSLog(@"New Path %@",newPath);

    return newPath;
}

@end
