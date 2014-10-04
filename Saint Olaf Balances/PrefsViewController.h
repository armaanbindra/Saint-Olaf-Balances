//
//  PrefsViewController.h
//  Saint Olaf Balances
//
//  Created by Armaan Bindra2 on 8/30/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PrefsViewController : NSViewController <NSAlertDelegate,NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
- (IBAction)savedData:(id)sender;

@end
