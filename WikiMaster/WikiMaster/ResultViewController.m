//
//  ResultViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 17/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "ResultViewController.h"
#import "User.h"
#import "UtilityMethods.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
    NSData *imageData = [NSData dataWithContentsOfURL:[user imageURL]];
    UIImage *img = [UIImage imageWithData:imageData];
    self.userImage.image = img;
    self.opponentImage.image = self.image;
    self.userScore.text = self.user;
    self.opponentScore.text = self.opponent;
    self.userImage.layer.cornerRadius = 50;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.shouldRasterize = YES;
    self.userImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.opponentImage.layer.cornerRadius = 50;
    self.opponentImage.layer.masksToBounds = YES;
    self.opponentImage.layer.shouldRasterize = YES;
    self.opponentImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.navigationItem.title = self.name;
    if ([self.win isEqualToString:@"W"]) {
        self.result.text = @"BEAT";
    } else if ([self.win isEqualToString:@"L"]) {
        self.result.text = @"LOST TO";
        self.thumb.image = [UIImage imageNamed:@"dislike-157252_640.png"];
        self.congrats.text = @"MAYBE NEXT TIME";
    } else {
        self.result.text = @"DREW WITH";
        self.congrats.text = @"WHAT. A. GAME.";
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
