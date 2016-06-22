//
//  Item.h
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
{
    NSString *path;
    BOOL isFile;
    NSString *name;
    NSNumber *size;
    NSDate *changeDate;
}

@property (readonly) NSString *path;
@property (readonly) BOOL isFile;
@property (readonly) NSString *name;
@property (readonly) NSNumber *size;
@property (readwrite) NSDate *changeDate;

- (instancetype)initWithPath:(NSString *)aPath isFile:(BOOL)aFile;

@end
