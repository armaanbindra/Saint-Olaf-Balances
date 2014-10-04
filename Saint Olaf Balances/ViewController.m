//
//  ViewController.m
//  Saint Olaf Balances
//
//  Created by Armaan Bindra2 on 8/30/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import "ViewController.h"
#import "DataHandler.h"

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNotificationObservers];
    [self registerNotificationObservers];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //User Defaults Cleaning Up/Deleting Code
    /*[defaults removeObjectForKey:@"kExists"];
    [defaults removeObjectForKey:@"kUsername"];
    [defaults removeObjectForKey:@"kPassword"];
    [defaults synchronize];*/
    
    //Loads Previously Saved Username and Password
    if ([defaults objectForKey:@"kExists"]) {
        NSLog(@"Yes Indeed they do exist");
        _username = [defaults objectForKey:@"kUsername"];
        _password = [defaults objectForKey:@"kPassword"];
        [self reloadStuff];
    }
    else{
        /*Nothing*/
    }
   
    
    // Do any additional setup after loading the view.
}
-(void)reloadStuff
{
    NSLog(@"Reload Stuff Called and username is %@ ",_username);
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [DataHandler grabImage:_username];
    [DataHandler getDataFromDB:_username password:_password];
    [DataHandler getDataFromDB2:_username password:_password];
    
    
    [self.view.window setTitle:[[NSString alloc] initWithFormat:@"Ole Bank for %@",_username]];
}

-(void)doStuff:(NSNotification *)notification
{
    NSLog(@"Called do stuff");
    NSLog(@"%@", notification.userInfo);
    //NSLog([notification.userInfo objectForKey:@"Flex Dollars"]);
    [self.flexVal setStringValue:[notification.userInfo objectForKey:@"Flex Dollars"]];
    [self.oleVal setStringValue:[notification.userInfo objectForKey:@"Ole Dollars"]];
    [self.printVal setStringValue:[notification.userInfo objectForKey:@"Student Copy/Print"]];
    [self.windowTitle setStringValue:[notification.userInfo objectForKey:@"fullName"]];
}
-(void)setImage:(NSNotification *)notification
{
    NSLog(@"Set Image Called");
    _dispImage.image = [notification.userInfo objectForKey:@"dispImage"];
}
-(void)loadMeals:(NSNotification *)notification
{
    int numMeals = [[notification.userInfo objectForKey:@"NumMeals"] intValue];
    NSLog(@"Num meals recieved and is %d",numMeals);
    if (numMeals==0)
    {
        [self.mealVal setStringValue:@"None"];
        self.mealVal.textColor = [NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    }
    else
    {
        [self.mealVal setStringValue:[self spellInt:numMeals]];
        self.mealVal.textColor = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

- (NSString *) spellInt:(int)number {
    NSNumber *numberAsNumber = [NSNumber numberWithInt:number];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    return [[formatter stringFromNumber:numberAsNumber] capitalizedString];
}

-(void)registerNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doStuff:)
                                                 name:@"RecievedBalanceDetails"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setImage:)
                                                 name:@"kReceivingImage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadMeals:)
                                                 name:@"RecievedMealDetails"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidLoad)
                                                 name:@"kReloadBalances"
                                               object:nil];

}

-(void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"RecievedBalanceDetails"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"kReceivingImage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"RecievedMealDetails"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"kReloadBalances"
                                               object:nil];
}
@end
