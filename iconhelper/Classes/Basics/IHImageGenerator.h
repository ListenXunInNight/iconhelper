//
//  IHImageGenerator.h
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface NSImage (IHImageGenerator)
- (NSData *)dataWithSize:(CGSize)size;
@end

@class IHConfig;

@interface IHImageGenerator: NSObject

+ (instancetype)generator;

- (void)generateWithSource:(NSString *)source
                    config:(IHConfig *)config;

@end
