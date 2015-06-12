//
//  User.m
//  WikiMaster
//
//  Created by Kunal Wagle on 12/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "User.h"

@implementation User

-(User*)initWithDictionary:(NSDictionary *)dict {
    self.score = [[dict objectForKey:@"score"] intValue];
    self.gamesPlayed = [[dict objectForKey:@"gamesPlayed"] intValue];
    self.wins = [[dict objectForKey:@"wins"] intValue];
    self.draws = [[dict objectForKey:@"draws"] intValue];
    self.losses = [[dict objectForKey:@"losses"] intValue];
    self.avgScore = [[dict objectForKey:@"avgScore"] intValue];
    self.totalQuestionsAnswered = [[dict objectForKey:@"totalQuestionsAnswered"] intValue];
    self.totalQuestionsCorrect = [[dict objectForKey:@"totalQuestionsCorrect"] intValue];
    return self;
}

@end
