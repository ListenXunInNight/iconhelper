//
//  IHExportLog.m
//  iconhelper
//
//  Created by Xun on 2018/3/28.
//  Copyright © 2018年 xun. All rights reserved.
//

#import "IHExportLog.h"

static NSMutableString *ExportLog = nil;
static NSDateFormatter *dateFormatter = nil;

@implementation IHExportLog

+ (void)initialize {
    ExportLog = @"".mutableCopy;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"[yyyy-MM-dd HH:mm:ss] "];
}

+ (void)exportImageFailed:(NSString *)image {
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [ExportLog appendString:dateString];
    [ExportLog appendString:@"Exported "];
    [ExportLog appendString:image];
    [ExportLog appendString:@"failed.\n"];
}

+ (void)clear {
    ExportLog = @"".mutableCopy;
}

+ (BOOL)haveFailedLog {
    return ExportLog.length;
}

@end
