//
//  InfoboxViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoboxViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property NSArray *infoboxes;
@property NSString *parentTopic;
@property NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
