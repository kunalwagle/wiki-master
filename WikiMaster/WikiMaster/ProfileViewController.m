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
ServerCommunication *comms;

- (void)viewDidLoad {
    [super viewDidLoad];
    comms = [[ServerCommunication alloc] initWithData];
  //  self.tableView.hidden = YES;
   // self.serverLabel.text = @"Connecting to server...";
  //  self.serverLabel.hidden = NO;
    if ([self.sender isEqualToString:@"friend"]) {
        //self.profilePicture.image = self.image;
        //self.name.text = self.userName;
        NSData *imageData = [NSData dataWithContentsOfURL:self.user.imageURL];
        self.image = [UIImage imageWithData:imageData];
        self.profilePicture.image = self.image;
        self.name.text = [self.user name];
        self.profilePicture.layer.cornerRadius = 50;
        self.profilePicture.layer.masksToBounds = YES;
        self.profilePicture.layer.shouldRasterize = YES;
        self.profilePicture.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //[ServerCommunication getUser:self.userID];
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
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
        //[ServerCommunication getUser:[defaults valueForKey:@"userID"]];
         }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"User" object:nil];
    gamePlayKeys = @[@"score", @"gamesPlayed", @"wins", @"draws", @"losses", @"avgScore", @"totalQuestionsAnswered", @"totalQuestionsCorrect"];
    niceKeys = @[@"Score", @"Games Played", @"Games won", @"Games drawn", @"Games lost", @"Average Score", @"Questions Answered", @"Correct Answers"];
    [self.tableView reloadData];
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
            [comms getUser:self.userID];
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [comms getUser:[defaults valueForKey:@"userID"]];
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
    return 8;
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
    int stat;
    switch ([indexPath row]) {
        case 0:
            stat = [self.user score];
            break;
        case 1:
            stat = [self.user gamesPlayed];
            break;
        case 2:
            stat = [self.user wins];
            break;
        case 3:
            stat = [self.user draws];
            break;
        case 4:
            stat = [self.user losses];
            break;
        case 5:
            stat = [self.user avgScore];
            break;
        case 6:
            stat = [self.user totalQuestionsAnswered];
            break;
        case 7:
            stat = [self.user totalQuestionsCorrect];
            break;
        default:
            break;
    }
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
