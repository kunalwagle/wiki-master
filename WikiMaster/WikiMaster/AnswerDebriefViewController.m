//
//  AnswerDebriefViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "AnswerDebriefViewController.h"
#import "GamePlayViewController.h"
#import "FinalTotalsViewController.h"
#import "UtilityMethods.h"

@interface AnswerDebriefViewController ()

@end

@implementation AnswerDebriefViewController

#define MAX(a,b) ( ((a) > (b)) ? (a) : (b) )

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.answer.text = [self truncateString:[self.question getCorrect]];
    int timer = [UtilityMethods getTimer];
    if (((timer-self.time)%60)<10) {
        self.timeTaken.text = [NSString stringWithFormat:@"%d:0%d", (timer - self.time)/60, (timer-self.time)%60];
    } else {
        self.timeTaken.text = [NSString stringWithFormat:@"%d:%d", (timer - self.time)/60, (timer-self.time)%60];
    }
    BOOL correctness = [self.question isCorrect:self.guess];
    if (correctness) {
        self.correctAnswerBonus.text = @"50";
        self.correctAnswers++;
    } else {
        self.correctAnswerBonus.text = @"0";
    }
    int finalTime = MAX(0, (self.time+30)-timer);
    if (correctness) {
        self.tick.image = [UIImage imageNamed:@"Tick.png"];
        self.totalPoints.text = [NSString stringWithFormat:@"%d", [self.correctAnswerBonus.text intValue] + finalTime];
    } else {
        self.tick.image = [UIImage imageNamed:@"Cross.png"];
        self.totalPoints.text = @"0";
        if (self.outOfTime) {
            self.tick.image = [UIImage imageNamed:@"exclamation.png"];
        }
    }
    self.view.backgroundColor = [UtilityMethods getColour];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)truncateString:(NSString *)stringToTruncate
{
    if ([stringToTruncate length] > 85)
        stringToTruncate = [[stringToTruncate substringToIndex:85] stringByAppendingString:@"..."];
    
    return  stringToTruncate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)next:(id)sender {
    if ([self.questions count]>0) {
        [self performSegueWithIdentifier:@"back" sender:self];
    } else {
        [self performSegueWithIdentifier:@"finish" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int timer = [UtilityMethods getTimer];
    if ([[segue identifier] isEqualToString:@"back"]) {
        GamePlayViewController* vc = (GamePlayViewController*)[segue destinationViewController];
        vc.questions = self.questions;
        vc.question = 7-[self.questions count];
        vc.runningScore = self.runningScore + [self.totalPoints.text intValue];
        vc.totalTime = self.totalTime + (timer-self.time);
        vc.correctAnswers = self.correctAnswers;
    } else {
        FinalTotalsViewController* vc = (FinalTotalsViewController*)[segue destinationViewController];
        vc.runningScore = self.runningScore + [self.totalPoints.text intValue];
        vc.totalTime = self.totalTime + (timer-self.time);
        vc.correctAnswers = self.correctAnswers;
    }
}


@end
