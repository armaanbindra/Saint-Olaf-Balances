//
//  DataHandler.m
//  Scarlett
//
//  Created by Armaan Bindra on 5/1/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import "DataHandler.h"

@implementation DataHandler

/*
BOOL connectedToInternet()
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.armaanbindra.com"]];
    return ( URLString != NULL ) ? YES : NO;
}*/

+ (void)getDataFromDB:(NSString*)username password:(NSString*)password
{

    // Start NSURLSession
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // POST parameters
    NSURL *url = [NSURL URLWithString:@"https://www.stolaf.edu/sis/login.cfm"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"login=%@&passwd=%@",username,password];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSURLSessionDataTask returns data, response, and error
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        // Handle response
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if(error == nil) {
            
            if (statusCode == 400) {}
            else if (statusCode == 403) {}
            else if (statusCode == 200) {
                
                NSURL * financials = [NSURL URLWithString:@"https://www.stolaf.edu/sis/st-financials.cfm"];
                //NSString *html= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString *html= [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:financials] encoding:NSUTF8StringEncoding];
                //NSLog(@"The result is %@",html);
                
                NSError *error = nil;
                HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
                
                if (error) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                
                HTMLNode *bodyNode = [parser body];
                
                NSArray *tdNodes = [bodyNode findChildTags:@"td"];
                NSMutableDictionary * balances = [[NSMutableDictionary alloc] init];
                for (HTMLNode *tdNode in tdNodes) {
                    if ([[tdNode getAttributeNamed:@"class"] isEqualToString:@"sis-right"]) {
                        //NSLog(@"%@", [tdNode rawContents]); //Answer to first question
                        NSString * final = [tdNode allContents] ;
                        //final = [final stringByReplacingOccurrencesOfString:@" " withString:@""];
                        //NSLog(@"%@", final); //Answer to first question
                        HTMLNode * next  = [[tdNode nextSibling] nextSibling];
                        NSString * value  = [next contents];
                        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
                        //NSLog(@"%@",value);
                        balances[final]=value;
                    }
                }
                NSArray *spanNodes = [bodyNode findChildTags:@"span"];
                //NSString * loginSuccess = @"YES";
                for (HTMLNode *spanNode in spanNodes) {
                    NSLog(@"%@", [spanNode allContents]);
                    if ([[spanNode getAttributeNamed:@"style"] isEqualToString:@"color: white;"]) {
                        NSString * final = [spanNode allContents] ;
                        final = [final stringByReplacingOccurrencesOfString:@"Signed in as:" withString:@""];
                        final = [final stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        /*final = [final stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];*/
                        //NSArray *array = [final componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        
                        NSLog(@" Here is my Name: %@", final); //Answer to first question
                        balances[@"fullName"]=final;
                        //loginSuccess = @"NO";
                    }
                }

                //NSLog(@"Dictionary: %@",balances);
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"RecievedBalanceDetails" object:self userInfo:balances];
            } else {NSLog( @"Unexpected error");}
        } else {NSLog(error.localizedDescription);}}];
    
    [dataTask resume];
}
+ (void)getDataFromDB2:(NSString*)username password:(NSString*)password
{
    
    // Start NSURLSession
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // POST parameters
    NSURL *url = [NSURL URLWithString:@"https://www.stolaf.edu/apps/olecard/checkbalance/authenticate.cfm?"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSURLSessionDataTask returns data, response, and error
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        // Handle response
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if(error == nil) {
            
            if (statusCode == 400) {}
            else if (statusCode == 403) {}
            else if (statusCode == 200) {
                
                //NSURL * financials = [NSURL URLWithString:@"https://www.stolaf.edu/sis/st-financials.cfm"];
                NSString *html= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //NSString *html= [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:financials] encoding:NSUTF8StringEncoding];
                //NSLog(@"The result is %@",html);
                
                NSError *error = nil;
                HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
                
                if (error) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                
                HTMLNode *bodyNode = [parser body];
                
                NSArray *tdNodes = [bodyNode findChildTags:@"td"];
                NSMutableDictionary * balances = [[NSMutableDictionary alloc] init];
                for (HTMLNode *tdNode in tdNodes) {
                    if ([[tdNode getAttributeNamed:@"id"] isEqualToString:@"mealsleftdaily"]) {
                        //NSLog(@"%@", [tdNode rawContents]); //Answer to first question
                        //NSString * final = [tdNode allContents];
                        NSString * final = @"NumMeals";
                        //final = [final stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSLog(@"%@", final); //Answer to first question
                        HTMLNode * next  = [[tdNode nextSibling] nextSibling] ;
                        NSString * value  = [next contents];
                        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSLog(@"%@",value);
                        balances[final]=value;
                    }
                }
                NSLog(@"Dictionary: %@",balances);
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"RecievedMealDetails" object:self userInfo:balances];
            } else {NSLog( @"Unexpected error");}
        } else {NSLog(error.localizedDescription);}}
                                     ];
    
    [dataTask resume];
}
+ (void)authenticateUser:(NSString*)username password:(NSString*)password
{
    
    // Start NSURLSession
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // POST parameters
    NSURL *url = [NSURL URLWithString:@"https://www.stolaf.edu/sis/login.cfm"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"login=%@&passwd=%@",username,password];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSURLSessionDataTask returns data, response, and error
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        // Handle response
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if(error == nil) {
            
            if (statusCode == 400) {}
            else if (statusCode == 403) {}
            else if (statusCode == 200) {
                
                
                NSString *html= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
               
                //NSLog(@"The result is %@",html);
                
                NSError *error = nil;
                HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
                
                if (error) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                
                HTMLNode *bodyNode = [parser body];
                
                NSArray *inputNodes = [bodyNode findChildTags:@"input"];
                NSMutableDictionary * loginDic = [[NSMutableDictionary alloc] init];
                NSString * loginSuccess = @"YES";
                for (HTMLNode *inputNode in inputNodes) {
                    NSLog(@"%@", [inputNode rawContents]);
                    if ([[inputNode getAttributeNamed:@"value"] isEqualToString:@"Login"]) {
                        NSString * final = [inputNode allContents] ;
                        //final = [final stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSLog(@"%@", final); //Answer to first question
                        loginSuccess = @"NO";
                    }
                }
                loginDic[@"Login Success"]=loginSuccess;
                NSLog(@"Dictionary: %@",loginDic);
               NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"kTryingToAuthenticate" object:self userInfo:loginDic];
            } else {NSLog( @"Unexpected error");}
        } else {NSLog(error.localizedDescription);}}];
    
    [dataTask resume];
}

+ (void)grabImage:(NSString*)username;
{
    NSLog(@"grab image called with username : %@",username);
    NSString * linkOriginal = [[NSString alloc] initWithFormat:@"https://stolaf.edu/personal/directory/index.cfm?fuseaction=SearchResults&email=%@",username];
   NSURL * images = [NSURL URLWithString:linkOriginal];
                //NSLog(@"The result is %@",html);
    NSString *html= [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:images] encoding:NSUTF8StringEncoding];
                NSError *error = nil;
                HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
                if (error) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                HTMLNode *bodyNode = [parser body];
                NSArray *inputNodes = [bodyNode findChildTags:@"img"];
                NSMutableDictionary * imgDic = [[NSMutableDictionary alloc] init];
                NSString * linkForImage ;
                for (HTMLNode *inputNode in inputNodes) {
                    NSLog(@"%@", [inputNode getAttributeNamed:@"src"]);
                    linkForImage = [inputNode getAttributeNamed:@"src"];
                }
    NSString * imageURLString;
    //imgDic[@"imageLink"] = [inputNode getAttributeNamed:@"src"];
    if ([linkForImage isEqualToString:@"http://www.stolaf.edu/personal/images/nopic.jpg"]) {
        imageURLString = @"http://images.fineartamerica.com/images-medium-large/great-dane-dog-portrait-ethiriel-photography.jpg";
    }
    else{
     imageURLString = [[NSString alloc] initWithFormat:@"%@&fullsize=yes",linkForImage];
    }
    
    NSURL *imageURL = [[NSURL alloc] initWithString:imageURLString];
    NSImage * myImage = [[NSImage alloc] initWithContentsOfURL:imageURL];
    imgDic[@"dispImage"] = myImage;
                //NSLog(@"Dictionary: %@", imgDic);
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"kReceivingImage" object:self userInfo:imgDic];
}
@end