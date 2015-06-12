//
//  InfoboxViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "InfoboxViewController.h"
#import "TopicViewCell.h"
#import "UtilityMethods.h"
#import "TopicHomeViewController.h"

@interface InfoboxViewController ()

@end

@implementation InfoboxViewController

NSString *topicName;
UIImage *img;

- (void)viewDidLoad {
    self.view.backgroundColor = [UtilityMethods getColour];
    [super viewDidLoad];
    self.navigationItem.title = self.parentTopic;
    [self updateCell];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)updateCell {
    [self setUpCollectionView];
    [self.collectionView reloadData];
}

#pragma CollectionView

-(void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:-10.0f];
    [flowLayout setMinimumLineSpacing:-10.0f];
    [flowLayout setItemSize:CGSizeMake(115, 110)];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setFrame:CGRectMake(0, 0, 400, 130*[self.infoboxes count])];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView registerClass:[TopicViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.backgroundColor = [UtilityMethods getColour];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.scrollEnabled = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.isSearching = NO;
        [self.collectionView reloadData];
    } else {
        self.isSearching = YES;
        [self filterText:searchText];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = YES;
    NSString *searchText = searchBar.text;
    [searchBar resignFirstResponder];
    [self filterText:searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self.collectionView reloadData];
}

-(void)filterText:(NSString*)searchText {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.searchInfoboxes = [self.infoboxes filteredArrayUsingPredicate:p];
    [self.collectionView reloadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearching) {
        topicName = [[self.searchInfoboxes objectAtIndex:[indexPath row]] objectForKey:@"name"];
    } else {
        topicName = [[self.infoboxes objectAtIndex:[indexPath row]] objectForKey:@"name"];
    }
    img = [self.images objectAtIndex:[indexPath row]%4];
    [self performSegueWithIdentifier:@"toTopic" sender:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSearching) {
        return [self.searchInfoboxes count];
    }
    return [self.infoboxes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicViewCell *cell = (TopicViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSDictionary *dict = [self.infoboxes objectAtIndex:[indexPath row]];
    if (self.isSearching) {
        dict = [self.searchInfoboxes objectAtIndex:[indexPath row]];
    }
    NSString *title = [dict objectForKey:@"name"];
    cell.name.text = title;
    cell.image.image = [self.images objectAtIndex:[indexPath row]%4];
    cell.image.layer.cornerRadius = 10;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.shouldRasterize = YES;
    cell.image.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.backgroundColor = [UtilityMethods getColour];
    cell.name.textColor = [UIColor whiteColor];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTopic"]) {
        TopicHomeViewController *vc = (TopicHomeViewController*)[segue destinationViewController];
        vc.topicName = topicName;
        vc.topicImage = img;
    }
}


@end
