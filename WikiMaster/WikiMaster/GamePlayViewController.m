//
//  GamePlayViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "GamePlayViewController.h"
#import "Question.h"
#import "AnswerDebriefViewController.h"
#import "UtilityMethods.h"

@interface GamePlayViewController ()

@end

@implementation GamePlayViewController



Question *currentQuestion;
int timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    currentQuestion = [self.questions objectAtIndex:0];
    [self.questions removeObjectAtIndex:0];
    self.questionNumber.text = [NSString stringWithFormat:@"%d", self.question];
    timer = [UtilityMethods getTimer];
    if ((timer%60)<10) {
        self.timer.text = [NSString stringWithFormat:@"%d:0%d", timer/60, timer%60];
    } else {
        self.timer.text = [NSString stringWithFormat:@"%d:%d", timer/60, timer%60];
    }
    NSMutableArray *answers = [currentQuestion getAnswers];
    // Call a method that truncates the string I want to use
    [self.button1 setTitle:[self truncateString:[answers objectAtIndex:0]] forState:UIControlStateNormal];
    [self.button2 setTitle:[self truncateString:[answers objectAtIndex:1]] forState:UIControlStateNormal];
    [self.button3 setTitle:[self truncateString:[answers objectAtIndex:2]] forState:UIControlStateNormal];
    [self.button4 setTitle:[self truncateString:[answers objectAtIndex:3]] forState:UIControlStateNormal];
    [self.button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    [self.button2 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    [self.button3 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    [self.button4 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
//    [self.button1 setTitle:[answers objectAtIndex:0] forState:UIControlStateNormal];
//    [self.button2 setTitle:[answers objectAtIndex:1] forState:UIControlStateNormal];
//    [self.button3 setTitle:[answers objectAtIndex:2] forState:UIControlStateNormal];
//    [self.button4 setTitle:[answers objectAtIndex:3] forState:UIControlStateNormal];
    
    self.questionTitle.text = currentQuestion.getQuestionTitle;
    self.image.hidden = YES;
    self.quickFact.hidden = YES;
    self.paragraph.hidden = YES;
    int qid = currentQuestion.getQuestionID;
    switch (qid) {
        case 0:
            self.image.image = currentQuestion.getQuestionImage;
            self.image.hidden = NO;
            break;
        case 1:
            self.quickFact.text = currentQuestion.getQuestionString;
            self.quickFact.hidden = NO;
            break;
        case 2:
            self.paragraph.text = currentQuestion.getQuestionString;
            [self.paragraph setTextColor:[UIColor whiteColor]];
            self.paragraph.hidden = NO;
            break;
        default:
            break;
    }
    self.view.backgroundColor = [UtilityMethods getColour];
}

- (NSString *)truncateString:(NSString *)stringToTruncate
{
    if ([stringToTruncate length] > 50)
        stringToTruncate = [[stringToTruncate substringToIndex:50] stringByAppendingString:@"..."];
    
    return  stringToTruncate;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(reduceTimer) withObject:nil afterDelay:1.0];
}

- (void)reduceTimer {
    if (timer == 0) {
       // [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSegueWithIdentifier:@"Next" sender:self];
    } else {
    timer--;
    if ((timer%60)<10) {
        self.timer.text = [NSString stringWithFormat:@"%d:0%d", timer/60, timer%60];
    } else {
        self.timer.text = [NSString stringWithFormat:@"%d:%d", timer/60, timer%60];
    }
    [self performSelector:@selector(reduceTimer) withObject:nil afterDelay:1.0];
    NSLog(self.timer.text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AnswerDebriefViewController *vc = (AnswerDebriefViewController*)[segue destinationViewController];
    vc.question = currentQuestion;
    vc.questions = self.questions;
    vc.time = timer;
    vc.runningScore = self.runningScore;
    vc.totalTime = self.totalTime;
    vc.outOfTime = NO;
    vc.correctAnswers = self.correctAnswers;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([[segue identifier] isEqualToString:@"Next"]) {
        vc.outOfTime = YES;
    } else if ([[segue identifier] isEqualToString:@"Choice1"]) {
        vc.guess = [self.button1 currentTitle];
    } else if ([[segue identifier] isEqualToString:@"Choice2"]) {
        vc.guess = [self.button2 currentTitle];
    } else if ([[segue identifier] isEqualToString:@"Choice3"]) {
        vc.guess = [self.button3 currentTitle];
    } else if ([[segue identifier] isEqualToString:@"Choice4"]) {
        vc.guess = [self.button4 currentTitle];
    }
}


@end
