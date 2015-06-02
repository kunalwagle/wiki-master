//
//  ProfileViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 02/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "ProfileViewController.h"
#import "UtilityMethods.h"
#import "ServerCommunication.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.sender isEqualToString:@"friend"]) {
        self.profilePicture.image = self.image;
    } else {
        //Call Facebook for Profile Picture
    }
    [ServerCommunication getUser:@"ajkdsnfajkldn"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
    self.tableView.backgroundColor = [UtilityMethods getColour];
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
