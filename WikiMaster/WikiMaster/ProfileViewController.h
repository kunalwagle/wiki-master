//
//  ProfileViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 02/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIImage *image;
@property NSString *sender;
@property NSString *userID;
@property NSString *userName;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;

@end
