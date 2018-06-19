//
//  IHImageGenerator.m
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHImageGenerator.h"
#import "IHConfig.h"
#import "IHExportLog.h"

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
                    config:(IHConfig *)config {
    
    if ([config isKindOfClass:NSClassFromString(@"IHAppIconConfig")]) {
        
        AppIconType type = [[config valueForKey:@"type"] unsignedIntValue];
        
        [self generateWithSource:source type:type];
    }
    else if ([config isKindOfClass:NSClassFromString(@"IHScaleImageConfig")]) {
        
        ScaleImageWay way = [[config valueForKey:@"way"] unsignedIntValue];
        
        if (way == ScaleImageNormal) {
            [self generateWithSource:source];
        }
        else {
            
            NSString *destination = nil;
            if (!IHConfig.isSpecifyDestination) {
                destination = [source stringByDeletingLastPathComponent];
            }
            else {
                destination = IHConfig.destination;
            }
            
            NSString *name = [[source lastPathComponent] stringByDeletingPathExtension];
            NSString *extension = [source pathExtension];
            
            
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
                
                NSString *imagePath = [destination stringByAppendingFormat:@"/%@_%dx%d.%@", name, size.width, size.height, extension];
                NSData *data = [image dataWithSize:size type:NSBitmapImageFileTypePNG];
                [data writeToFile:imagePath atomically:YES];
            }
            else {
                NSString *imagePath = [destination stringByAppendingFormat:@"/%@_%dx%d.%@", name, size.width, size.height, extension];
                NSData *data = [image dataWithSize:size];
                [data writeToFile:imagePath atomically:YES];
            }
        }
    }
}

- (void)generateWithSource:(NSString *)source
                      type:(AppIconType)type {
    
    NSArray <NSNumber *> *macOS = @[@1024, @512, @256, @128, @64, @32, @16];
    NSArray <NSNumber *> *iOS = @[@1024, @180, @167, @152, @120, @87,
                                  @80, @76, @60, @58, @40, @29, @20];
    NSArray <NSNumber *> *watchOS = @[@1024, @196, @172, @88, @87, @80, @58, @55, @48];
    
    NSString *destination = nil;
    
    if (IHConfig.isSpecifyDestination) {
        
        destination = [IHConfig.destination stringByAppendingPathComponent:[[source lastPathComponent] stringByDeletingPathExtension]];
    }
    else {
        destination = [[source lastPathComponent] stringByDeletingPathExtension];
    }
    
    if (type & AppIconType_iOS) {
        
        [self generateWithSource:source
                           sizes:iOS
                       directory:[destination stringByAppendingString:@"/iOSAppIcon"]];
    }
    if (type & AppIconType_macOS) {
        
        [self generateWithSource:source
                           sizes:macOS
                       directory:[destination stringByAppendingString:@"/macOSAppIcon"]];
    }
    if (type & AppIconType_watchOS) {
        
        [self generateWithSource:source
                           sizes:watchOS
                       directory:[destination stringByAppendingString:@"/watchOSAppIcon"]];
    }
}

- (void)generateWithSource:(NSString *)source
                     sizes:(NSArray <NSNumber *> *)sizes
                 directory:(NSString *)directory {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:directory]) {
        [fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
    for (int i = 0; i < sizes.count; i++) {
        
        NSString *imagePath = [directory stringByAppendingFormat:@"/%@_%@.png", [source.lastPathComponent stringByDeletingPathExtension], sizes[i]];
        CGSize size = CGSizeMake(sizes[i].floatValue, sizes[i].floatValue);
        NSData *data = [image dataWithSize:size];
        BOOL result = [data writeToFile:imagePath atomically:YES];
        
        result?: [IHExportLog exportImageFailed:imagePath];
    }
}

- (void)generateWithSource:(NSString *)source {
    
    NSString *destination = IHConfig.isSpecifyDestination?IHConfig.destination:[source stringByDeletingPathExtension];
    
    NSString *name = [[source lastPathComponent] stringByDeletingPathExtension];
    NSString *extension = source.pathExtension;
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:source];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:destination]) {
        [fm createDirectoryAtPath:destination
      withIntermediateDirectories:YES
                       attributes:NULL
                            error:NULL];
    }
    
    CGSize size[3] = {CGSizeMake((int)(image.size.width / 3.f), (int)(image.size.height / 3.f)),
        CGSizeMake((int)(image.size.width * 2 / 3.f), (int)(image.size.height * 2 / 3.f)),
        image.size};
    
    for (int i = 0; i < 3; i++) {
        
        NSString *imagePath = [destination stringByAppendingFormat:@"/%@@%dx.%@", name, i + 1, extension];
        NSData *data = [image dataWithSize:size[i]];
        BOOL result = [data writeToFile:imagePath atomically:YES];
        result?: [IHExportLog exportImageFailed:imagePath];
    }
}

@end

