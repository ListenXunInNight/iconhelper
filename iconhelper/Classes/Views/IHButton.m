//
//  IHButton.m
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHButton.h"

@implementation IHButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    
}

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    
    if (selected) {
        [self setImage:_selectedImage];
    }
    else {
        [self setImage:_unselectedImage];
    }
}

@end
