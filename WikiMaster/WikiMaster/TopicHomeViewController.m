//
//  TopicHomeViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 07/06/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "TopicHomeViewController.h"
#import "FriendsListTableViewController.h"
#import "UtilityMethods.h"
#import "QuizLoadingViewController.h"
#import "ServerCommunication.h"
#import "User.h"

@interface TopicHomeViewController ()

@end

@implementation TopicHomeViewController

BOOL favourite;
UIAlertView *alert;
UIAlertView *errorAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image.image = self.topicImage;
    self.name.text = self.topicName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotStats:) name:@"getTopicStats" object:nil];
    ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
    //[alert show];
    [comms getTopicStats:self.topicName];
    // Do any additional setup after loading the view.
}

-(void)gotStats:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    NSString *temp = [info valueForKey:@"response"];
    NSLog(@"Received Notification with name =%@",notification.name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getTopicStats" object:nil];
    if ([temp isEqualToString:@"FAILED"]) {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
        [errorAlert show];
        
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            NSDictionary *result = object;
            NSDictionary *gameStats = [result objectForKey:@"gameStats"];
            self.played.text = [NSString stringWithFormat:@"%@", [gameStats objectForKey:@"gamesPlayed"]];
            self.win.text = [NSString stringWithFormat:@"%@", [gameStats objectForKey:@"wins"]];
            self.lost.text = [NSString stringWithFormat:@"%@", [gameStats objectForKey:@"losses"]];
            self.points.text = [NSString stringWithFormat:@"%@", [gameStats objectForKey:@"score"]];
            int avgScore = [[gameStats objectForKey:@"score"] intValue]/[[gameStats objectForKey:@"gamesPlayed"] intValue];
            self.averageScore.text = [NSString stringWithFormat:@"%d", avgScore];
            self.totalCorrect.text = [NSString stringWithFormat:@"%@", [gameStats objectForKey:@"totalQuestionsCorrect"]];
            if ([[result objectForKey:@"isFavourite"]boolValue]==0)
                favourite = NO;
            else {
                NSLog(@"%d", [[result objectForKey:@"isFavourite"] boolValue]);
                favourite = YES;
            }
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self viewWillAppear:NO];
        } else {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
            [errorAlert show];
            
            //[self performSegueWithIdentifier:@"showTopic" sender:self];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    self.view.backgroundColor = [UtilityMethods getColour];
    if ([self isFavourited]) {
        [self.favouritesButton.imageView setImage:[UIImage imageNamed:@"Christmas Star Filled-50.png"]];
        [self.favouritesButton.imageView setTintColor:[UIColor colorWithRed:252.0/255.0
                                                  green:194.0/255.0 blue:0 alpha:1.0]];
    } else {
        [self.favouritesButton.imageView setImage:[UIImage imageNamed:@"Christmas Star-50.png"]];
        [self.favouritesButton.imageView setTintColor:[UIColor whiteColor]];
        
    }
}

-(BOOL)isFavourited {
    return favourite;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == errorAlert) {
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnedInfoboxes:) name:@"categoryInfoboxes" object:nil];
            alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment."
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
            //[alert show];
            ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
            //[comms getInfoboxes:topicChosen];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"challenge"]) {
        FriendsListTableViewController *vc = (FriendsListTableViewController*)[segue destinationViewController];
        vc.friendsScreen = YES;
    } else if ([[segue identifier] isEqualToString:@"1playergame"]) {
        QuizLoadingViewController *vc = (QuizLoadingViewController*)[segue destinationViewController];
        vc.infoboxName = self.topicName;
    }
}

-(void)updateFavourite:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    NSString *temp = [info valueForKey:@"response"];
    NSLog(@"Received Notification with name =%@",notification.name);
    NSLog(@"Information =%@",info);
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateFavourite" object:nil];
    if ([temp isEqualToString:@"FAILED"]) {
        
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
        [errorAlert show];
        
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            NSArray *result = object;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user"]];
            user.favourites = result;
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
            if (![self isFavourited]) {
                [self.favouritesButton.imageView setImage:[UIImage imageNamed:@"Christmas Star Filled-50.png"]];
                [self.favouritesButton.imageView setTintColor:[UIColor colorWithRed:252.0/255.0
                                                                              green:194.0/255.0 blue:0 alpha:1.0]];
                favourite = YES;
            } else {
                [self.favouritesButton.imageView setImage:[UIImage imageNamed:@"Christmas Star-50.png"]];
                [self.favouritesButton.imageView setTintColor:[UIColor whiteColor]];
                favourite = NO;
            }
        } else {
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server" message:@"Sorry about that" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try again", nil];
            [errorAlert show];
            
            //[self performSegueWithIdentifier:@"showTopic" sender:self];
        }
    }

}

- (IBAction)clickedFavourite:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFavourite:) name:@"updateFavourite" object:nil];
    alert = [[UIAlertView alloc] initWithTitle:@"Connecting to server..." message:@"This may take a moment."
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    //[alert show];
    ServerCommunication *comms = [[ServerCommunication alloc] initWithData];
    NSLog(self.topicName);
    [comms addFavourite:self.topicName];
}
@end
