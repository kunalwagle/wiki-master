//
//  ResultViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 17/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *opponentImage;
@property (weak, nonatomic) IBOutlet UILabel *userScore;
@property (weak, nonatomic) IBOutlet UILabel *opponentScore;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *congrats;
@property UIImage *image;
@property NSString *user;
@property NSString *opponent;
@property NSString *win;
@property NSString *name;

@end
