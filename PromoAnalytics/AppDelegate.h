//
//  AppDelegate.h
//  PromoAnalytics
//
//  Created by amit on 3/16/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

