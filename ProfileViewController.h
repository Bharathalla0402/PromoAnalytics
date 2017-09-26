//
//  ProfileViewController.h
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ACFloatingTextField.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;

@property (weak, nonatomic) IBOutlet UIView *usrNmTFview;
@property (weak, nonatomic) IBOutlet UIView *DobView;
@property (weak, nonatomic) IBOutlet UIView *emailTFview;
@property (weak, nonatomic) IBOutlet UIView *phnNumTFview;
@property (weak, nonatomic) IBOutlet UIView *pwTFview;
@property (weak, nonatomic) IBOutlet UIView *reEntrPWTFview;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *DobTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPwTF;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *DobImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImage;


@property (weak, nonatomic) IBOutlet UIButton *saveProfileButton;
- (IBAction)saveProfileBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;
- (IBAction)upLoadImageButtonAction:(id)sender;

@end
