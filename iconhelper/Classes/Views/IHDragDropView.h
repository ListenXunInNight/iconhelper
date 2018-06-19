//
//  IHDragDropView.h
//  iconhelper
//
//  Created by xun on 2018/2/5.
//  Copyright © 2018年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IHDragDropView;

@protocol IHDragDropViewDelegate <NSObject>

- (void)dragDropFiles:(NSArray <NSString *> *)paths
       inDragDropView:(IHDragDropView *)dragDropView;

@end

@interface IHDragDropView : NSView

@property (nonatomic, weak) id <IHDragDropViewDelegate> delegate;

@end
