//
//  IHMainVC.m
//  iconhelper
//
//  Created by xun on 2017/12/8.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHMainVC.h"
#import "IHFilePanel.h"
#import "IHImageGenerator.h"
#import "IHConfigVC.h"
#import "IHConfig.h"
#import "IHSelectImageVC.h"
#import "AppDelegate.h"
#import "IHDragDropView.h"

@interface IHMainVC () <IHConfigVCDelegate, IHHandleFileDelegate, IHDragDropViewDelegate>

@property (weak) IBOutlet NSButton *importBtn;
@property (weak) IBOutlet NSButton *configBtn;
@property (weak) IBOutlet NSButton *exportBtn;
@property (weak) IBOutlet NSButton *checkBtn;
@property (weak) IBOutlet NSTextField *badgeTF;

@property (nonatomic, strong) NSMutableArray *selectItems;
@property (nonatomic, strong) IHConfig *config;

@end

@implementation IHMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectItems = @[].mutableCopy;
    _config = [IHConfig lastConfig];
    
    AppDelegate *delegate = [NSApplication sharedApplication].delegate;
    
    delegate.handleFileDelegate = self;
    [(IHDragDropView *)self.view setDelegate:self];
}

- (void)viewWillAppear {
    [super viewWillAppear];
}

#pragma mark - Btn Clicked

- (IBAction)clickedImportBtn:(id)sender {

    __weak typeof(self) weakself = self;
    
    IHFilePanel *panel = [IHFilePanel selectImagePanel];
    
    __weak typeof(panel) weakpanel = panel;
    
    [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse result) {
        
    }];
    
    panel.ok = ^{
        
        for (NSURL *selectURL in weakpanel.URLs) {
            BOOL existSame = NO;
            for (NSString *add in weakself.selectItems) {
                existSame = [selectURL.path isEqualToString:add];
                if (existSame) { break;}
            }
            if (!existSame) {[weakself.selectItems addObject:selectURL.path];}
        }
        [weakself updateBadge];
    };
}

- (IBAction)clickedConfigBtn:(id)sender {
    
}
- (IBAction)clickedExportBtn:(id)sender {
    
    if ([_config isKindOfClass:[IHScaleImageConfig class]]) {
        
        IHScaleImageConfig *config = (id)_config;
        
        if (config.way != ScaleImageNormal &&
            (config.width == 0 || config.height == 0)) {
            return;
        }
    }
    __weak typeof(self) weakself = self;
    IHImageGenerator *generator = [IHImageGenerator generator];
    
    [_selectItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        [generator generateWithSource:obj config:weakself.config];
        [weakself.selectItems removeObject:obj];
        
        [self updateBadge];
        if (weakself.selectItems.count == 0) {
            
        }
    }];
}
- (IBAction)clickedCheckBtn:(id)sender {
    
    
}

- (void)updateBadge {
    
    _badgeTF.hidden = !_selectItems.count;
    _badgeTF.stringValue = @(_selectItems.count).stringValue;
    _badgeTF.layer.cornerRadius = 10.f;
    _badgeTF.layer.masksToBounds = YES;
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ToConfigVC"]) {
        
        IHConfigVC *vc = segue.destinationController;
        
        vc.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"ToPreviewVC"]) {
        
        IHSelectImageVC *vc = segue.destinationController;
        
        vc.imagePaths = _selectItems;
        vc.DeleteBlock = ^{
            
            [self updateBadge];
        };
    }
}

#pragma mark - IHHandleFileDelegate

- (void)openFiles:(NSArray<NSString *> *)files {
    
    [_selectItems addObjectsFromArray:files];
    
    [self updateBadge];
}

#pragma mark - IHConfigVCDelegate

- (void)cancelWithConfigVC:(IHConfigVC *)vc {
    [self dismissViewController:vc];
}

#pragma mark - IHDragDropViewDelegate

- (void)dragDropFiles:(NSArray<NSString *> *)paths
       inDragDropView:(IHDragDropView *)dragDropView {
    
    NSMutableArray *filterArr = paths.mutableCopy;
    
    for (int i = 0; ;) {
        
        if (i == filterArr.count - 1) break;
        NSString *suffix = [filterArr[i] pathExtension];
        if (([suffix compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) ||
            ([suffix compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) ||
            ([suffix compare:@"jpeg" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
            i++;
        }
        else {
            [filterArr removeObjectAtIndex:i];
        }
    }
    
    [self openFiles:filterArr];
}

- (void)okWithConfig:(IHConfig *)config VC:(IHConfigVC *)vc {
    [self dismissViewController:vc];
    
    _config = config;
}

@end
