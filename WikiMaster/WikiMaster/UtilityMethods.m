//
//  UtilityMethods.m
//  WikiMaster
//
//  Created by Kunal Wagle on 29/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "UtilityMethods.h"

@implementation UtilityMethods

static NSMutableArray *colours;

+(void)initColours {
    CGFloat c0f = 15.0/255.0;
    CGFloat c3f = 63.0/255.0;
    CGFloat c6f = 111.0/255.0;
    CGFloat c9f = 159.0/255.0;
    colours = [[NSMutableArray alloc] initWithObjects:
               [UIColor colorWithRed:c0f green:c0f blue:c0f alpha:1.0],
               [UIColor colorWithRed:c9f green:c0f blue:c0f alpha:1.0],
               [UIColor colorWithRed:c9f green:c3f blue:c6f alpha:1.0],
               [UIColor colorWithRed:c9f green:c6f blue:c3f alpha:1.0],
               [UIColor colorWithRed:c6f green:c9f blue:c3f alpha:1.0],
               [UIColor colorWithRed:c0f green:c9f blue:c0f alpha:1.0],
               [UIColor colorWithRed:c3f green:c9f blue:c6f alpha:1.0],
               [UIColor colorWithRed:c3f green:c6f blue:c9f alpha:1.0],
               [UIColor colorWithRed:c0f green:c0f blue:c9f alpha:1.0],
               [UIColor colorWithRed:c6f green:c3f blue:c9f alpha:1.0],
               nil];
}

+(UIColor*)getColour {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int index = [[defaults objectForKey:@"colourIndex"] intValue];
    return [colours objectAtIndex:index];
}

+(int)getTimer {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"timer"] intValue];
}

@end
