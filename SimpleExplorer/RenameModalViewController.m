//
//  RenameModalViewController.m
//  SimpleExplorer
//
//  Created by Виктор on 14.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "RenameModalViewController.h"

@interface RenameModalViewController ()

@end

@implementation RenameModalViewController

@synthesize text;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)okButtonClick:(id)sender {
    [NSApp stopModalWithCode:1000];
    [self.view.window orderOut:self];

}

- (void)cancelButtonClick:(id)sender {
    [NSApp stopModalWithCode:1001];
    [self.view.window orderOut:self];

}

@end
