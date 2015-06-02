//
//  ServerCommunication.h
//  WikiMaster
//
//  Created by Kunal Wagle on 26/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ASIHTTPRequest.h"

@class UIViewController;

@interface ServerCommunication : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

//    ASIHTTPRequest *myRequest_;

//- (void)initNetworkCommunication;
//- (void)sendMessage:(NSString*)message;

+(void)addUser:(NSString*)userID;
+(NSDictionary*)getUser:(NSString*)facebookID;

@end
