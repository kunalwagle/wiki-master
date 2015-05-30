//
//  SettingsViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 29/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "SettingsViewController.h"
#import "UtilityMethods.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateBackground];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int index = [[defaults objectForKey:@"colourIndex"] intValue];
    [self.colourSlider setValue:index];
    int timer = [UtilityMethods getTimer];
    [self.stepper setValue:timer];
    self.timeDisplay.text = [NSString stringWithFormat:@"%d", timer];

}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"LoggedIn"];
    [self performSegueWithIdentifier:@"loggedOut" sender:self];
}

- (void)updateBackground {
    self.view.backgroundColor = [UtilityMethods getColour];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stepper:(id)sender {
    int timer = self.stepper.value;
    self.timeDisplay.text = [NSString stringWithFormat:@"%d", timer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:timer] forKey:@"timer"];
}

- (IBAction)colourChange:(id)sender {
    float value = [self.colourSlider value];
    int index = (int) (value + 0.5);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:index] forKey:@"colourIndex"];
    [self updateBackground];
}


- (IBAction)snapSlider:(id)sender {


}

@end
