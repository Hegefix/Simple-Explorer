//
//  ViewController.h
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Item.h"
#import "TreeNode.h"
#import "OutlineViewDataSource.h"
#import "TableViewDataSource.h"
#import "FileManager.h"
#import "RenameModalViewController.h"
#import "WindowController.h"

@interface ViewController : NSViewController
{
    IBOutlet NSOutlineView *outlineView;
    IBOutlet NSTableView *tableView;
    IBOutlet NSTextField *pathLabel;
}

@end

