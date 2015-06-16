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

-(void)addUser:(NSString*)userID;
-(void)getUser:(NSString*)facebookID;
-(void)getCategories;
-(void)getSubCategories:(NSString*)category;
-(void)getInfoboxes:(NSString*)category;
-(void)getNew1PlayerGame:(NSString *)infoboxName;
-(ServerCommunication*)initWithData;
-(void)post1PlayerGameResult:(int)score questionsCorrect:(int)correct questionsWrong:(int)wrong;
-(void)getHomeUser;
-(void)addFavourite:(NSString *)infoboxName;
-(void)getTopicStats:(NSString *)infoboxName;
-(void)getGames;

@property (nonatomic, strong) NSMutableData *responding;

@end
