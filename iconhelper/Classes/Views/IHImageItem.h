//
//  IHImageItem.h
//  iconhelper
//
//  Created by xun on 2017/12/11.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IHImageItem : NSCollectionViewItem
@property (weak) IBOutlet NSImageView *preview;
@property (weak) IBOutlet NSTextField *titleLab;
@property (weak) IBOutlet NSTextField *pathLab;
@property (weak) IBOutlet NSImageView *coverImage;

@property (nonatomic, strong) NSString *path;
@end
