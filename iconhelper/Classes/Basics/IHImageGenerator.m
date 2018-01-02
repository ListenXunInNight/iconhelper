//
//  IHImageGenerator.m
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHImageGenerator.h"
#import "IHConfig.h"

@implementation NSImage (IHImageGenerator)

- (NSData *)dataWithSize:(CGSize)size {
    
    return [self dataWithSize:size type:NSBitmapImageFileTypePNG];
}

- (NSData *)dataWithSize:(CGSize)size type:(NSBitmapImageFileType)type {
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil pixelsWide:size.width pixelsHigh:size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bitmapFormat:0 bytesPerRow:4 * size.width bitsPerPixel:32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
    
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext.currentContext = ctx;
    
    [self drawInRect:NSMakeRect(0, 0, size.width, size.height)];
    
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return [rep representationUsingType:type properties:@{}];
}

@end

@implementation IHImageGenerator

+ (instancetype)generator {
    
    IHImageGenerator *generator = [[self alloc] init];
    
    return generator;
}

- (void)generateWithSource:(NSString *)source
                    config:(IHConfig *)config
                  callback:(CreateImageBlock)block {
    
    if ([config isKindOfClass:NSClassFromString(@"IHAppIconConfig")]) {
        
        AppIconType type = [[config valueForKey:@"type"] unsignedIntValue];
        
        [self generateWithSource:source type:type callback:block];
    }
    else if ([config isKindOfClass:NSClassFromString(@"IHScaleImageConfig")]) {
        
        ScaleImageWay way = [[config valueForKey:@"way"] unsignedIntValue];
        
        if (way == ScaleImageNormal) {
            [self generateWithSource:source callback:block];
        }
        else {
            
            NSString *prefix = @"";
            if (IHConfig.specifyDestination) {
                self.destination = [source stringByDeletingLastPathComponent];
                prefix = @"resize_";
            }
            
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
            
            CGFloat width = [[config valueForKey:@"width"] floatValue];
            CGFloat height = [[config valueForKey:@"height"] floatValue];
            
            CGSize size = CGSizeMake(width, height);
            
            if (way == ScaleImageByRate) {
                
                size.width = image.size.width * width;
                size.height = image.size.height * height;
            }
            
            NSString *suffix = [source pathExtension].lowercaseString;
            
            if ([suffix isEqualToString:@"jpg"] ||
                [suffix isEqualToString:@"jpeg"]) {
                
                NSString *imagePath = [self.destination stringByAppendingFormat:@"/%@%@", prefix, [source lastPathComponent]];
                NSData *data = [image dataWithSize:size type:NSBitmapImageFileTypePNG];
                [data writeToFile:imagePath atomically:YES];
            }
            else {
                NSString *imagePath = [self.destination stringByAppendingFormat:@"/%@%@", prefix, [source lastPathComponent]];
                NSData *data = [image dataWithSize:size];
                [data writeToFile:imagePath atomically:YES];
            }
        }
    }
}

- (void)generateWithSource:(NSString *)source
                      type:(AppIconType)type
                  callback:(CreateImageBlock)block {
    
    if (IHConfig.specifyDestination) self.destination = [source stringByDeletingLastPathComponent];
    NSArray <NSNumber *> *macOS = @[@1024, @512, @256, @128, @64, @32, @16];
    NSArray <NSNumber *> *iOS = @[@1024, @180, @167, @152, @120, @87,
                                  @80, @76, @60, @58, @40, @29, @20];
    NSArray <NSNumber *> *watchOS = @[@1024, @196, @172, @88, @87, @80, @58, @55, @48];
    
    NSString *name = [[source lastPathComponent] stringByDeletingLastPathComponent];
    
    if (type & AppIconType_iOS) {
        
        [self generateWithSource:source
                           sizes:iOS
                       directory:[name stringByAppendingString:@"iOSAppIcon"]
                        callback:block];
    }
    if (type & AppIconType_macOS) {
        
        [self generateWithSource:source
                           sizes:macOS
                       directory:[name stringByAppendingString:@"macOSAppIcon"]
                        callback:block];
    }
    if (type & AppIconType_watchOS) {
        
        [self generateWithSource:source
                           sizes:watchOS
                       directory:[name stringByAppendingString:@"watchOSAppIcon"]
                        callback:block];
    }
}

- (void)generateWithSource:(NSString *)source
                     sizes:(NSArray <NSNumber *> *)sizes
                 directory:(NSString *)directory
                  callback:(CreateImageBlock)block {
    
    NSString *des = [self.destination stringByAppendingPathComponent:directory];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:des]) {
        [fm createDirectoryAtPath:des withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
    for (int i = 0; i < sizes.count; i++) {
        
        NSString *imagePath = [des stringByAppendingFormat:@"/AppIcon_%@.png", sizes[i]];
        CGSize size = CGSizeMake(sizes[i].floatValue, sizes[i].floatValue);
        NSData *data = [image dataWithSize:size];
        BOOL result = [data writeToFile:imagePath atomically:YES];
        
        if (block) if (!block(source, result)) break;
    }
}

- (void)generateWithSource:(NSString *)source
                  callback:(CreateImageBlock)block {
    
    if (IHConfig.specifyDestination) self.destination = [source stringByDeletingLastPathComponent];
    
    NSString *suffix = @".png";
    NSString *name = [[source lastPathComponent] stringByDeletingPathExtension];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
    
    CGSize size[3] = {CGSizeMake((int)(image.size.width / 3), (int)(image.size.height / 3)),
        CGSizeMake((int)(image.size.width * 2 / 3), (int)(image.size.height * 2 / 3)),
        image.size};
    
    for (int i = 0; i < 3; i++) {
        
        NSString *scale = [self.destination stringByAppendingFormat:@"/%@@%dx%@", name, i + 1, suffix];
        NSData *data = [image dataWithSize:size[i]];
        BOOL result = [data writeToFile:scale atomically:YES];
        if (block) if (!block(scale, result)) break;
    }
}

@end

