//
//  QuizLoadingViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 26/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizLoadingViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeMessage;
@property (weak, nonatomic) IBOutlet UILabel *quizName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *connectingMessage;
@property (weak, nonatomic) IBOutlet UILabel *countdown;
@property NSString *infoboxName;
@property NSString *secondID;
@property NSString *gameID;

@end
