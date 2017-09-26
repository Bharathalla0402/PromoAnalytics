//
//  OTPViewController.h
//  PromoAnalytics
//
//  Created by amit on 4/1/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *otp1;
@property (weak, nonatomic) IBOutlet UITextField *otp2;
@property (weak, nonatomic) IBOutlet UITextField *otp3;
@property (weak, nonatomic) IBOutlet UITextField *otp4;

@property (weak, nonatomic) IBOutlet UIButton *resendOTPbtn;




@property (weak, nonatomic) IBOutlet UILabel *labelOne;

@property (weak, nonatomic) IBOutlet UILabel *labelTwo;

@property (weak, nonatomic) IBOutlet UILabel *labelThree;

@property (weak, nonatomic) IBOutlet UILabel *labelFour;


- (IBAction)resendOTPbtnAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@property (nonatomic , retain)NSString * userIDStr;

@end
