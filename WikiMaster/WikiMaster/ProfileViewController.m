//
//  ProfileViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 02/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "ProfileViewController.h"
#import "UtilityMethods.h"
#import "ServerCommunication.h"
#import "ProfileStatTableViewCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

NSArray *gamePlayKeys;
NSArray *niceKeys;
NSDictionary *gamePlay;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.sender isEqualToString:@"friend"]) {
        self.profilePicture.image = self.image;
    } else {
        //Call Facebook for Profile Picture
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"User" object:nil];
    [ServerCommunication getUser:@"10204647525044281"];
    gamePlayKeys = @[@"score", @"gamesPlayed", @"wins", @"draws", @"losses", @"avgScore", @"totalQuestionsAnswered", @"totalQuestionsCorrect"];
    niceKeys = @[@"Score", @"Games Played", @"Games won", @"Games drawn", @"Games lost", @"Average Score", @"Questions Answered", @"Correct Answers"];
    // Do any additional setup after loading the view.
}

- (void)receivedNotification:(NSNotification*) notification {
    //name of the notification
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *temp = [info valueForKey:@"response"];
    id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *result = [object objectAtIndex:0];
        gamePlay = [result valueForKey:@"gameStats"];
    } else {
        NSLog(@"ERROR");
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gamePlay count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[ProfileStatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UtilityMethods getColour];
    cell.contentView.backgroundColor = [UtilityMethods getColour];
    cell.keyLabel.text = [niceKeys objectAtIndex:[indexPath row]];
    NSString *label = [gamePlayKeys objectAtIndex:[indexPath row]];
    int stat = [[gamePlay objectForKey:label] intValue];
    cell.statLabel.text = [NSString stringWithFormat:@"%d", stat];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
    self.tableView.backgroundColor = [UtilityMethods getColour];
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
