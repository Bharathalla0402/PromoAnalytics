//
//  CouponDetailVC.h
//  PromoAnalytics
//
//  Created by amit on 3/20/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageheight;
@property (weak, nonatomic) IBOutlet UIImageView *barcodebackimage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imag2height;


@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;

@property (weak, nonatomic) IBOutlet UILabel *offerLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponCodeLbl;

@property (weak, nonatomic) IBOutlet UILabel *nameCouponLbl;

@property (weak, nonatomic) IBOutlet UIButton *favouritButton;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *validCouponLbl;

@property (weak, nonatomic) IBOutlet UILabel *aboutCouponLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageCoupon;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDetail;


- (IBAction)favouritButtonAction:(id)sender;

- (IBAction)baceButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *emailTFview;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)shareButtonAction:(id)sender;


@property (nonatomic , retain)NSString * dealidString;








@end
