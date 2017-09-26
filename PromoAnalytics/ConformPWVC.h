//
//  ConformPWVC.h
//  PromoAnalytics
//
//  Created by amit on 4/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConformPWVC : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *passWrdLbl;


@property (weak, nonatomic) IBOutlet UILabel *conformPwlabl;


@property (weak, nonatomic) IBOutlet UITextField *enterPwTF;


@property (weak, nonatomic) IBOutlet UITextField *conformPwTE;



@property (weak, nonatomic) IBOutlet UIButton *continueBtn;


- (IBAction)continueButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *passwordView;


@property (weak, nonatomic) IBOutlet UIView *conformView;


@property (weak, nonatomic) IBOutlet UIImageView *passWrdImg;
@property (weak, nonatomic) IBOutlet UIImageView *confornPwImg;



- (IBAction)backButtonAction:(id)sender;



@property (nonatomic , retain)NSString * userIDStr;



@end
