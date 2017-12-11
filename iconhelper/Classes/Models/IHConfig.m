//
//  IHConfig.m
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHConfig.h"
#import "NSFileManager+IconHelper.h"

@implementation IHConfig

+ (instancetype)config {
    
    return [[self alloc] init];
}

+ (IHConfig *)appIconConfig {
    
    IHAppIconConfig *config = [IHAppIconConfig config];
    config.type = AppIconType_iOS;
    return config;
}

+ (IHConfig *)scaleImageConfig {
    
    return [IHConfig defaultConfig];
}

+ (IHConfig *)defaultConfig {
    
    IHScaleImageConfig *config = [IHScaleImageConfig config];
    config.way = ScaleImageNormal;
    return config;
}

+ (IHConfig *)lastConfig {
    
    NSString *path = [NSFileManager.archivePath stringByAppendingPathComponent:@"config.txt"];
    
    IHConfig *config = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    return config;
}

#define kDestination @"DESTINATION_DIRECTORY"

+ (void)setDestination:(NSString *)destination {
    
    [[NSUserDefaults standardUserDefaults] setValue:destination forKey:kDestination];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)destination {
    
    NSString *directory = [[NSUserDefaults standardUserDefaults] valueForKey:kDestination];
    
    if ((!directory) || [directory isKindOfClass:[NSNull class]] ||
        (!directory.length)) {
        
        directory = NSHomeDirectory();
    }
    
    return directory;
}

#define kSpecifyDestination @"IS_SPECIFY_DESTINATION"
+ (BOOL)specifyDestination {
    
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSpecifyDestination] boolValue];
}

+ (void)setSpecifyDestination:(BOOL)specifyDestination {
    
    [[NSUserDefaults standardUserDefaults] setValue:@(specifyDestination) forKey:kSpecifyDestination];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation IHAppIconConfig

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:_type forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        _type = [aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}

@end

@implementation IHScaleImageConfig

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:_way forKey:@"way"];
    [aCoder encodeInteger:_width forKey:@"width"];
    [aCoder encodeInteger:_height forKey:@"height"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        _way = [aDecoder decodeIntegerForKey:@"way"];
        _width = [aDecoder decodeIntegerForKey:@"width"];
        _height = [aDecoder decodeIntegerForKey:@"height"];
    }
    return self;
}

@end
