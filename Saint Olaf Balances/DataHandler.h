//
//  DataHandler.h
//  Scarlett
//
//  Created by Armaan Bindra on 5/1/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTMLParser.h"

@interface DataHandler : NSObject
+ (void)getDataFromDB:(NSString*)username password:(NSString*)password;
+ (void)getDataFromDB2:(NSString*)username password:(NSString*)password;
+ (void)authenticateUser:(NSString*)username password:(NSString*)password;
+ (void)grabImage:(NSString*)username;
@end
