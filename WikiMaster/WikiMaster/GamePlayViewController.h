//
//  GamePlayViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamePlayViewController : UIViewController

@property NSMutableArray *questions;
@property int question;
@property int runningScore;
@property int totalTime;
@property int correctAnswers;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *questionNumber;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (weak, nonatomic) IBOutlet UILabel *questionTitle;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UILabel *quickFact;
@property (weak, nonatomic) IBOutlet UITextView *paragraph;

@end
