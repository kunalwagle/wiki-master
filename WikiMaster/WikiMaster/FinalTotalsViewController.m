//
//  FinalTotalsViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 27/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "FinalTotalsViewController.h"
#import "UtilityMethods.h"

@interface FinalTotalsViewController ()

@end

@implementation FinalTotalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    if ((self.totalTime%60)<10) {
        self.time.text = [NSString stringWithFormat:@"%d:0%d", self.totalTime/60, self.totalTime%60];
    } else {
        self.time.text = [NSString stringWithFormat:@"%d:%d", self.totalTime/60, self.totalTime%60];
    }
    self.correctness.text = [NSString stringWithFormat:@"%d out of 6", self.correctAnswers];
    self.total.text = [NSString stringWithFormat:@"%d", self.runningScore];
    if (self.correctAnswers<=3) {
        self.thumbs.image = [UIImage imageNamed:@"dislike-157252_640.png"];
    }
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
