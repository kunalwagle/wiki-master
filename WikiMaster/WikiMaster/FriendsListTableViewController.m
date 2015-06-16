//
//  FriendsListTableViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 30/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "FriendsListTableViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FriendTableViewCell.h"
#import "UtilityMethods.h"
#import "InviteTableViewCell.h"
#import "ProfileViewController.h"
#import "ServerCommunication.h"
#import "LeaderboardTableViewCell.h"

@interface FriendsListTableViewController ()

@property NSMutableArray *friends;
@property NSMutableArray *tempFriends;
@property NSArray *searchFriends;
@property NSMutableArray *images;
@property BOOL search;

@end

@implementation FriendsListTableViewController

UIAlertView *alert;
UIAlertView *errorAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.friendsScreen) {
        self.counter = 0;
        self.navigationItem.title = @"Leaderboard";
    }
    if (![UtilityMethods getFriends] || self.reloading) {
        alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment."
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [alert show];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        User *u = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
    self.friends = [[NSMutableArray alloc] initWithObjects: u, nil];
        self.me = u;
        NSData *imageData = [NSData dataWithContentsOfURL:[u imageURL]];
        self.images = [[NSMutableArray alloc] initWithObjects: nil];
        [self.images addObject:[UIImage imageWithData:imageData]];
        self.tempFriends = [[NSMutableArray alloc] initWithObjects: nil];
    self.loadedFriends = YES;
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:@{@"fields":@"picture.type(large), name"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSArray *temp = [result objectForKey:@"data"];
            self.target = [temp count];
        //self.friends = [result objectForKey:@"data"];
        //NSLog(result);
        for (NSDictionary* dict in temp) {
            for (id key in dict) {
                NSLog(@"key: %@, value: %@ \n", key, [dict objectForKey:key]);
            }
            NSDictionary *pictureData = [dict objectForKey:@"picture"];
            NSString *pictureURL = [NSString stringWithFormat:@"%@",[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
            UIImage *image = [UIImage imageWithData:imageData];
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [dictionary setValue:[NSNumber numberWithInt:[self.images count]] forKey:@"imageNumber"];
            //if (!self.friendsScreen) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedUser:) name:[dictionary objectForKey:@"id"] object:nil];
            NSLog(@"Set up Notification");
                ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
                [comms getUser:[dictionary objectForKey:@"id"]];
            [self performSelector:@selector(serverFailed) withObject:nil afterDelay:10.0];
            
            //}
            [self.images addObject:image];
            [self.tempFriends addObject:dictionary];
        }
//            if (self.friendsScreen) {
//                [self.tableView reloadData];
//            }
            
            self.loadedFriends = YES;
            
            
        } else {
            self.loadedFriends = NO;
            [self.tableView reloadData];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
            [errorAlert show];
        }
    }]; } else {
//        for (int i=0; i<[self.friends count]; i++) {
//            User *user = [self.friends objectAtIndex:i];
//            dispatch_queue_t imagesQueue = dispatch_queue_create("Images Queue",NULL);
//                NSURL *url = [user imageURL];
//                dispatch_async(imagesQueue, ^{
//                    NSData *imageData = [NSData dataWithContentsOfURL:url];
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    NSLog(@"Finished %d Image Download", i);
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // Update the UI
//                        [self.images addObject:image];
//                        User *usr = [self.friends objectAtIndex:i];
//                        usr.imageKey = i;
//                        if ([self.images count]==[self.friends count]) {
//                            [self.tableView reloadData];
//                        }
//                        NSLog(@"Set the image");
//                        
//                    });
//                    
//                });
//        }

    }
    
//    if  (!self.friendsScreen) {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *facebookID = [defaults valueForKey:@"userID"];
//    [ServerCommunication getUser:facebookID];
//    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"/me"
//                                  parameters:@{@"fields":@"picture.type(large), name,id"}
//                                  HTTPMethod:@"GET"];
//    [requestMe startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        if (!error) {
//            NSDictionary *dict = result;
//            //self.friends = [result objectForKey:@"data"];
//            //NSLog(result);
//            NSDictionary *pictureData = [dict objectForKey:@"picture"];
//            NSString *pictureURL = [NSString stringWithFormat:@"%@",[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
//            UIImage *img = [UIImage imageWithData:imageData];
//            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:dict];
//            [dictionary setValue:[NSNumber numberWithInt:[self.images count]] forKey:@"imageNumber"];
//            if (!self.friendsScreen) {
//                [ServerCommunication getUser:[dictionary objectForKey:@"id"]];
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedUser:) name:[dictionary objectForKey:@"id"] object:nil];
//            }
//            [self.images addObject:img];
//            [self.friends addObject:dictionary];
//
//        } else {
//
//        }
//    }]; }
    UINib *nib = [UINib nibWithNibName:@"InviteTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"invite"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"invite"];
    nib = [UINib nibWithNibName:@"LeaderboardMeCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"leaderboard"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"leaderboard"];
    nib = [UINib nibWithNibName:@"FriendTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"friend"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"friend"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UtilityMethods getColour];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UtilityMethods getColour];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!self.reloading) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UtilityMethods getColour];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self
                                action:@selector(refreshAll)
                      forControlEvents:UIControlEventValueChanged];
    }

    self.reloading = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    self.tableView.backgroundColor = [UtilityMethods getColour];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UtilityMethods getColour];
    if ([UtilityMethods getFriends]) {
        self.friends = [UtilityMethods getFriends];
        if (!self.friendsScreen) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.me = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
            [self.friends addObject:self.me];
            self.images = [[NSMutableArray alloc] initWithObjects: nil];
//            dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
//            dispatch_async(imagesQueue, ^{
//                for (int i=0; i<[self.friends count]; i++) {
//                    User *user = [self.friends objectAtIndex:i];
//                    NSURL *url = [user imageURL];
//                    NSData *imageData = [NSData dataWithContentsOfURL:url];
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // Update the UI
//                        [self.images addObject:image];
//                        //User *usr = [self.friends objectAtIndex:i];
//                        user.imageKey = [self.images count]-1;
//                        if ([self.images count]==[self.friends count]) {
//                            [self.tableView reloadData];
//                        }
//                        NSLog(@"Set the image %d", [self.images count]);
//                        
//                    });
//                }
//            });
        }
        self.loadedFriends = YES;
    }

    [self.tableView reloadData];
    if (!self.loadedFriends) {
        [self viewDidLoad];
    } else {
        [self sort];
    }
}

- (void)refreshAll {
    //    LoadingViewController *loadingViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loadingPage"];
    //    loadingViewController.loaded = YES;
    //    loadingViewController.vc = self;
    //    //[self addChildViewController:loadingViewController];
    //    [self presentViewController:loadingViewController animated:YES completion:nil];
    if (self.refreshControl) {
        NSString *title = @"Refreshing";
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
    self.reloading = YES;
    [self viewDidLoad];
    self.images = [[NSMutableArray alloc] initWithObjects: nil];
    dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
    dispatch_async(imagesQueue, ^{
        for (int i=0; i<[self.friends count]; i++) {

        }
    });
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
   // if ([UtilityMethods testInternetConnection]) {
//        FLXAppDelegate *appDel = (FLXAppDelegate*)[[UIApplication sharedApplication] delegate];
//        NSString *section = [appDel section];
//        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
//        dispatch_async(imageQueue, ^{
//            [UtilityMethods loadArticles:section];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Update the UI
//                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
//            });
//            
//        });
    
  //  } //else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You don't seem to be connected to the internet. Please connect to the internet and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert setTag:100];
//        [alert show];
//    }
}

-(void)serverFailed {
    if ([alert isVisible]) {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
        [errorAlert show];
    }
    
    
}

-(void)receivedUser:(NSNotification*)notification {
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    NSString *temp = [info valueForKey:@"response"];
    if ([temp isEqualToString:@"FAILED"]) {
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
        [errorAlert show];
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = object;
                NSDictionary *gamePlay = [result valueForKey:@"gameStats"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", notification.name];
                NSArray *filteredArray = [self.tempFriends filteredArrayUsingPredicate:predicate];
                User *user = [[User alloc] initWithDictionary:gamePlay];
                NSMutableDictionary *firstFoundObject = nil;
                firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
                user.name = [firstFoundObject objectForKey:@"name"];
                user.userID = [firstFoundObject objectForKey:@"id"];
                NSDictionary *pictureData = [firstFoundObject objectForKey:@"picture"];
                user.imageURL = [NSURL URLWithString:[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
                user.imageKey = [[firstFoundObject objectForKey:@"imageNumber"] intValue];
                [self.friends addObject:user];
                //int score = [[gamePlay objectForKey:@"score"] intValue];
                //[firstFoundObject setObject:[gamePlay objectForKey:@"score"] forKey:@"score"];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
                self.counter++;
                if ((self.counter == self.target) && self.target!=0) {
                    [self sort];
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    if ([self.refreshControl isRefreshing]) {
                        [self.refreshControl endRefreshing];
                    }
                    [self.tableView reloadData];
                }
            } else {
                //ERROR HANDLING
                errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
                [errorAlert show];
            } } else {
                //ERROR HANDLING
                errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
                [errorAlert show];
            }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
    if (alertView == errorAlert) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.reloading = YES;
        [self viewDidLoad];
            [alert show];

    }
    } else {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }

}

-(void)sort {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [self.friends sortedArrayUsingDescriptors:sortDescriptors];
    self.friends = [sortedArray mutableCopy];
    [self positionify];
}

-(void)positionify {
    int position = 1;
    int jump = 1;
    for (int i=0; i<[self.friends count]; i++) {
        User *friend = [self.friends objectAtIndex:i];
        friend.position = position;
        if ([self.friends count]==i+1) {
            break;
        }
        User *nextFriend = [self.friends objectAtIndex:i+1];
        if ([nextFriend score]==[friend score]) {
            jump++;
        } else {
            position += jump;
            jump = 1;
        }
    }
    NSMutableArray *finalFriends = [self.friends mutableCopy];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", user.userID];
    NSArray *filteredArray = [self.friends filteredArrayUsingPredicate:predicate];
    if  (self.friends) {
        user = [filteredArray objectAtIndex:0];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
        [finalFriends removeObject:[filteredArray objectAtIndex:0]];
    }
    [UtilityMethods setFriends:finalFriends];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.searchFriends = [self.friends filteredArrayUsingPredicate:p];
    NSLog(@"Hello");
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.friendsScreen) {
        return 2;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 40;
        default:
            if (self.friendsScreen) {
                return 0;
            } else {
                return 40;
            }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            if (!self.friendsScreen) {
                UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
                footer.backgroundColor = [UIColor clearColor];
                return footer;
            }
            UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            footer.backgroundColor = [UIColor clearColor];
            return footer;
        }
            
        default:
            if (self.friendsScreen) {
                return nil;
            } else {
                UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                footer.backgroundColor = [UIColor clearColor];
                return footer;
            }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 40;
            
        case 1:
            if (self.friendsScreen) {
                return 0;
            } else {
                return 40;
            }
        default:
            return 0;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0]];
    switch (section) {
        case 0:
            if (self.friendsScreen) {
                return @"Friends on WikiMaster";
            } else {
                return @"Your position";
            }
        case 1:
            if (!self.friendsScreen) {
                return @"Your friends leaderboard";
            } else {
                return @"Friends not on WikiMaster";
            }
        default:
            return @"Friends not on WikiMaster";
    }
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
//        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
//        //headerView.contentMode = UIViewContentModeScaleToFill;
//        
//        // Add the label
//        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, -5.0, 300.0, 90.0)];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        headerLabel.text = @"Friends on WikiMaster";
//        headerLabel.textColor = [UIColor whiteColor];
//        
//        //this is what you asked
//        headerLabel.font = [UIFont fontWithName:@"Avenir Next Bold" size:14.0];
//        headerLabel.numberOfLines = 1;
//        [headerView addSubview: headerLabel];
//        
//        // Return the headerView
//        return headerView;
//    }
//    else return nil;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (!self.friendsScreen) {
                return 1;
            }
            if (self.loadedFriends) {
            if (tableView == self.tableView) {
                return [self.friends count];
            } else {
                return [self.searchFriends count];
            }
            } else {
                return 1;
            }
        case 1:
            if (self.friendsScreen) {
                return 1;
            }
            if (self.loadedFriends) {
                if (tableView == self.tableView) {
                    return [self.friends count];
                } else {
                    return [self.searchFriends count];
                }
            } else {
                return 1;
            }
        default:
            return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0: {
            if (self.friendsScreen) {
                FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
                if (cell == nil) {
                    cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
                }
                if ([self.friends objectAtIndex:[indexPath row]]) {
                    if (tableView == self.tableView) {
                        dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                        dispatch_async(imagesQueue, ^{
                            User *user = [self.friends objectAtIndex:[indexPath row]];
                            NSURL *url = [user imageURL];
                            NSData *imageData = [NSData dataWithContentsOfURL:url];
                            UIImage *image = [UIImage imageWithData:imageData];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // Update the UI
                                cell.image.image = image;
                                
                            });
                        });
                        //cell.image.image = [self.images objectAtIndex:[[self.friends objectAtIndex:[indexPath row]] imageKey]];
                        cell.name.text = [[self.friends objectAtIndex:[indexPath row]] name];
                        cell.online.text = @"Offline";
                    } else {
                        dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                        dispatch_async(imagesQueue, ^{
                            User *user = [self.searchFriends objectAtIndex:[indexPath row]];
                            NSURL *url = [user imageURL];
                            NSData *imageData = [NSData dataWithContentsOfURL:url];
                            UIImage *image = [UIImage imageWithData:imageData];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // Update the UI
                                cell.image.image = image;
                                
                            });
                        });

                        cell.name.text = [[self.searchFriends objectAtIndex:[indexPath row]] name];
                        //cell.image.image = [self.images objectAtIndex:[[self.searchFriends objectAtIndex:[indexPath row]] imageKey]];
                        cell.online.text = @"Offline";
                    }
                    
                    cell.image.layer.cornerRadius = 30;
                    cell.image.layer.masksToBounds = YES;
                    cell.image.layer.shouldRasterize = YES;
                    cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
                } else {
                    cell.name.text = @"Could not connect to Facebook";
                    cell.online.text = @"";
                    cell.image.image = [UIImage imageNamed:@"dislike-157252_640.png"];
                }
                cell.backgroundColor = [UtilityMethods getColour];
                cell.contentView.backgroundColor = [UtilityMethods getColour];
                return cell;
            } else {
                LeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaderboard"];
                if (cell == nil) {
                    cell = [[LeaderboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leaderboard"];
                }
                @try {
                    if (self.me) {
                        NSLog(@"HELLO");
                    }
                    dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                    dispatch_async(imagesQueue, ^{
                    User *user = self.me;
                    NSURL *url = [user imageURL];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:imageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        cell.image.image = image;
                        
                    });
                    });
                    //cell.image.image = [self.images objectAtIndex:[self.me imageKey]];
                    cell.name.text = [self.me name];
                    cell.score.text = [NSString stringWithFormat:@"%d", [self.me score]];
                    cell.position.text = [NSString stringWithFormat:@"%d", [self.me position]];
                    cell.image.layer.cornerRadius = 30;
                    cell.image.layer.masksToBounds = YES;
                    cell.image.layer.shouldRasterize = YES;
                    cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.name.textColor = [UtilityMethods getColour];
                    cell.score.textColor = [UtilityMethods getColour];
                    cell.scoreLabel.textColor = [UtilityMethods getColour];
                    cell.position.textColor = [UtilityMethods getColour];
                    [cell.line setHidden:YES];

                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                //cell.backgroundColor = [UtilityMethods getColour];
                //cell.contentView.backgroundColor = [UtilityMethods getColour];
                return cell;
            }
        }
        case 1: {
            if (self.friendsScreen) {
                InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invite"];
                if (cell==nil) {
                    cell = [[InviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"invite"];
                }
                cell.backgroundColor = [UtilityMethods getColour];
                cell.contentView.backgroundColor = [UtilityMethods getColour];
                cell.table = self;
                cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.bounds)/2.0, 0, CGRectGetWidth(self.tableView.bounds)/2.0);
                
                return cell;
            } else {
                LeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaderboard"];
                if (cell == nil) {
                    cell = [[LeaderboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leaderboard"];
                }
                if (tableView == self.tableView) {
                    User *user = [self.friends objectAtIndex:[indexPath row]];
                    dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                    dispatch_async(imagesQueue, ^{
                        User *user = [self.friends objectAtIndex:[indexPath row]];
                        NSURL *url = [user imageURL];
                        NSData *imageData = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:imageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            cell.image.image = image;
                            
                        });
                    });
                    
                    cell.name.text = [user name];
                    cell.score.text = [NSString stringWithFormat:@"%d", [user score]];
                    if ([cell.score.text isEqualToString:@"(null)"]) {
                        cell.score.text = @"Loading";
                    }
                    cell.position.text = [NSString stringWithFormat:@"%d", [user position]];
                } else {
                    User *user = [self.searchFriends objectAtIndex:[indexPath row]];
                    dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                    dispatch_async(imagesQueue, ^{
                        User *user = [self.searchFriends objectAtIndex:[indexPath row]];
                        NSURL *url = [user imageURL];
                        NSData *imageData = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:imageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            cell.image.image = image;
                            
                        });
                    });

                    cell.name.text = [user name];
                    cell.score.text = [NSString stringWithFormat:@"%d", [user score]];
                    if ([cell.score.text isEqualToString:@"(null)"]) {
                        cell.score.text = @"Loading";
                    }
                    cell.position.text = [NSString stringWithFormat:@"%d", [user position]];
                }
                cell.image.layer.cornerRadius = 30;
                cell.image.layer.masksToBounds = YES;
                cell.image.layer.shouldRasterize = YES;
                cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *facebookID = [self.me userID];
                NSString *ID;
                if (tableView == self.tableView) {
                    ID = [[self.friends objectAtIndex:[indexPath row]] userID];
                } else {
                    ID = [[self.searchFriends objectAtIndex:[indexPath row]] userID];
                }
                if ([ID isEqualToString:facebookID]) {
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.name.textColor = [UtilityMethods getColour];
                    cell.score.textColor = [UtilityMethods getColour];
                    cell.scoreLabel.textColor = [UtilityMethods getColour];
                    cell.position.textColor = [UtilityMethods getColour];
                    [cell.line setHidden:YES];
                } else {
                    cell.backgroundColor = [UtilityMethods getColour];
                    cell.contentView.backgroundColor = [UtilityMethods getColour];
                    cell.name.textColor = [UIColor whiteColor];
                    cell.score.textColor = [UIColor whiteColor];
                    cell.scoreLabel.textColor = [UIColor whiteColor];
                    cell.position.textColor = [UIColor whiteColor];
                    [cell.line setHidden:NO];
                }
                return cell;
            }
        }
            
        default: {
//            if ([indexPath row] == 1) {
//                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//                if (cell==nil) {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//                }
//                [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
//                [
//                return cell;
//            }
            InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invite"];
            if (cell==nil) {
                cell = [[InviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"invite"];
            }
            cell.backgroundColor = [UtilityMethods getColour];
            cell.contentView.backgroundColor = [UtilityMethods getColour];
            cell.table = self;
            cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.bounds)/2.0, 0, CGRectGetWidth(self.tableView.bounds)/2.0);
            
            return cell;
        }
    }
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (([indexPath section]==1 && self.friendsScreen) || [indexPath section]==2) {
        return nil;
    } else {
        return indexPath;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]!=2 && !self.friendsScreen) {
        if (tableView == self.tableView) {
            self.search = NO;
        } else {
            self.search = YES;
        }
        [self performSegueWithIdentifier:@"showProfile" sender:self];
    } else if ([indexPath section]==0 && self.friendsScreen){
        [self performSegueWithIdentifier:@"gamePlay" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showProfile"]) {
        ProfileViewController *vc = (ProfileViewController*)[segue destinationViewController];
        if (!self.friendsScreen || [[self.tableView indexPathForSelectedRow] section]==1) {
            vc.sender = @"friend";
        } else {
            vc.sender = NULL;
        }
        int row = [[self.tableView indexPathForSelectedRow] row];
        LeaderboardTableViewCell *cell = (LeaderboardTableViewCell*)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        vc.image = cell.imageView.image;
        vc.userID = [[self.friends objectAtIndex:row] userID];
        vc.userName = [[self.friends objectAtIndex:row] name];
        vc.user = [self.friends objectAtIndex:row];
        if ([[self.tableView indexPathForSelectedRow] section]==0) {
            vc.user = self.me;
        }
        if (self.search) {
            row = [[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow] row];
            LeaderboardTableViewCell *cell = (LeaderboardTableViewCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow]];
            vc.image = cell.imageView.image;
            vc.userID = [[self.searchFriends objectAtIndex:row] userID];
            vc.userName = [[self.searchFriends objectAtIndex:row] name];
            vc.user = [self.searchFriends objectAtIndex:row];
            if ([[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow] section]==0) {
                vc.user = self.me;
            }
            self.search = NO;
        }

        vc.hidesBottomBarWhenPushed = YES;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
