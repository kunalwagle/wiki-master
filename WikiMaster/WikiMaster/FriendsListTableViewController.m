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



@interface FriendsListTableViewController ()

@property NSArray *friends;
@property NSArray *invitableFriends;

@end

@implementation FriendsListTableViewController

NSMutableArray *images;

- (void)viewDidLoad {
    [super viewDidLoad];
    images = [[NSMutableArray alloc] initWithObjects: nil];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:@{@"fields":@"picture, name"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
        self.friends = [result objectForKey:@"data"];
        //NSLog(result);
        for (NSDictionary* dict in self.friends) {
            for (id key in dict) {
                NSLog(@"key: %@, value: %@ \n", key, [dict objectForKey:key]);
            }
            NSDictionary *pictureData = [dict objectForKey:@"picture"];
            NSString *pictureURL = [NSString stringWithFormat:@"%@",[[pictureData objectForKey:@"data"] objectForKey:@"url"]];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
            UIImage *image = [UIImage imageWithData:imageData];
            [images addObject:image];
        }
            [self.tableView reloadData];
        }
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UtilityMethods getColour];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 40;
        default:
            return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: {
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
            return @"Friends on WikiMaster";
            
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
            return [self.friends count];
            
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
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
            if (cell == nil) {
                cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
            }
            cell.image.image = [images objectAtIndex:[indexPath row]];
            cell.image.layer.cornerRadius = 30;
            cell.image.layer.masksToBounds = YES;
            cell.image.layer.shouldRasterize = YES;
            cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
            cell.name.text = [[self.friends objectAtIndex:[indexPath row]] valueForKey:@"name"];
            cell.online.text = @"Offline";
            cell.contentView.backgroundColor = [UtilityMethods getColour];
            return cell;
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
            cell.contentView.backgroundColor = [UtilityMethods getColour];
            cell.table = self;
            cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.bounds)/2.0, 0, CGRectGetWidth(self.tableView.bounds)/2.0);
            
            return cell;
        }
    }
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section]==1) {
        return nil;
    } else {
        return indexPath;
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
