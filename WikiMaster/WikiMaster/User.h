//
//  User.h
//  WikiMaster
//
//  Created by Kunal Wagle on 12/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

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

-(User*)initWithDictionary:(NSDictionary*)dict;

@end
