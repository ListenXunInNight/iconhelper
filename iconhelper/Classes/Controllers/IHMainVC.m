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

@interface IHMainVC () <IHConfigVCDelegate, IHHandleFileDelegate>

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
}

- (void)setupUI {
    
    [[[NSApplication sharedApplication].keyWindow standardWindowButton:NSWindowZoomButton] removeFromSuperview];
    _badgeTF.layer.cornerRadius = 10.f;
    _badgeTF.layer.masksToBounds = YES;
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self setupUI];
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
    generator.destination = IHConfig.destination;
    
    [_selectItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        [generator generateWithSource:obj config:_config callback:^BOOL(NSString *path, BOOL success) {
            
            if (success) {[weakself.selectItems removeObject:obj];}
            return YES;
        }];
        [self updateBadge];
    }];
}
- (IBAction)clickedCheckBtn:(id)sender {
    
    
}

- (void)updateBadge {
    
    _badgeTF.hidden = !_selectItems.count;
    _badgeTF.stringValue = @(_selectItems.count).stringValue;
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

- (void)okWithConfig:(IHConfig *)config VC:(IHConfigVC *)vc {
    [self dismissViewController:vc];
    
    _config = config;
}

@end
