//
//  FriendTableViewCell.h
//  WikiMaster
//
//  Created by Kunal Wagle on 01/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *online;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@end
