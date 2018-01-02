//
//  AppDelegate.h
//  iconhelper
//
//  Created by xun on 2017/12/7.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IHHandleFileDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) id <IHHandleFileDelegate> handleFileDelegate;

@end

