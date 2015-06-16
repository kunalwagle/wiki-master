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

@interface GameHistoryTableViewController ()

@end

@implementation GameHistoryTableViewController

NSArray *complete;
NSArray *challenges;
NSArray *incomplete;
UIAlertView *alert;
UIAlertView *errorAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"LeaderboardMeCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGames:) name:@"GamesList" object:nil];
    alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
    [comms getGames];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if ([temp isEqualToString:@"FAILED"]) {
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            //         if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = object;
            complete = [result objectForKey:@"recentGames"];
            challenges = [result objectForKey:@"challenged"];
            incomplete = [result objectForKey:@"sentChallenges"];
            
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
    switch ([indexPath section]) {
        case 0:
            game = [challenges objectAtIndex:[indexPath row]];
            cell.score.text = @"Click to play now";
            cell.scoreLabel.hidden = YES;
            break;
        case 1:
            game = [incomplete objectAtIndex:[indexPath row]];
            cell.score.text = @"You scored:";
            cell.scoreLabel.text = [NSString stringWithFormat:@"%@", [game objectForKey:@"ownerScore"]];
            break;
        case 2:
            game = [complete objectAtIndex:[indexPath row]];
            if ([[game objectForKey:@"numPlayers"] intValue] == 1) {
                cell.position.text = @"1P";
                //cell.imageView.image = [UIImage imageNamed:]
            } else {
                NSString *text = [game objectForKey:@"result"];
                text = [[text substringToIndex:1] capitalizedString];
                cell.position.text = text;
                
            }
            break;
        default:
            break;
    }
    infobox = [game objectForKey:@"infobox"];
    cell.name.text = [infobox objectForKey:@"name"];
    cell.image.layer.cornerRadius = 30;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.shouldRasterize = YES;
    cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.backgroundColor = [UtilityMethods getColour];
    // Configure the cell...
    
    return cell;
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
