//
//  FriendsListTableViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 30/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsListTableViewController : UITableViewController <UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL loadedFriends;
@property BOOL friendsScreen;
@property int counter;
@property int target;
@property NSMutableDictionary *me;

@end
