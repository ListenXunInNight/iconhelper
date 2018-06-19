//
//  IHHandleFileDelegate.h
//  iconhelper
//
//  Created by xun on 2018/1/2.
//  Copyright © 2018年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IHHandleFileDelegate <NSObject>

- (void)openFiles:(NSArray <NSString *> *)files;

@end
