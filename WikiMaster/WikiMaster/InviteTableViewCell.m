//
//  InviteTableViewCell.m
//  WikiMaster
//
//  Created by Kunal Wagle on 01/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "InviteTableViewCell.h"

@implementation InviteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clicked:(id)sender {
    NSString *string = @"This is a really cool app that you should check out. It's called WikiMaster.";
    
    NSArray *objectsToShare = @[string];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypeAirDrop
                                   ];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self.table presentViewController:activityVC animated:YES completion:nil];
}

@end
