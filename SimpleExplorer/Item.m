//
//  Item.m
//  SimpleExplorer
//
//  Created by Виктор on 10.06.16.
//  Copyright © 2016 Виктор. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize path;
@synthesize isFile;
@synthesize name;
@synthesize size;
@synthesize changeDate;

- (instancetype)initWithPath:(NSString *)aPath isFile:(BOOL)aFile {
    
    self = [super init];
    if (self != nil) {
        self->path = aPath;
        self->isFile = aFile;
        self->name = [self _getFileName];
        self->size = [self _getFileSize];
        self->changeDate = [self _getFileDate];
    }
    return self;
}

- (NSString *)_getFileName {
    NSArray <NSString *> *arr = [self->path componentsSeparatedByString:@"/"];
    NSString *str = [arr lastObject];
    return str;
}

- (NSNumber *)_getFileSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:self->path error:nil];
    return [attributes objectForKey:NSFileSize];
}

- (NSDate *)_getFileDate {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:self->path error:nil];
    return [attributes objectForKey:NSFileModificationDate];
}

@end
