//
//  TopicTableViewCell.m
//  WikiMaster
//
//  Created by Kunal Wagle on 04/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "TopicTableViewCell.h"
#import "TopicViewCell.h"
#import "UtilityMethods.h"

@implementation TopicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell {
    [self setUpCollectionView];
    [self.collectionView reloadData];
}

#pragma CollectionView

-(void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:10.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setItemSize:CGSizeMake(130, 110)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setFrame:CGRectMake(0, 0, 400, 150)];
    [self addSubview:self.collectionView];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView registerClass:[TopicViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.backgroundColor = [UtilityMethods getColour];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.testData count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicViewCell *cell = (TopicViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.name.text = [self.testData objectAtIndex:[indexPath row]];
    cell.backgroundColor = [UtilityMethods getColour];
    cell.name.textColor = [UIColor whiteColor];
    return cell;
}

@end
