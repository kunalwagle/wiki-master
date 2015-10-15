//
//  FriendsListTableViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 30/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendsListTableViewController : UITableViewController <UISearchDisplayDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL loadedFriends;
@property BOOL friendsScreen;
@property int counter;
@property int target;
@property User *me;
@property UIRefreshControl *refreshControl;
@property BOOL reloading;
@property NSString *infoboxName;

@end
