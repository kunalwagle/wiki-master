//
//  FinalTotalsViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalTotalsViewController : UIViewController

@property int totalTime;
@property int runningScore;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *correctness;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIImageView *thumbs;
@property int correctAnswers;

@end
