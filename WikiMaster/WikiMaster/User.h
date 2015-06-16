//
//  User.h
//  WikiMaster
//
//  Created by Kunal Wagle on 12/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property NSString *userID;
@property NSString *name;
@property int score;
@property int gamesPlayed;
@property int wins;
@property int draws;
@property int losses;
@property int avgScore;
@property int totalQuestionsAnswered;
@property int totalQuestionsCorrect;
@property NSURL *imageURL;
@property int imageKey;
@property int position;
@property NSArray *recents;
@property NSArray *favourites;

-(User*)initWithDictionary:(NSDictionary*)dict;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
