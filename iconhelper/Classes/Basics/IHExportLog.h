//
//  IHExportLog.h
//  iconhelper
//
//  Created by Xun on 2018/3/28.
//  Copyright © 2018年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHExportLog : NSObject

+ (void)exportImageFailed:(NSString *)image;

+ (void)clear;

+ (BOOL)haveFailedLog;

@end
