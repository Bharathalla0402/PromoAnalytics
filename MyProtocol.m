//
//  MyProtocol.m
//  ProjectBay
//
//  Created by amit on 8/29/16.
//  Copyright © 2016 Think360Studio. All rights reserved.
//

#import "MyProtocol.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>

@implementation MyProtocol

-(void)checkNetworkStatus
{
    Reachability* internetAvailable = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetAvailable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            _isInternetConnectionAvailable = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            _isInternetConnectionAvailable = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            _isInternetConnectionAvailable = YES;
            break;
        }
    }
}


#pragma mark -- UIAlertView Method

-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
    
}


//#pragma mark -- View Animation --
//
//
//-(void)viewSlideInFromLeftToRight:(UIView *)views
//{
//    CATransition *transition = nil;
//    transition = [CATransition animation];
//    transition.duration = 1.0;//kAnimationDuration
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype =kCATransitionFromLeft;
//    transition.delegate = self;
//    [views.layer addAnimation:transition forKey:nil];
//}
//-(void)viewSlideInFromRightToLeft:(UIView *)views
//{
//    CATransition *transition = nil;
//    transition = [CATransition animation];
//    transition.duration = 1.0;//kAnimationDuration
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype =kCATransitionFromRight;
//    transition.delegate = self;
//    [views.layer addAnimation:transition forKey:nil];
//}
//-(void)viewSlideInFromTopToBottom:(UIView *)views
//{
//    CATransition *transition = nil;
//    transition = [CATransition animation];
//    transition.duration = 1.0;//kAnimationDuration
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype =kCATransitionFromBottom ;
//    transition.delegate = self;
//    [views.layer addAnimation:transition forKey:nil];
//}
//
//-(void)viewSlideInFromBottomToTop:(UIView *)views
//{
//    CATransition *transition = nil;
//    transition = [CATransition animation];
//    transition.duration = 1.0;//kAnimationDuration
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype =kCATransitionFromTop ;
//    transition.delegate = self;
//    [views.layer addAnimation:transition forKey:nil];
//}
//
//-(void)fadeViewAnimation:(UIView *)views
//{
//    CATransition *transition = nil;
//    transition = [CATransition animation];
//    transition.duration = 1.0;//kAnimationDuration
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
//    transition.subtype =kCATransitionFromTop ;
//    transition.delegate = self;
//    [views.layer addAnimation:transition forKey:nil];
//}




@end
