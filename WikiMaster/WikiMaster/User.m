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
    self = [super init];
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

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.imageURL forKey:@"imageURL"];
    [coder encodeInt:self.score forKey:@"score"];
    [coder encodeInt:self.gamesPlayed forKey:@"gamesPlayed"];
    [coder encodeInt:self.wins forKey:@"wins"];
    [coder encodeInt:self.draws forKey:@"draws"];
    [coder encodeInt:self.losses forKey:@"losses"];
    [coder encodeInt:self.avgScore forKey:@"avgScore"];
    [coder encodeInt:self.totalQuestionsAnswered forKey:@"totalQuestionAnswered"];
    [coder encodeInt:self.totalQuestionsCorrect forKey:@"totalQuestionsCorrect"];
    [coder encodeInt:self.position forKey:@"position"];
    [coder encodeInt:self.imageKey forKey:@"imageKey"];
    [coder encodeObject:self.favourites forKey:@"favourites"];
    [coder encodeObject:self.recents forKey:@"recents"];
}

-(id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    self.userID = [coder decodeObjectForKey:@"userID"];
    self.name = [coder decodeObjectForKey:@"name"];
    self.imageURL = [coder decodeObjectForKey:@"imageURL"];
    self.score = [coder decodeIntForKey:@"score"];
    self.gamesPlayed = [coder decodeIntForKey:@"gamesPlayed"];
    self.wins = [coder decodeIntForKey:@"wins"];
    self.draws = [coder decodeIntForKey:@"draws"];
    self.losses = [coder decodeIntForKey:@"losses"];
    self.avgScore = [coder decodeIntForKey:@"avgScore"];
    self.totalQuestionsAnswered = [coder decodeIntForKey:@"totalQuestionsAnswered"];
    self.totalQuestionsCorrect = [coder decodeIntForKey:@"totalQuestionsCorrect"];
    self.imageKey = [coder decodeIntForKey:@"imageKey"];
    self.position = [coder decodeIntForKey:@"position"];
    self.favourites = [coder decodeObjectForKey:@"favourites"];
    self.recents = [coder decodeObjectForKey:@"recents"];
    return self;
}

@end
