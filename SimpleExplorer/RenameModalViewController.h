//
//  RenameModalViewController.h
//  SimpleExplorer
//
//  Created by Виктор on 14.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RenameModalViewController : NSViewController
{
    IBOutlet NSTextField *text;
}

@property NSTextField *text;

- (IBAction)okButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;

@end
