//
//  InviteTableViewCell.h
//  WikiMaster
//
//  Created by Kunal Wagle on 01/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
- (IBAction)clicked:(id)sender;
@property (weak) UITableViewController *table;

@end
