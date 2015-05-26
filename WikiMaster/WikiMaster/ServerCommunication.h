//
//  ServerCommunication.h
//  WikiMaster
//
//  Created by Kunal Wagle on 26/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@interface ServerCommunication : NSObject <NSStreamDelegate>

+ (void)initNetworkCommunication: (UIViewController*) del;
+ (void)sendMessage:(NSString*)message;

@end
