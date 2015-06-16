//
//  FirstViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 20/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "FirstViewController.h"
#import "UtilityMethods.h"
#import "ServerCommunication.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "TopicTableViewCell.h"
#import "User.h"
#import "TopicHomeViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

NSArray *favourites;
NSArray *recent;
NSArray *trending;
NSString *topicSelected;
UIImage *imageSelected;
NSArray *fimages;
NSArray *rimages;
NSArray *timages;
NSString *username;
NSString *pictureURL;
NSString *userID;

UIAlertView *alert;
UIAlertView *errorAlert;
ServerCommunication *comms;


- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"LoggedIn" object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults valueForKey:@"LoggedIn"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"InitialLoginViewController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedIn" object:nil userInfo:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clickedTopic:(NSNotification*)notification {
    NSDictionary *dict = notification.userInfo;
    topicSelected = [dict objectForKey:@"name"];
    imageSelected = [dict objectForKey:@"image"];
    [self performSegueWithIdentifier:@"showTopic" sender:self];
}

-(void)receivedNotification:(NSNotification*)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"user"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Home" object:nil];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
        NSData *imageData = [NSData dataWithContentsOfURL:[user imageURL]];
        UIImage *img = [UIImage imageWithData:imageData];
        self.image.image = img;
        self.image.layer.cornerRadius = 50;
        self.image.layer.masksToBounds = YES;
        self.image.layer.shouldRasterize = YES;
        self.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.played.text = [NSString stringWithFormat:@"%d", [user gamesPlayed]];
        self.won.text = [NSString stringWithFormat:@"%d", [user wins]];
        self.lost.text = [NSString stringWithFormat:@"%d", [user losses]];
    } else {
    alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment."
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [alert show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *facebookID = [defaults valueForKey:@"userID"];
    comms = [[ServerCommunication alloc] initWithData];
    [comms getHomeUser];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedUser:)
                                                 name:@"User" object:nil];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{@"fields":@"picture.type(large), name,id"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSDictionary *dict = result;
            username = [dict objectForKey:@"name"];
            userID = [dict objectForKey:@"id"];
            self.name.text = [dict objectForKey:@"name"];
            //self.friends = [result objectForKey:@"data"];
            //NSLog(result);
            NSDictionary *pictureData = [dict objectForKey:@"picture"];
            pictureURL = [NSString stringWithFormat:@"%@",[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
            if ([defaults objectForKey:@"user"]) {
                User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
                user.name = [dict objectForKey:@"name"];
                user.imageURL = [NSURL URLWithString:pictureURL];
                user.userID = [dict objectForKey:@"id"];
                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
            }
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
            UIImage *img = [UIImage imageWithData:imageData];
            self.image.image = img;
            self.image.layer.cornerRadius = 50;
            self.image.layer.masksToBounds = YES;
            self.image.layer.shouldRasterize = YES;
            self.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
        } else {
            self.name.text = @"You";
            self.image.hidden = YES;
        }
    }];
    }
}

-(void)receivedUser:(NSNotification*)notification {
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Home" object:nil];
    NSString *temp = [info valueForKey:@"response"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    if ([temp isEqualToString:@"FAILED"]) {
        self.loadedUser = NO;
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
   //         if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *result = object;
                NSDictionary *gamePlay = [result valueForKey:@"gameStats"];
                User *user = [[User alloc] initWithDictionary:gamePlay];
                user.name = username;
                user.userID = userID;
                user.favourites = [result objectForKey:@"favTopics"];
                user.recents = [result objectForKey:@"recentTopics"];
                if (pictureURL) {
                    user.imageURL = [NSURL URLWithString:pictureURL];
                }
                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
                self.played.text = [NSString stringWithFormat:@"%@", [gamePlay valueForKey:@"gamesPlayed"]];
                self.won.text = [NSString stringWithFormat:@"%@", [gamePlay valueForKey:@"wins"]];
                self.lost.text = [NSString stringWithFormat:@"%@", [gamePlay valueForKey:@"losses"]];
                self.loadedUser = YES;
            
        //    } else {
                //ERROR HANDLING
         //       self.loadedUser = NO;
             } else {
                //ERROR HANDLING
                self.loadedUser = NO;
            }
    }
    if (!self.loadedUser) {
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles: nil];
        [errorAlert show];
    }
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == errorAlert) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *facebookID = [defaults valueForKey:@"userID"];
        [comms getUser:facebookID];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedUser:)
                                                     name:@"User" object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
    self.tableView.backgroundColor = [UtilityMethods getColour];
    [self.settings setTintColor:[UtilityMethods getColour]];
    [self.profile setTintColor:[UtilityMethods getColour]];
    [self.tabBarController.tabBar setTintColor:[UtilityMethods getColour]];
    [self.tableView reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
    if (user) {
        self.played.text = [NSString stringWithFormat:@"%d", [user gamesPlayed]];
        self.won.text = [NSString stringWithFormat:@"%d", [user wins]];
        self.lost.text = [NSString stringWithFormat:@"%d", [user losses]];
        self.name.text = [user name];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Home" object:nil];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UINib *nib = [UINib nibWithNibName:@"TopicTableViewCell" bundle:nil];
//    [[self tableView] registerNib:nib forCellReuseIdentifier:@"cell"];
    
    favourites = @[@"Cricketer", @"UK Place", @"Football Clubs"];
    trending = @[@"Starcraft Character", @"Avatar: The Last Airbender Character", @"Royalty", @"Military Conflict"];
    recent = @[@"Artist", @"Music Genre"];
    fimages = @[[UIImage imageNamed:@"5.jpg"],[UIImage imageNamed:@"7.jpg"],[UIImage imageNamed:@"8.jpg"]];
    timages = @[[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"6.jpg"],[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"]];
    rimages = @[[UIImage imageNamed:@"3.jpg"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Home" object:nil];
   // [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
    if (cell==nil) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.section) {
        case 0:
            cell.testData = [user favourites];
            //cell.images = fimages;
            break;
            
        case 1:
            cell.testData = [user recents];
            //cell.images = rimages;
            break;
            
        default:
            cell.testData = [user recents];
            //cell.images = timages;
            break;
    }
   // [cell setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [cell updateCell];
    cell.backgroundColor = [UtilityMethods getColour];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0]];
    switch (section) {
        case 0:
            return @"Your favourites";
            
        case 1:
            return @"Your recent topics";
        
        default:
            return @"Trending right now";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showTopic"]) {
        TopicHomeViewController *vc = [segue destinationViewController];
        vc.hidesBottomBarWhenPushed = YES;
        //vc.topicName = topicSelected;
        vc.topicName = topicSelected;
        vc.topicImage = imageSelected;
    }
    UIViewController *vc = [segue destinationViewController];
    vc.hidesBottomBarWhenPushed = YES;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
