//
//  FinalTotalsViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "FinalTotalsViewController.h"
#import "UtilityMethods.h"
#import "ServerCommunication.h"
#import "User.h"

@interface FinalTotalsViewController ()

@end

@implementation FinalTotalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)viewWillAppear:(BOOL)animated {
    if ((self.totalTime%60)<10) {
        self.time.text = [NSString stringWithFormat:@"%d:0%d", self.totalTime/60, self.totalTime%60];
    } else {
        self.time.text = [NSString stringWithFormat:@"%d:%d", self.totalTime/60, self.totalTime%60];
    }
    self.correctness.text = [NSString stringWithFormat:@"%d out of 6", self.correctAnswers];
    self.total.text = [NSString stringWithFormat:@"%d", self.runningScore];
    if (self.correctAnswers<=3) {
        self.thumbs.image = [UIImage imageNamed:@"dislike-157252_640.png"];
    }
    self.view.backgroundColor = [UtilityMethods getColour];
    ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
    [comms post1PlayerGameResult:self.runningScore questionsCorrect:self.correctAnswers questionsWrong:6-self.correctAnswers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUser:) name:@"Post1PlayerGame" object:nil];
}

-(void)updateUser:(NSNotification*)notification{
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@ in updateUser",name);
    NSLog(@"Information =%@",info);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
    NSString *userID = [user userID];
    ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
    [comms getHomeUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Post1PlayerGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotUser:) name:@"updateUser" object:nil];
}

-(void)gotUser:(NSNotification*)notification {
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@ in gotUser",name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *temp = [info valueForKey:@"response"];
    if ([temp isEqualToString:@"FAILED"]) {
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
//            if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                User *old_user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
                NSDictionary *result = object;
                NSDictionary *gamePlay = [result valueForKey:@"gameStats"];
                User *user = [[User alloc] initWithDictionary:gamePlay];
                user.name = [old_user name];
                user.userID = [old_user userID];
                user.imageURL = [old_user imageURL];
            user.favourites = [result objectForKey:@"favTopics"];
            user.recents = [result objectForKey:@"recentTopics"];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
      //      }
        }
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
