//
//  IHMainVC+IHGithubStar.m
//  iconhelper
//
//  Created by Xun on 2018/3/22.
//  Copyright © 2018年 xun. All rights reserved.
//

#import "IHMainVC+IHGithubStar.h"

static NSAlert * Alert = nil;

@implementation IHMainVC (IHGithubStar)

#define kShowGithubDialog @"show.github.star.dialog"

- (void)showGithubStarDialogIfNeed {
    
    if ([self notShowGithubStarDialog]) return;
    
    NSAlert *alert = [[NSAlert alloc] init];
    Alert = alert;
    
    alert.alertStyle = NSAlertStyleInformational;
    alert.messageText = @"感觉不错，去Github上给个✨吧！";
    
    NSButton *nextBtn = [alert addButtonWithTitle:@"下次再说"];
    NSButton *nowBtn = [alert addButtonWithTitle:@"现在就去"];
    NSButton *noBtn = [alert addButtonWithTitle:@"不再提示"];
    
    nextBtn.target = self;
    nextBtn.action = @selector(delayGiveStar);
    
    nowBtn.target = self;
    nowBtn.action = @selector(goToGithub);
    
    noBtn.target = self;
    noBtn.action = @selector(noShow);
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
}

- (void)delayGiveStar {
    [Alert.window close];
    Alert = nil;
}

- (void)goToGithub {
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://github.com/ListenXunInNight/iconhelper"]];
    [self noShow];
}

- (void)noShow {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kShowGithubDialog];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [Alert.window close];
    Alert = nil;
}

- (BOOL)notShowGithubStarDialog {
    int show = [[[NSUserDefaults standardUserDefaults] valueForKey:kShowGithubDialog] intValue];

    return show;
}

@end
