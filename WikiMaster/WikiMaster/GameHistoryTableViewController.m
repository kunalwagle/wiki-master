//
//  GameHistoryTableViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 15/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "GameHistoryTableViewController.h"
#import "LeaderboardTableViewCell.h"
#import "UtilityMethods.h"
#import "ServerCommunication.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "User.h"
#import "QuizLoadingViewController.h"
#import "ResultViewController.h"

@interface GameHistoryTableViewController ()

@property BOOL isReloading;

@end

@implementation GameHistoryTableViewController

NSArray *complete;
NSArray *challenges;
NSArray *incomplete;
UIAlertView *alert;
UIAlertView *errorAlert;
NSArray *friends;
LeaderboardTableViewCell* cell2;
NSDictionary *gameChosen;
NSString *win;

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [UtilityMethods getFriends];
    UINib *nib = [UINib nibWithNibName:@"LeaderboardMeCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"cell"];
    complete = nil;
    incomplete = nil;
    challenges = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGames:) name:@"GamesList" object:nil];
    alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
    [comms getGames];
    [alert show];
    if (!self.isReloading) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UtilityMethods getColour];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self
                                action:@selector(refreshAll)
                      forControlEvents:UIControlEventValueChanged];
    }
    self.isReloading = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    self.isReloading = YES;
    [self viewDidLoad];
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

-(void)gotGames:(NSNotification*)notification {
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *temp = [info valueForKey:@"response"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    if ([temp isEqualToString:@"FAILED"]) {
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            //         if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = object;
            complete = [result objectForKey:@"recentGames"];
            challenges = [result objectForKey:@"challenged"];
            incomplete = [result objectForKey:@"sentChallenges"];
            UITabBarItem *tbi = (UITabBarItem *)self.tabBarController.selectedViewController.tabBarItem;
            tbi.badgeValue = [NSString stringWithFormat:@"%d", [challenges count]];
            if ([challenges count]==0) {
                tbi.badgeValue = nil;
            }
            //    } else {
            //ERROR HANDLING
            //       self.loadedUser = NO;
        } else {
            //ERROR HANDLING
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0: return [challenges count];
        case 1: return [incomplete count];
        case 2: return [complete count];
        default:return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 40;
        default:
            return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:{
            UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            footer.backgroundColor = [UIColor clearColor];
            return footer;
        }
            
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 40;
        default:
            return 0;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0]];
    switch (section) {
        case 0:
            return @"Waiting on you";
        case 1:
            return @"Waiting on them";
        default:
            return @"Recently complete games";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[LeaderboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *game;
    NSDictionary *infobox;
    NSDictionary *facebook;
    switch ([indexPath section]) {
        case 0: {
            game = [challenges objectAtIndex:[indexPath row]];
            cell.scoreLabel.text = @"Score to beat:";
            cell.score.hidden = NO;
            cell.position.hidden = YES;
            cell.score.text = [NSString stringWithFormat:@"%@", [game objectForKey:@"opponentScore"]];
            facebook = [[game objectForKey:@"opponent"] objectForKey:@"facebook"];
            NSString *userID = [facebook objectForKey:@"id"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
            NSArray *filteredArray = [friends filteredArrayUsingPredicate:predicate];
            User *user = [filteredArray objectAtIndex:0];
            dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
            dispatch_async(imagesQueue, ^{
                //NSLog(@"Link is: %@", link);
                NSData *imageData = [NSData dataWithContentsOfURL:[user imageURL]];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    if (image) {
                        cell.image.image = image;
                    }
                    // NSLog(@"Found the image for a cell");
                    
                });
            });

            break;
    }
        case 1: {
            game = [incomplete objectAtIndex:[indexPath row]];
            cell.position.hidden = YES;
            facebook = [[game objectForKey:@"opponent"] objectForKey:@"facebook"];
            NSString *userID = [facebook objectForKey:@"id"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
            NSArray *filteredArray = [friends filteredArrayUsingPredicate:predicate];
            User *user = [filteredArray objectAtIndex:0];
            dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
            dispatch_async(imagesQueue, ^{
                //NSLog(@"Link is: %@", link);
                NSData *imageData = [NSData dataWithContentsOfURL:[user imageURL]];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    if (image) {
                        cell.image.image = image;
                    }
                    // NSLog(@"Found the image for a cell");
                    
                });
            });
            cell.scoreLabel.text = @"You scored:";
            cell.score.text = [NSString stringWithFormat:@"%@", [game objectForKey:@"userScore"]];
            break;
    }
        case 2:
            game = [complete objectAtIndex:[complete count]-1-[indexPath row]];
            cell.position.hidden = NO;
            cell.score.hidden = NO;
            cell.scoreLabel.hidden = NO;
            infobox = [game objectForKey:@"infobox"];
            cell.image.image = [UIImage imageNamed:@"default_topic.png"];
            cell.scoreLabel.text = @"Your score:";
            cell.score.text = [NSString stringWithFormat:@"%@", [game objectForKey:@"userScore"]];
            if ([[game objectForKey:@"numPlayers"] intValue] == 1) {
                cell.position.text = @"1P";
                dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                dispatch_async(imagesQueue, ^{
                    NSDictionary *img = [infobox objectForKey:@"image"];
                    NSString *link = [img objectForKey:@"url"];
                    NSURL *url = [NSURL URLWithString:link];
                    //NSLog(@"Link is: %@", link);
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:imageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        if (image) {
                            cell.image.image = image;
                        }
                       // NSLog(@"Found the image for a cell");
                        
                    });
                });
            } else {
                cell.scoreLabel.text = @"Click to see details";
                cell.score.hidden = YES;
                NSString *text = [game objectForKey:@"result"];
                text = [[text substringToIndex:1] capitalizedString];
                facebook = [[game objectForKey:@"opponent"] objectForKey:@"facebook"];
                cell.position.text = text;
                NSString *userID = [facebook objectForKey:@"id"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
                NSArray *filteredArray = [friends filteredArrayUsingPredicate:predicate];
                cell.image.image = [UIImage imageNamed:@"default_topic.png"];
                if ([filteredArray count]>0) {
                    User *user = [filteredArray objectAtIndex:0];
                    dispatch_queue_t imagesQueue = dispatch_queue_create("Images", NULL);
                    dispatch_async(imagesQueue, ^{
                        //NSLog(@"Link is: %@", link);
                        NSData *imageData = [NSData dataWithContentsOfURL:[user imageURL]];
                        UIImage *image = [UIImage imageWithData:imageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            if (image) {
                                cell.image.image = image;
                            }
                            // NSLog(@"Found the image for a cell");
                            
                        });
                    });
                }
                
                
            }
            break;
        default:
            break;
    }
    infobox = [game objectForKey:@"infobox"];
    cell.name.text = [[infobox objectForKey:@"name"] capitalizedString];
    cell.image.layer.cornerRadius = 30;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.shouldRasterize = YES;
    cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.backgroundColor = [UtilityMethods getColour];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    cell2 = (LeaderboardTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([indexPath section]==0) {
        gameChosen = [challenges objectAtIndex:[indexPath row]];
        [self performSegueWithIdentifier:@"acceptChallenge" sender:self];
    } else {
        if ([indexPath section]==2 && ![cell2.position.text isEqualToString:@"1P"]) {
            gameChosen = [complete objectAtIndex:[complete count]-1-[indexPath row]];
            win = cell2.position.text;
            [self performSegueWithIdentifier:@"showResult" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"acceptChallenge"]) {
        QuizLoadingViewController *vc = (QuizLoadingViewController*)[segue destinationViewController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.infoboxName = [cell2.name.text lowercaseString];
        vc.gameID = [gameChosen objectForKey:@"id"];
        UITabBarItem *tbi = (UITabBarItem *)self.tabBarController.selectedViewController.tabBarItem;
        tbi.badgeValue = [NSString stringWithFormat:@"%d", [challenges count]-1];
        if ([challenges count]==1) {
            tbi.badgeValue = nil;
        }
    } else if ([[segue identifier] isEqualToString:@"showResult"] ) {
        ResultViewController *vc = (ResultViewController*)[segue destinationViewController];
        vc.opponent = [NSString stringWithFormat:@"%@", [gameChosen objectForKey:@"opponentScore"]];
        vc.user = [NSString stringWithFormat:@"%@", [gameChosen objectForKey:@"userScore"]];
        vc.win = win;
        vc.image = cell2.image.image;
        vc.name = cell2.name.text;
        vc.hidesBottomBarWhenPushed = YES;
    }
}


@end
