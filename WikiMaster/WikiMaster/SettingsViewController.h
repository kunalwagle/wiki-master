//
//  SettingsViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 29/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *colourSlider;
- (IBAction)stepper:(id)sender;
- (IBAction)colourChange:(id)sender;

- (IBAction)snapSlider:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;


@end
