//
//  IHButton.h
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IHButton : NSButton

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, strong) NSImage *selectedImage;
@property (nonatomic, strong) NSImage *unselectedImage;

@end
