//
//  SocialRegisterVC.h
//  PromoAnalytics
//
//  Created by amit on 3/27/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialRegisterVC : UIViewController

@property(nonatomic , retain)NSString * firstNameStr;
@property(nonatomic , retain)NSString * lastNameStr;
@property(nonatomic , retain)NSString * emailNameStr;

@property (strong, nonatomic) UIWindow *window;

- (IBAction)backButtonAction:(id)sender;

@end
