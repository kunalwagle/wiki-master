//
//  SubTopicsCollectionViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "SubTopicsCollectionViewController.h"
#import "TopicViewCell.h"
#import "UtilityMethods.h"
#import "ServerCommunication.h"
#import "InfoboxViewController.h"

@interface SubTopicsCollectionViewController ()

@end

@implementation SubTopicsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
NSArray *subtopics;
NSString *topicChosen;

- (void)viewDidLoad {
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
    [flowLayout setItemSize:CGSizeMake(115, 90)];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setFrame:CGRectMake(0, 0, 400, self.view.frame.size.height)];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView registerClass:[TopicViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.backgroundColor = [UtilityMethods getColour];
    self.collectionView.collectionViewLayout = flowLayout;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.topics count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicViewCell *cell = (TopicViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSDictionary *dict = [self.topics objectAtIndex:[indexPath row]];
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

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicViewCell *cell = (TopicViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    topicChosen = cell.name.text;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnedInfoboxes:) name:@"categoryInfoboxes" object:nil];
    [ServerCommunication getInfoboxes:topicChosen];
}

-(void)returnedInfoboxes:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    NSString *temp = [info valueForKey:@"response"];
    NSLog(@"Received Notification with name =%@",notification.name);
    NSLog(@"Information =%@",info);
    if ([temp isEqualToString:@"FAILED"]) {
        
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            subtopics = object;
            [self performSegueWithIdentifier:@"subtopicsInfoboxes" sender:self];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"categoryInfoboxes" object:nil];
        } else {
            
            //[self performSegueWithIdentifier:@"showTopic" sender:self];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    InfoboxViewController *vc = (InfoboxViewController*)[segue destinationViewController];
    vc.parentTopic = topicChosen;
    vc.infoboxes = subtopics;
    vc.images = self.images;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
