//
//  IHConfig.h
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AppIconType) {
    AppIconType_iOS = 1,
    AppIconType_watchOS = AppIconType_iOS << 1,
    AppIconType_macOS = AppIconType_iOS << 2
};

typedef NS_ENUM(NSUInteger, ScaleImageWay) {
    ScaleImageNormal,
    ScaleImageBySize,
    ScaleImageByRate
};

@interface IHConfig : NSObject

@property (class, readonly) IHConfig *appIconConfig;
@property (class, readonly) IHConfig *scaleImageConfig;
@property (class, readonly) IHConfig *defaultConfig;
@property (class, readonly) IHConfig *lastConfig;

@property (class) NSString *destination;
@property (class, getter=isSpecifyDestination) BOOL specifyDestination;

@end


@interface IHAppIconConfig: IHConfig <NSCoding>
@property (nonatomic, assign) AppIconType type;
@end

@interface IHScaleImageConfig: IHConfig <NSCoding>
@property (assign) ScaleImageWay way;
@property (assign) CGFloat width;
@property (assign) CGFloat height;
@end


