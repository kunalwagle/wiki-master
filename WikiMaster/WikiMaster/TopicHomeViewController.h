//
//  TopicHomeViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *played;
@property (weak, nonatomic) IBOutlet UILabel *win;
@property (weak, nonatomic) IBOutlet UILabel *lost;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UILabel *averageScore;
@property (weak, nonatomic) IBOutlet UILabel *totalCorrect;
@property NSString *topicName;
@property UIImage *topicImage;



@end
