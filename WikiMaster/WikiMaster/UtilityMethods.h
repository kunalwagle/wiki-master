//
//  UtilityMethods.h
//  WikiMaster
//
//  Created by Kunal Wagle on 29/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityMethods : NSObject

+(UIColor*)getColour;
+(void)initColours;
+(int)getTimer;
+(NSMutableArray*)getFriends;
+(void)setFriends:(NSMutableArray*)friends;

@end
