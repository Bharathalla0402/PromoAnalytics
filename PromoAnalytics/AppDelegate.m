//
//  AppDelegate.m
//  PromoAnalytics
//
//  Created by amit on 3/16/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
@import GooglePlaces;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import "TabViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "ViewController.h"
#import "MapViewController.h"
#import "PromoUrl.pch"
#import "UIImageView+WebCache.h"


@interface AppDelegate ()<CLLocationManagerDelegate>
{
    NSString * categoryID;
    double			currentLatitude;
    double			currentLongitude;
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
    CLPlacemark *currentLocPlacemark;
    CLLocation *currentLocation;
    UIImageView *imageView,*imageView2;
    UIImage *cachedImage;
    
    int j;
}
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *mapResncArray;
@end

@implementation AppDelegate
static NSString * const kClientID =@"";



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"categotyString"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"categoryID"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"strAddress"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stlatitude"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stlongitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
   // [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    currentLatitude = locationManager.location.coordinate.latitude;
    currentLongitude = locationManager.location.coordinate.longitude;
    
    
    [GMSServices provideAPIKey:@"AIzaSyA9NV07HEkJtwVymm-r6hQupJqXt8MQ6UM"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyA9NV07HEkJtwVymm-r6hQupJqXt8MQ6UM"];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
//    NSError* configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
     [GIDSignIn sharedInstance].delegate = self;
     [GIDSignIn sharedInstance].clientID = @"479046432078-qel0tpbm6v87sk7l424vkinmrnal6q9c.apps.googleusercontent.com";
    
    

    NSString * userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    if (userID.length>0)
    {
        
      //  UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
      //  TabViewController*mvc=(TabViewController *) [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mvc];
      //  self.window.rootViewController=mvc;
        
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // this any item in list you want navigate to
        MapViewController *home = (MapViewController *) [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        
        SidebarViewController *slidemenu = (SidebarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SidebarViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
        UINavigationController *smVC = [[UINavigationController alloc]initWithRootViewController:slidemenu];
        // define rear and frontviewcontroller
        SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:smVC frontViewController:nav];
        self.window.rootViewController=revealController;
        
    }
    else
    {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // this any item in list you want navigate to
        ViewController *home = (ViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        SidebarViewController *slidemenu = (SidebarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SidebarViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
        UINavigationController *smVC = [[UINavigationController alloc]initWithRootViewController:slidemenu];
        // define rear and frontviewcontroller
        SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:smVC frontViewController:nav];
        self.window.rootViewController=revealController;
    }

    return YES;
}






- (BOOL)application:(UIApplication *)app

            openURL:(NSURL *)url

            options:(NSDictionary *)options {
    
   [[FBSDKApplicationDelegate sharedInstance] application:app
                                                   openURL:url
                                         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    
//    return  [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation
//            ];
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
  
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
//    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
//    NSString *email = user.profile.email;
//    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    //
}

@end
