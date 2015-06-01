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

@property NSMutableArray *friends;
@property NSArray *searchFriends;

@end

@implementation FriendsListTableViewController

NSMutableArray *images;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friends = [[NSMutableArray alloc] initWithObjects: nil];
    images = [[NSMutableArray alloc] initWithObjects: nil];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:@{@"fields":@"picture, name"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSArray *temp = [result objectForKey:@"data"];
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
            [dictionary setValue:[NSNumber numberWithInt:[images count]] forKey:@"imageNumber"];
            [images addObject:image];
            [self.friends addObject:dictionary];
        }
            [self.tableView reloadData];
        }
    }];
    UINib *nib = [UINib nibWithNibName:@"InviteTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"invite"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"invite"];
    nib = [UINib nibWithNibName:@"FriendTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"friend"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"friend"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UtilityMethods getColour];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UtilityMethods getColour];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated {
    self.tableView.backgroundColor = [UtilityMethods getColour];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UtilityMethods getColour];
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
            if (tableView == self.tableView) {
                return [self.friends count];
            } else {
                return [self.searchFriends count];
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
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
            if (cell == nil) {
                cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
            }
            if (tableView == self.tableView) {
                cell.image.image = [images objectAtIndex:[indexPath row]];
                cell.name.text = [[self.friends objectAtIndex:[indexPath row]] valueForKey:@"name"];
                cell.online.text = @"Offline";
            } else {
                cell.name.text = [[self.searchFriends objectAtIndex:[indexPath row]] valueForKey:@"name"];
                cell.image.image = [images objectAtIndex:[[[self.searchFriends objectAtIndex:[indexPath row]] valueForKey:@"imageNumber"] intValue]];
                cell.online.text = @"Offline";
            }
            
            cell.image.layer.cornerRadius = 30;
            cell.image.layer.masksToBounds = YES;
            cell.image.layer.shouldRasterize = YES;
            cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
            cell.backgroundColor = [UtilityMethods getColour];
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
            cell.backgroundColor = [UtilityMethods getColour];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==0) {
        [self performSegueWithIdentifier:@"showProfile" sender:self];
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
