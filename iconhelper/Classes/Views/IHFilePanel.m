//
//  IHFilePanel.m
//  iconhelper
//
//  Created by xun on 2017/12/8.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHFilePanel.h"

@implementation IHFilePanel

+ (instancetype)defaultPanel {
    
    return [self selectFoldPanel];
}

+ (instancetype)selectFoldPanel {
    
    IHFilePanel *panel = [[IHFilePanel alloc] init];
    
    [panel generalConfig];
    [panel foldConfig];
    
    return panel;
}

+ (instancetype)selectImagePanel {
    
    IHFilePanel *panel = [[IHFilePanel alloc] init];
    
    [panel generalConfig];
    [panel imageConfig];
    
    return panel;
}

- (void)generalConfig {
    
    self.prompt = @"选择";
    self.showsToolbarButton = false;
    self.allowsMultipleSelection = YES;
    
    NSButton *cancelBtn = [self valueForKeyPath:@"_cancelButton"];
    [cancelBtn setTitle:@"取消"];
}

- (void)imageConfig {
    
    self.title = @"图片选择器";
    self.allowedFileTypes = @[@"png", @"jpg", @"jpeg"];
    self.canChooseFiles = YES;
}

- (void)foldConfig {
    self.title = @"路径选择";
    self.canChooseFiles = NO;
    self.allowsMultipleSelection = NO;
    self.canChooseDirectories = YES;
}

- (IBAction)ok:(id)sender {
    
    [super ok:sender];
    !_ok?:_ok();
}

- (IBAction)cancel:(id)sender {
    
    [super cancel:sender];
}

@end
