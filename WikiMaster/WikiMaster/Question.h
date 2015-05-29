//
//  Question.h
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Question : NSObject

-(NSString*)getQuestionTitle;
-(NSString*)getQuestionString;
-(UIImage*)getQuestionImage;
-(int)getQuestionID;
-(NSMutableArray*)getAnswers;
-(BOOL)isCorrect:(NSString*)guess;
-(NSString*)getCorrect;

-(void)setQuestionID:(int)qid;
-(void)setQuestionImage:(NSString*)link;
-(void)setQuestionString:(NSString*)questionString;
-(void)setCorrectAnswer:(NSString*)correct;
-(void)addIncorrect:(NSString*)incorrect;


@end
