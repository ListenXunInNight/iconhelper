//
//  IHFilePanel.h
//  iconhelper
//
//  Created by xun on 2017/12/8.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^OKBlock)(void);

@interface IHFilePanel : NSOpenPanel

@property (nonatomic, copy) OKBlock ok;

+ (instancetype)defaultPanel;
+ (instancetype)selectImagePanel;
+ (instancetype)selectFoldPanel;

@end
