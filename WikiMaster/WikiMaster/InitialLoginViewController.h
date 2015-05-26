//
//  InitialLoginViewController.h
//  WikiMaster
//
//  Created by Kunal Wagle on 24/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface InitialLoginViewController : UIViewController <GPPSignInDelegate, FBSDKLoginButtonDelegate>

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@class GPPSignInButton;
