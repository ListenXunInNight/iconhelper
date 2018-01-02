//
//  AppDelegate.m
//  iconhelper
//
//  Created by xun on 2017/12/7.
//  Copyright © 2017年 xun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames {
    
    if ([_handleFileDelegate respondsToSelector:@selector(openFiles:)]) {
        
        [_handleFileDelegate openFiles:filenames];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
