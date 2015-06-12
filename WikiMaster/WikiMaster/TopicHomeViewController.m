//
//  TopicHomeViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "TopicHomeViewController.h"
#import "FriendsListTableViewController.h"
#import "UtilityMethods.h"

@interface TopicHomeViewController ()

@end

@implementation TopicHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image.image = self.topicImage;
    self.name.text = self.topicName;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"challenge"]) {
        FriendsListTableViewController *vc = (FriendsListTableViewController*)[segue destinationViewController];
        vc.friendsScreen = YES;
    }
}



@end
