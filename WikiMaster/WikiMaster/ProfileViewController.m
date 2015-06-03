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
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

NSArray *gamePlayKeys;
NSArray *niceKeys;
NSDictionary *gamePlay;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.serverLabel.text = @"Connecting to server...";
    self.serverLabel.hidden = NO;
    if ([self.sender isEqualToString:@"friend"]) {
        self.profilePicture.image = self.image;
        self.name.text = self.userName;
        self.profilePicture.layer.cornerRadius = 50;
        self.profilePicture.layer.masksToBounds = YES;
        self.profilePicture.layer.shouldRasterize = YES;
        self.profilePicture.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [ServerCommunication getUser:self.userID];
    } else {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{@"fields":@"picture.type(large), name,id"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error) {
                NSDictionary *dict = result;
                self.name.text = [dict objectForKey:@"name"];
                self.userID = [dict objectForKey:@"id"];
                //self.friends = [result objectForKey:@"data"];
                //NSLog(result);
                    NSDictionary *pictureData = [dict objectForKey:@"picture"];
                    NSString *pictureURL = [NSString stringWithFormat:@"%@",[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
                    UIImage *img = [UIImage imageWithData:imageData];
                self.profilePicture.image = img;
                self.profilePicture.layer.cornerRadius = 50;
                self.profilePicture.layer.masksToBounds = YES;
                self.profilePicture.layer.shouldRasterize = YES;
                self.profilePicture.layer.rasterizationScale = [UIScreen mainScreen].scale;

            } else {
                self.name.text = @"You";
                self.profilePicture.hidden = YES;
            }
        }];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [ServerCommunication getUser:[defaults valueForKey:@"userID"]];
         }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"User" object:nil];
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
    if ([temp isEqualToString:@"FAILED"]) {
        self.tableView.hidden = YES;
        self.serverLabel.text = @"Could not connect to server. Sorry about that";
        self.serverLabel.hidden = NO;
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = [object objectAtIndex:0];
                gamePlay = [result valueForKey:@"gameStats"];
                [self.tableView setHidden:NO];
                [self.serverLabel setHidden:YES];
                [self.serverLabel setText:@"Connecting to Server..."];
            } else {
                self.tableView.hidden = YES;
                self.serverLabel.text = @"Could not connect to server. Sorry about that";
                self.serverLabel.hidden = NO;
            } } else {
                self.tableView.hidden = YES;
                self.serverLabel.text = @"Could not connect to server. Sorry about that";
                self.serverLabel.hidden = NO;
            }
        [self.tableView reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
    self.tableView.backgroundColor = [UtilityMethods getColour];
    
    if ([self.serverLabel.text isEqualToString:@"Could not connect to server. Sorry about that"]) {
        
        self.tableView.hidden = YES;
        self.serverLabel.text = @"Connecting to server...";
        self.serverLabel.hidden = NO;
        if ([self.sender isEqualToString:@"friend"]) {
            [ServerCommunication getUser:self.userID];
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [ServerCommunication getUser:[defaults valueForKey:@"userID"]];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedNotification:)
                                                     name:@"User" object:nil];
    }
    [self.tableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
