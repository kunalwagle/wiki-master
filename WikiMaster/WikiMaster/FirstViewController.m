//
//  FirstViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 20/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults valueForKey:@"LoggedIn"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"InitialLoginViewController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
