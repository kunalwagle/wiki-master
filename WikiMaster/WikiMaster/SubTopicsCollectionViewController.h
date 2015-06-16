//
//  SubTopicsCollectionViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTopicsCollectionViewController : UICollectionViewController<UIAlertViewDelegate>

@property NSArray *topics;
@property NSMutableArray *images;
@property NSString *parentTopic;

@end
