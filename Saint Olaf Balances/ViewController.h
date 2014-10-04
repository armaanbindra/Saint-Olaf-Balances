//
//  ViewController.h
//  Saint Olaf Balances
//
//  Created by Armaan Bindra2 on 8/30/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSImageView *dispImage;
@property (weak) IBOutlet NSButton *settingsButton;
@property (weak) IBOutlet NSTextField *mealVal;
@property (weak) IBOutlet NSTextField *printVal;
@property (weak) IBOutlet NSTextField *flexVal;
@property (weak) IBOutlet NSTextField *oleVal;
@property (weak) NSString * username;
@property (weak) NSString * password;
@property (weak) IBOutlet NSTextField *windowTitle;
@end

