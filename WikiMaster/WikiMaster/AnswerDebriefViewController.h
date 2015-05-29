//
//  AnswerDebriefViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface AnswerDebriefViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *tick;
@property (weak, nonatomic) IBOutlet UILabel *answer;
@property (weak, nonatomic) IBOutlet UILabel *timeTaken;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswerBonus;
@property (weak, nonatomic) IBOutlet UILabel *totalPoints;
@property NSMutableArray *questions;
@property Question *question;
@property int time;
@property BOOL outOfTime;
@property NSString *guess;
- (IBAction)next:(id)sender;
@property int totalTime;
@property int runningScore;
@property int correctAnswers;


@end
