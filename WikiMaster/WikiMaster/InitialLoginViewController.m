//
//  InitialLoginViewController.m
//  WikiMaster
//
//  Created by Kunal Wagle on 24/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "InitialLoginViewController.h"
#import "UtilityMethods.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ServerCommunication.h"
#import <FBSDKCoreKit/FBSDKProfile.h>

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface InitialLoginViewController ()

@end

@implementation InitialLoginViewController

@synthesize signInButton;
@synthesize loading;

UIAlertView *alert;

static NSString * const kClientId = @"976248599268-4u6e0njbk439n9epjv6a5jrrnn6dmu4h.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    // Do any additional setup after loading the view.
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.useClientIDForURLScheme = YES;
    [loading setHidden:YES];
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail = YES;
    //[signIn trySilentAuthentication];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewFetchedUserInfo)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        // User is logged in, do work such as go to next view controller.
//      //  [self performSegueWithIdentifier:@"googleSignIn" sender:self];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        NSLog(@"Hi There Andrew");
//    }
}

-(void)viewDidAppear:(BOOL)animated {
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        //  [self performSegueWithIdentifier:@"googleSignIn" sender:self];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"LoggedIn"];
        [defaults synchronize];
    }
    //[loading setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UtilityMethods getColour];
}

-(void)loginViewFetchedUserInfo{
    NSLog(@"Reached here");
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        //  [self performSegueWithIdentifier:@"googleSignIn" sender:self];
        FBSDKProfile *profile = [FBSDKProfile currentProfile];
        NSString *userID = profile.userID;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedNotification:)
                                                     name:@"Notification" object:nil];
        alert = [[UIAlertView alloc] initWithTitle:@"Signing you in" message:@"This may take a moment."
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        //
        //            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
        //                                                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //            [alert setValue:loading forKey:@"accessoryView"];
        [loading startAnimating];
        [loading setHidden:NO];
        [alert show];
        //   [comms initNetworkCommunication];
        //   NSString *message = @"ident:";
        [ServerCommunication addUser:userID];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (void)
loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error {
    if (error) {
        
    } else {
            //[self performSegueWithIdentifier:@"facebookSignIn" sender:self];
        if ([FBSDKAccessToken currentAccessToken]) {
            // User is logged in, do work such as go to next view controller.
            //  [self performSegueWithIdentifier:@"googleSignIn" sender:self];
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id profile, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", profile);
                         //NSString *userID = @"akjsfnd";
                         [[NSNotificationCenter defaultCenter] addObserver:self
                                                                  selector:@selector(receivedNotification:)
                                                                      name:@"Notification" object:nil];
                         alert = [[UIAlertView alloc] initWithTitle:@"Signing you in" message:@"This may take a moment."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
                         //
                         //            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                         //                                                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                         //            [alert setValue:loading forKey:@"accessoryView"];
                         [loading startAnimating];
                         [loading setHidden:NO];
                         [alert show];
                         //   [comms initNetworkCommunication];
                         //   NSString *message = @"ident:";
                         [ServerCommunication addUser:[[FBSDKAccessToken currentAccessToken] tokenString]];
                     }
                 }];
            
        }
    }
}

- (void)receivedNotification:(NSNotification*) notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //name of the notification
    NSString * name =notification.name;
    
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [loading stopAnimating];
    [loading setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"LoggedIn"];
    [defaults synchronize];
}

//-(void)refreshInterfaceBasedOnSignIn {
//    if ([[GPPSignIn sharedInstance] authentication]) {
//        // The user is signed in.
//        //[self performSegueWithIdentifier:@"googleSignIn" sender:self];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"LoggedIn"];
//        [defaults synchronize];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        // Perform other actions here, such as showing a sign-out button
//    }
//}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
   // NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
//        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
//        plusService.retryEnabled = YES;
//        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
//        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
//        NSString *email;
//        [plusService executeQuery:query
//                completionHandler:^(GTLServiceTicket *ticket,
//                                    GTLPlusPerson *person,
//                                    NSError *error) {
//                    if (error) {
//                        GTMLoggerError(@"Error: %@", error);
//                    } else {
//                        // Retrieve the display name and "about me" text
//                        email = [GPPSignIn sharedInstance].authentication.userEmail;
//                    }
//                }];
//        
//
        NSString *userAuthentication = [GPPSignIn sharedInstance].userEmail;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedNotification:)
                                                     name:@"Login" object:nil];
        alert = [[UIAlertView alloc] initWithTitle:@"Signing you in" message:@"This may take a moment."
                                         delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:nil];
        //
        //            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
        //                                                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //            [alert setValue:loading forKey:@"accessoryView"];
        [loading startAnimating];
        [loading setHidden:NO];
        [alert show];
       // [comms initNetworkCommunication];
       // NSString *message = @"ident:";
        [ServerCommunication addUser:userAuthentication];
    }
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

@end
