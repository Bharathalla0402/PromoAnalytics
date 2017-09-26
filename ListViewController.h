//
//  ListViewController.h
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
#import "MVPlaceSearchTextField.h"

@interface ListViewController : UIViewController<PlaceSearchTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *featureCouponLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *searchDropRef;

@property (weak, nonatomic) IBOutlet UITextField *categoryTF;

//@property (weak, nonatomic) IBOutlet ACFloatingTextField *categoryTF;


@property (weak, nonatomic) IBOutlet UICollectionView *featuredCouponCV;

@property (weak, nonatomic) IBOutlet UICollectionView *couponCollectionView;

- (IBAction)cityButtonAction:(id)sender;
- (IBAction)selectCategoryButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;

- (IBAction)crossButton:(id)sender;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightLayOutCouponCV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightLayOutFutrCpnBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightLayoutCpnBackView;

@property (nonatomic,retain)NSString *categoryID;
@property (nonatomic,retain)NSString *categotyString;
@property (nonatomic,retain)NSString *strAddress;
@property (nonatomic,retain)NSString *stlatitude;
@property (nonatomic,retain)NSString *stlongitude;

@property  (nonatomic ,retain) NSString* catStrValue;
@property (nonatomic,retain)NSString * MapcategoryID;

@property (weak, nonatomic) IBOutlet UIView *featureCpnBackView;

@property (weak, nonatomic) IBOutlet UIView *couponBackView;



@end
