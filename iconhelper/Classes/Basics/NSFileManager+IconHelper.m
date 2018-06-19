//
//  NSFileManager+IconHelper.m
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "NSFileManager+IconHelper.h"

@implementation NSFileManager (IconHelper)

+ (NSString *)archivePath {
    
    NSString *string = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    [string stringByAppendingPathComponent:@"archive"];
    
    return string;
}

@end
