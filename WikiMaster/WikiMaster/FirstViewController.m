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
#import "TopicHomeViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

NSArray *favourites;
NSArray *recent;
NSArray *trending;
NSString *topicSelected;
NSArray *fimages;
NSArray *rimages;
NSArray *timages;


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
    [self performSegueWithIdentifier:@"showTopic" sender:self];
}

-(void)receivedNotification:(NSNotification*)notification {
    if (self.loadedUser) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Home" object:nil];
    } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *facebookID = [defaults valueForKey:@"userID"];
    [ServerCommunication getUser:facebookID];
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
            self.name.text = [dict objectForKey:@"name"];
            //self.friends = [result objectForKey:@"data"];
            //NSLog(result);
            NSDictionary *pictureData = [dict objectForKey:@"picture"];
            NSString *pictureURL = [NSString stringWithFormat:@"%@",[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
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
    if ([temp isEqualToString:@"FAILED"]) {
        self.loadedUser = NO;
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = [object objectAtIndex:0];
                NSDictionary *gamePlay = [result valueForKey:@"gameStats"];
                self.played.text = [NSString stringWithFormat:@"%@", [gamePlay valueForKey:@"gamesPlayed"]];
                self.won.text = [NSString stringWithFormat:@"%@", [gamePlay valueForKey:@"wins"]];
                self.lost.text = [NSString stringWithFormat:@"%@", [gamePlay valueForKey:@"losses"]];
                self.loadedUser = YES;
            } else {
                //ERROR HANDLING
            } } else {
                //ERROR HANDLING
            }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
    self.tableView.backgroundColor = [UtilityMethods getColour];
    [self.settings setTintColor:[UtilityMethods getColour]];
    [self.profile setTintColor:[UtilityMethods getColour]];
    [self.tabBarController.tabBar setTintColor:[UtilityMethods getColour]];
    [self.tableView reloadData];
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
    if (cell==nil) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.section) {
        case 0:
            cell.testData = favourites;
            cell.images = fimages;
            break;
            
        case 1:
            cell.testData = recent;
            cell.images = rimages;
            break;
            
        default:
            cell.testData = trending;
            cell.images = timages;
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
        vc.topicName = topicSelected;
        vc.topicImage = [UIImage imageNamed:@"hand-157251_640.png"];
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
