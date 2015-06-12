//
//  FirstViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 20/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *played;
@property (weak, nonatomic) IBOutlet UILabel *won;
@property (weak, nonatomic) IBOutlet UILabel *lost;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL loadedUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settings;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profile;




@end

