//
//  IHImageItem.m
//  iconhelper
//
//  Created by xun on 2017/12/11.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHImageItem.h"
#import "IHImageGenerator.h"

@interface IHImageItem ()
@property (nonatomic, strong) NSTrackingArea *area;
@end

@implementation IHImageItem

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillLayout {
    [super viewWillLayout];
    
    if (![self.view.trackingAreas containsObject:self.area]) {
        [self.view addTrackingArea:self.area];
    }
}

- (void)setPath:(NSString *)path {

    _path = path;
    
    _titleLab.stringValue = [path lastPathComponent];
    _pathLab.stringValue = path;
    
    __block CGSize size = self.view.frame.size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
        
        CGFloat whRatio = image.size.width / image.size.height;
        
        if (whRatio >= 1) {
            
            if (size.width < image.size.width) {
                
                size.height = size.width / whRatio;
            }
        }
        else {
            
            if (size.height < image.size.height) {
                size.width = size.height * whRatio;
            }
        }
        
        NSData *data = [image dataWithSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            _preview.image = [[NSImage alloc] initWithData:data];
        });
    });
}

- (void)mouseEntered:(NSEvent *)event {
    self.pathLab.hidden = NO;
}

- (void)mouseExited:(NSEvent *)event {
    self.pathLab.hidden = YES;
}

#pragma mark - Getter & Setter

- (NSTrackingArea *)area {
    if (!_area) {
        _area = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow owner:self.view userInfo:nil];
    }return _area;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.coverImage.hidden = !selected;
}

@end
