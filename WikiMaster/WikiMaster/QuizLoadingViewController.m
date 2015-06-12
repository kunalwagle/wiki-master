//
//  QuizLoadingViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 26/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "QuizLoadingViewController.h"
#import "Question.h"
#import "GamePlayViewController.h"
#import "UtilityMethods.h"

@interface QuizLoadingViewController ()

@end

@implementation QuizLoadingViewController

@synthesize welcomeMessage;
@synthesize quizName;
@synthesize activity;
@synthesize connectingMessage;
@synthesize countdown;

NSMutableArray *questions;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(gotQuiz) withObject:nil afterDelay:1.0 ];
    // Do any additional setup after loading the view.
}

-(void)gotQuiz {
    connectingMessage.text = @"Generating Questions";
    welcomeMessage.hidden = NO;
    quizName.hidden = NO;
    [self createQuestions];
    [self performSelector:@selector(initiateCountdown) withObject:nil afterDelay:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)createQuestions {
    questions = [[NSMutableArray alloc] initWithCapacity:6];
    Question *q = [Question alloc];
    [q setQuestionID:2];
    [q setQuestionString:@"Decisions by Republican incumbent Peter Fitzgerald and his Democratic predecessor Carol Moseley Braun to not participate in the election resulted in wide-open Democratic and Republican primary contests involving fifteen candidates.[67] In the March 2004 primary election, Obama won in an unexpected landslide—which overnight made him a rising star within the national Democratic Party, started speculation about a presidential future, and led to the reissue of his memoir, Dreams from My Father.[68] In July 2004, Obama delivered the keynote address at the 2004 Democratic National Convention,[69] seen by 9.1 million viewers. His speech was well received and elevated his status within the Democratic Party."];
    NSString *answer = @"Barack Obama";
    [q setCorrectAnswer:answer];
    [q addIncorrect:@"Carol Moseley Braun"];
    [q addIncorrect:@"Peter Fitzgerald (politicians)"];
    [q addIncorrect:@"Democratic Party (United States)"];
    [questions addObject:q];
    
    q = [Question alloc];
    [q setQuestionID:0];
    [q setQuestionImage:@"http://upload.wikimedia.org/wikipedia/en/3/33/Ann_Dunham_with_father_and_children.jpg"];
    [q setCorrectAnswer:@"Obama with his half-sister Maya Soetoro-Ng, mother Ann Dunham and grandfather Stanley Dunham, in Honolulu, Hawaii"];
    [q addIncorrect:@"Obama and others celebrate the naming of a street in Chicago after ShoreBank co-founder Milton Davis in 1998"];
    [q addIncorrect:@"County results of the 2004 U.S. Senate race in Illinois. Obama won the counties in blue."];
    [q addIncorrect:@"Obama in his official portrait as a member of the United States Senate"];
    [questions addObject:q];
    
    q = [Question alloc];
    [q setQuestionID:1];
    [q setQuestionString:@"44th President of the USA: Assumed Office"];
    [q setCorrectAnswer:@"January 20, 2009"];
    [q addIncorrect:@"December 25, 2008"];
    [q addIncorrect:@"February 19, 2009"];
    [q addIncorrect:@"May 26, 2009"];
    [questions addObject:q];
    
    q = [Question alloc];
    [q setQuestionID:1];
    [q setQuestionString:@"Senator for the State of Illinois: Preceded by"];
    [q setCorrectAnswer:@"Peter Fitzgerald (politician)"];
    [q addIncorrect:@"Carol Moseley Braun"];
    [q addIncorrect:@"Barack Obama"];
    [q addIncorrect:@"Democratic Party (United States)"];
    [questions addObject:q];
    
    q = [Question alloc];
    [q setQuestionID:1];
    [q setQuestionString:@"Political Party"];
    [q setCorrectAnswer:@"Democratic"];
    [q addIncorrect:@"Republican"];
    [q addIncorrect:@"Conservative"];
    [q addIncorrect:@"Labour"];
    [questions addObject:q];
    
    q = [Question alloc];
    [q setQuestionID:1];
    [q setQuestionString:@"Residence"];
    [q setCorrectAnswer:@"1600 Pennysylvania Avenue"];
    [q addIncorrect:@"32 California Avenue"];
    [q addIncorrect:@"1 Iowa Lane"];
    [q addIncorrect:@"10 Maine Road"];
    [questions addObject:q];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)initiateCountdown {
    if (countdown.hidden) {
        countdown.hidden = NO;
        countdown.text = @"3";
        [self performSelector:@selector(initiateCountdown) withObject:nil afterDelay:1.0];
    } else if ([countdown.text isEqualToString:@"3"]) {
        countdown.text = @"2";
        [self performSelector:@selector(initiateCountdown) withObject:nil afterDelay:1.0];
    } else if ([countdown.text isEqualToString:@"2"]) {
        countdown.text = @"1";
        [self performSelector:@selector(initiateCountdown) withObject:nil afterDelay:1.0];
    } else if ([countdown.text isEqualToString:@"1"]) {
        countdown.text = @"GO!";
        [self performSelector:@selector(initiateCountdown) withObject:nil afterDelay:1.0];
    } else if ([countdown.text isEqualToString:@"GO!"]) {
        [self performSelector:@selector(performSegue) withObject:nil afterDelay:1.0];
    }
}

-(void)performSegue {
    [self performSegueWithIdentifier:@"startQuiz" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"startQuiz"]) {
        GamePlayViewController *vc = (GamePlayViewController*)segue.destinationViewController;
        vc.questions = questions;
        vc.question = 1;
        vc.totalTime = 0;
        vc.runningScore = 0;
        vc.correctAnswers = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
