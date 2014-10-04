//
//  PrefsViewController.m
//  Saint Olaf Balances
//
//  Created by Armaan Bindra2 on 8/30/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import "PrefsViewController.h"
#import "DataHandler.h"
@interface PrefsViewController ()

@end

@implementation PrefsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordField.delegate=self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actuallySaveData:)
                                                 name:@"kTryingToAuthenticate"
                                               object:nil];
    if ([defaults objectForKey:@"kExists"]) {
        [_usernameField setStringValue:[defaults objectForKey:@"kUsername"]];
        [_passwordField setStringValue:[defaults objectForKey:@"kPassword"]];
    }
    
    // Do view setup here.
}

- (IBAction)savedData:(id)sender {
    [DataHandler authenticateUser:[_usernameField stringValue]  password:[_passwordField stringValue]];
}
-(void)actuallySaveData:(NSNotification *)notification
{
    NSString * proceed = [notification.userInfo objectForKey:@"Login Success"];
    if ([proceed isEqualToString:@"YES"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"kExists"];
        [defaults setObject:[_usernameField stringValue] forKey:@"kUsername"];
        [defaults setObject:[_passwordField stringValue] forKey:@"kPassword"];
        [defaults synchronize];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"kReloadBalances" object:self userInfo:nil];
       
    }
    else if([proceed isEqualToString:@"NO"])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Sorry Login Failed!!"];
        [alert setInformativeText:@"Please Check Your Username and Password and try again"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
}


- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    NSLog(@"Selector method is (%@)", NSStringFromSelector( commandSelector ) );
    if (commandSelector == @selector(insertNewline:)) {
        NSLog(@"pressed enter on textfield");
        if (!([_usernameField.stringValue isEqualToString:@""] && [_passwordField.stringValue isEqualToString:@""] )) {
            [self savedData:self];
        }
    }
    return YES;
}
@end
