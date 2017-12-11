//
//  IHConfigVC.m
//  iconhelper
//
//  Created by xun on 2017/12/9.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "IHConfigVC.h"
#import "IHButton.h"
#import "NSFileManager+IconHelper.h"
#import "IHConfig.h"
#import "IHFilePanel.h"

@interface IHConfigVC ()

@property (weak) IBOutlet IHButton *appIconBtn;
@property (weak) IBOutlet IHButton *iPhoneBtn;
@property (weak) IBOutlet IHButton *iWatchBtn;
@property (weak) IBOutlet IHButton *iMacBtn;
@property (weak) IBOutlet IHButton *scaleBtn;

@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet NSTextField *widthTF;
@property (weak) IBOutlet NSTextField *heightTF;

@property (nonatomic, strong) IHConfig *config;
@property (nonatomic, strong) IHAppIconConfig *appIconConfig;
@property (nonatomic, strong) IHScaleImageConfig *scaleImageConfig;
@property (weak) IBOutlet IHButton *defaultBtn;

@property (weak) IBOutlet NSPathControl *pathControl;

@end

@implementation IHConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupUI {
    
    _appIconBtn.selectedImage = [NSImage imageNamed:@"check"];
    _appIconBtn.unselectedImage = [NSImage imageNamed:@"uncheck"];
    _scaleBtn.selectedImage = [NSImage imageNamed:@"check"];
    _scaleBtn.unselectedImage = [NSImage imageNamed:@"uncheck"];
    _defaultBtn.selectedImage = [NSImage imageNamed:@"check"];
    _defaultBtn.unselectedImage = [NSImage imageNamed:@"uncheck"];
    
    _iPhoneBtn.selectedImage = [NSImage imageNamed:@"iPhone_select"];
    _iWatchBtn.selectedImage = [NSImage imageNamed:@"iWatch_select"];
    _iMacBtn.selectedImage = [NSImage imageNamed:@"iMac_select"];
    
    _iPhoneBtn.unselectedImage = [NSImage imageNamed:@"iPhone_unselect"];
    _iWatchBtn.unselectedImage = [NSImage imageNamed:@"iWatch_unselect"];
    _iMacBtn.unselectedImage = [NSImage imageNamed:@"iMac_unselect"];
    
    _pathControl.URL = [NSURL fileURLWithPath:IHConfig.destination];
}

- (void)viewWillLayout {
    
    [super viewWillLayout];
    
    [self setupUI];
    
    _config = [IHConfig lastConfig];
    
    if (!_config) {_config = [IHConfig defaultConfig];}
    
    if ([_config isKindOfClass:[IHAppIconConfig class]]) {
        
        self.appIconConfig = (id)_config;
        self.scaleImageConfig = (id)[IHConfig scaleImageConfig];
        [self clickedAppIconBtn:_appIconBtn];
    }
    else {
        self.appIconConfig = (id)[IHConfig appIconConfig];
        self.scaleImageConfig = (id)_config;
        [self clickedScaleBtn:_scaleBtn];
    }
}

#pragma mark - Btn Clicked

- (IBAction)clickedAppIconBtn:(id)sender {
    
    if (!_appIconBtn.isSelected) {
    
        _config = self.appIconConfig;
        
        [self enableAppIcon:YES];
        [self enableScale:NO];
    }
}

- (IBAction)clickedScaleBtn:(id)sender {
    
    if (!_scaleBtn.isSelected) {
        _config = self.scaleImageConfig;
        
        [self enableAppIcon:NO];
        [self enableScale:YES];
    }
}

- (IBAction)clickedDevice:(id)sender {
    
    IHButton *btn = sender;
    btn.selected = !btn.isSelected;
}

- (IBAction)cancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelWithConfigVC:)]) {
        [self.delegate cancelWithConfigVC:self];
    }
}

- (IBAction)confirm:(id)sender {

    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:NSFileManager.archivePath]) {
        [fm createDirectoryAtPath:NSFileManager.archivePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (_appIconBtn.isSelected) {
        
        _appIconConfig.type = _iPhoneBtn.selected | _iWatchBtn.selected << 1 | _iMacBtn.selected << 2;
    }
    else {
        _scaleImageConfig.way = _segmentedControl.selectedSegment;
        _scaleImageConfig.width = _widthTF.stringValue.floatValue;
        _scaleImageConfig.height = _heightTF.stringValue.floatValue;
    }
    BOOL success = [NSKeyedArchiver archiveRootObject:_config toFile:[NSFileManager.archivePath stringByAppendingPathComponent:@"config.txt"]];
    
    if (!success) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Config save failed."];
        
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            
        }];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(okWithConfig:VC:)]) {
            [self.delegate okWithConfig:_config VC:self];
        }
    }
}
- (IBAction)changeSegmentedControlValue:(id)sender {
    
    _widthTF.enabled = _segmentedControl.selectedSegment;
    _heightTF.enabled = _segmentedControl.selectedSegment;
}

- (IBAction)clickedPathControl:(NSPathControl *)sender {
    
    IHFilePanel *panel = [IHFilePanel selectFoldPanel];
    
    __weak typeof(panel) weakpanel = panel;
    
    [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse result) {
        
    }];
    
    panel.ok = ^{
        
        IHConfig.destination = weakpanel.URLs.firstObject.path;
        _pathControl.URL = weakpanel.URLs.firstObject;
    };
}

- (IBAction)clickedDefaultBtn:(IHButton *)sender {
    
    sender.selected = !sender.isSelected;
    _pathControl.enabled = !sender.isSelected;
    
    IHConfig.specifyDestination = !sender.isSelected;
}


#pragma mark - Setter

- (void)setAppIconConfig:(IHAppIconConfig *)appIconConfig {
    
    _appIconConfig = appIconConfig;
    
    _iPhoneBtn.selected = _appIconConfig.type & 1;
    _iWatchBtn.selected = _appIconConfig.type & 2;
    _iMacBtn.selected = _appIconConfig.type & 4;
    
    [self enableAppIcon:YES];
    [self enableScale:NO];
}

- (void)setScaleImageConfig:(IHScaleImageConfig *)scaleImageConfig {
    
    _scaleImageConfig = scaleImageConfig;
    
    _segmentedControl.selectedSegment = _scaleImageConfig.way;
    
    if (_scaleImageConfig.width <= 0) {
        _widthTF.stringValue = @"";
    }
    else {
        _widthTF.stringValue = @(_scaleImageConfig.width).stringValue;
    }
    
    if (_scaleImageConfig.height <= 0) {
        _heightTF.stringValue = @"";
    }
    else {
        _heightTF.stringValue = @(_scaleImageConfig.height).stringValue;
    }
    
    [self enableAppIcon:NO];
    [self enableScale:YES];
}

#pragma mark - Logic

- (void)enableAppIcon:(BOOL)enable {
    
    _appIconBtn.selected = enable;
    _iPhoneBtn.enabled = enable;
    _iMacBtn.enabled = enable;
    _iWatchBtn.enabled = enable;
}

- (void)enableScale:(BOOL)enable {
    
    _scaleBtn.selected = enable;
    _segmentedControl.enabled = enable;
    _widthTF.enabled = enable & _segmentedControl.selectedSegment;
    _heightTF.enabled = enable & _segmentedControl.selectedSegment;
}

@end
