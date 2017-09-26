//
//  SidebarViewController.h
//  PromoAnalytics
//
//  Created by think360 on 12/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SidebarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profiimage;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) UIWindow *window;

@end
