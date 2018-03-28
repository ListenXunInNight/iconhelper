//
//  IHMainVC+IHGithubStar.m
//  iconhelper
//
//  Created by Xun on 2018/3/22.
//  Copyright © 2018年 xun. All rights reserved.
//

#import "IHMainVC+IHGithubStar.h"

@implementation IHMainVC (IHGithubStar)

#define kShowGithubDialog @"show.github.star.dialog"

- (void)showGithubStarDialogIfNeed {
    
    if ([self notShowGithubStarDialog]) return;
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    alert.alertStyle = NSAlertStyleInformational;
    alert.messageText = @"感觉不错，去Github上给个✨吧！";
    
    NSButton *nextBtn = [alert addButtonWithTitle:@"下次再说"];
    NSButton *nowBtn = [alert addButtonWithTitle:@"现在就去"];
    NSButton *noBtn = [alert addButtonWithTitle:@"不再提示"];
    
    nextBtn.target = self;
    nextBtn.action = @selector(delayGiveStar);
    
    nowBtn.target = self;
    nowBtn.action = @selector(goToGithub:);
    
    noBtn.target = self;
    noBtn.action = @selector(noShow);
    
    [alert runModal];
}

- (void)delayGiveStar {
    [self dismissController:nil];
}

- (void)goToGithub {
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://github.com/ListenXunInNight/iconhelper"]];
    [self noShow];
    [self dismissController:nil];
}

- (void)noShow {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kShowGithubDialog];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissController:nil];
}

- (BOOL)notShowGithubStarDialog {
    return NO;
//    int show = [[[NSUserDefaults standardUserDefaults] valueForKey:kShowGithubDialog] intValue];
//
//    return show;
}

@end
