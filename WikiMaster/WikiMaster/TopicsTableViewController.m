//
//  TopicsTableViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 05/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "TopicsTableViewController.h"
#import "ServerCommunication.h"
#import "TopicTableViewCell.h"
#import "UtilityMethods.h"
#import "SubTopicsCollectionViewController.h"
#import "InfoboxViewController.h"

@interface TopicsTableViewController ()

@end

@implementation TopicsTableViewController

NSArray *categories;
NSMutableArray *subCategories;
NSArray *imageURLs;
NSMutableArray *images;
NSString *topicChosen;
NSArray *subtopics;

-(void)viewWillAppear:(BOOL)animated {
    self.tableView.backgroundColor = [UtilityMethods getColour];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Topics" object:nil];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Topics" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    images = [[NSMutableArray alloc] initWithObjects: nil];
    imageURLs = @[@"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Tom_chilton_spafrancorchamps2014.JPG/640px-Tom_chilton_spafrancorchamps2014.JPG", @"http://upload.wikimedia.org/wikipedia/commons/e/e1/BillClinger.jpg",
                  @"http://upload.wikimedia.org/wikipedia/en/5/5d/The_Black_Hole_War_-_bookcover.jpg",
                  @"http://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Burwood_Westfield.JPG/250px-Burwood_Westfield.JPG"];
    for (NSString *link in imageURLs) {
        NSURL *url = [NSURL URLWithString:link];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        [images addObject:[UIImage imageWithData:imageData]];
    }
    subCategories = [[NSMutableArray alloc] initWithObjects: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedCategories:)
                                                 name:@"Categories" object:nil];
    
    [ServerCommunication getCategories];
}

- (void)receivedCategories:(NSNotification*)notification {
    //[[NSNotificationCenter defaultCenter] removeObserver:@"Categories"];
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *temp = [info valueForKey:@"response"];
    if ([temp isEqualToString:@"FAILED"]) {

    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            categories = object;
            [self receivedSubCategories:NULL];
        } else {

        }
    }

}

-(void)clickedTopic:(NSNotification*)notification {
    NSDictionary *dict = notification.userInfo;
    topicChosen = [dict objectForKey:@"name"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnedTopics:) name:@"getTopic" object:nil];
    [ServerCommunication getSubCategories:topicChosen];
}

-(void)returnedTopics:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    NSString *temp = [info valueForKey:@"response"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getTopic" object:nil];
    if ([temp isEqualToString:@"FAILED"]) {

    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            subtopics = object;
            [self performSegueWithIdentifier:@"showTopics" sender:self];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnedInfoboxes:) name:@"categoryInfoboxes" object:nil];
            [ServerCommunication getInfoboxes:topicChosen];
        }
    }
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
            [self performSegueWithIdentifier:@"showInfoboxes" sender:self];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"categoryInfoboxes" object:nil];
        } else {
            
            //[self performSegueWithIdentifier:@"showTopic" sender:self];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receivedSubCategories:(NSNotification*)notification {
    if (notification) {
        NSString * name =notification.name;
        //notification userinfo
        NSDictionary * info =notification.userInfo;
        NSLog(@"Received Notification with name =%@",name);
        NSLog(@"Information =%@",info);
        NSString *temp = [info valueForKey:@"response"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if ([temp isEqualToString:@"FAILED"]) {
            [subCategories addObject:[[NSMutableArray alloc] initWithObjects:@"Nonsense", nil]];
        } else {
            id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            if ([object count]>0) {
                [subCategories addObject:object];
            } else {
                NSDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[categories objectAtIndex:[subCategories count]] forKey:@"name"];
                NSArray *arr = @[dict];
                [subCategories addObject:arr];
            }
        }
    }
    if ([subCategories count]<[categories count]) {
        if ([subCategories count]==1 && [[subCategories objectAtIndex:0] isEqualToArray:categories]) {
            [subCategories removeObjectAtIndex:0];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSubCategories:) name:@"Subcategories" object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSubCategories:) name:@"Subcategories" object:nil];
            [ServerCommunication getSubCategories:[categories objectAtIndex:[subCategories count]]];
        }
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedTopic:) name:@"Topics" object:nil];
        [self.tableView reloadData];
    }
    
    //If array count is equal to number of categories, remove observer and don't call again.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0]];
    return [categories objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.data = [subCategories objectAtIndex:[indexPath section]];
    cell.images = images;
    // [cell setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [cell updateCell];
    cell.backgroundColor = [UtilityMethods getColour];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showTopics"]) {
        SubTopicsCollectionViewController *vc = (SubTopicsCollectionViewController*)[segue destinationViewController];
        vc.parentTopic = topicChosen;
        vc.topics = subtopics;
        vc.images = images;
        vc.hidesBottomBarWhenPushed = YES;
    } else if ([[segue identifier] isEqualToString:@"showInfoboxes"]) {
        InfoboxViewController *vc = (InfoboxViewController*)[segue destinationViewController];
        vc.parentTopic = topicChosen;
        vc.infoboxes = subtopics;
        vc.images = images;
        vc.hidesBottomBarWhenPushed = YES;
    }
}


@end
