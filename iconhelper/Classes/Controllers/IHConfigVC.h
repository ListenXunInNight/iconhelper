//
//  IHConfigVC.h
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IHConfigVC, IHConfig;

@protocol IHConfigVCDelegate <NSObject>
- (void)okWithConfig:(IHConfig *)config VC:(IHConfigVC *)vc;
- (void)cancelWithConfigVC:(IHConfigVC *)vc;
@end

@interface IHConfigVC : NSViewController

@property (nonatomic, weak) id <IHConfigVCDelegate> delegate;

@end
