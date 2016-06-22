//
//  WindowController.h
//  SimpleExplorer
//
//  Created by Виктор on 21.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const BackNotification;
extern NSString *const CopyNotification;
extern NSString *const PasteNotification;
extern NSString *const DeleteNotification;
extern NSString *const CreateNotification;
extern NSString *const RenameNotification;

@interface WindowController : NSWindowController <NSToolbarDelegate>
{
    IBOutlet NSToolbar *toolbar;
    NSImage *imageBack;
    NSImage *imageCopy;
    NSImage *imagePaste;
    NSImage *imageDelete;
    NSImage *imageCreate;
    NSImage *imageRename;
}

@end
