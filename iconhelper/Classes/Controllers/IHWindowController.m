//
//  IHWindowController.m
//  iconhelper
//
//  Created by xun on 2017/12/11.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHWindowController.h"

@interface IHWindowController () <NSWindowDelegate>

@end

@implementation IHWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.acceptsMouseMovedEvents = YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    
    exit(0);
}

@end
