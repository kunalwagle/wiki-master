//
//  LeaderboardTableViewCell.h
//  WikiMaster
//
//  Created by Kunal Wagle on 06/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *person;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
