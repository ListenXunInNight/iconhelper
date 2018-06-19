//
//  IHDragDropView.m
//  iconhelper
//
//  Created by xun on 2018/2/5.
//  Copyright © 2018年 xun. All rights reserved.
//

#import "IHDragDropView.h"

@implementation IHDragDropView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    
    NSPasteboard *pb = sender.draggingPasteboard;
    
    if ([pb.types containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    
    NSPasteboard *pb = [sender draggingPasteboard];
    NSArray *list = [pb propertyListForType:NSFilenamesPboardType];
    
    if ([self.delegate respondsToSelector:@selector(dragDropFiles:inDragDropView:)]) {
        [self.delegate dragDropFiles:list inDragDropView:self];
    }
    
    return YES;
}

@end
