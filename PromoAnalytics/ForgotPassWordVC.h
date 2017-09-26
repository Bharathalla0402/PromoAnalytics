//
//  ForgotPassWordVC.h
//  PromoAnalytics
//
//  Created by amit on 3/31/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassWordVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *emailLbl;

@property (weak, nonatomic) IBOutlet UIImageView *emailImg;

@property (weak, nonatomic) IBOutlet UITextField *emailMobTE;
@property (weak, nonatomic) IBOutlet UIView *emailTFview;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

- (IBAction)continueBtnAction:(id)sender;



- (IBAction)backButtonAction:(id)sender;


@end
