//
//  TopicTableViewCell.h
//  WikiMaster
//
//  Created by Kunal Wagle on 04/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *testData;

-(void)updateCell;

@end
