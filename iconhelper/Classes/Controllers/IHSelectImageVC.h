//
//  IHSelectImageVC.h
//  iconhelper
//
//  Created by xun on 2017/12/11.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IHSelectImageVC : NSViewController

@property (nonatomic, strong) NSMutableArray *imagePaths;

@property (nonatomic, copy) void(^DeleteBlock)(void);

@end
