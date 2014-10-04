//
//  AppDelegate.m
//  Saint Olaf Balances
//
//  Created by Armaan Bindra2 on 8/30/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import "AppDelegate.h"
#import "HTMLParser.h"
#import "DataHandler.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(sendReloadNOTIFICATION)
                                   userInfo:nil
                                    repeats:YES];
    }

-(void)sendReloadNOTIFICATION
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"kReloadBalances" object:self userInfo:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
