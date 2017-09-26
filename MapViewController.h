//
//  MapViewController.h
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
#import "MVPlaceSearchTextField.h"
#import "SWRevealViewController.h"

@interface MapViewController : UIViewController<PlaceSearchTextFieldDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>
{
   // MVPlaceSearchTextField *_searchDropRef;
}



@property (weak, nonatomic) IBOutlet UIView *searchView;


@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *searchDropRef;

@property (weak, nonatomic) IBOutlet ACFloatingTextField *categoryTF;

@property (weak, nonatomic) IBOutlet UITextField *cityCategoryTF;


- (IBAction)categoryButtonAction:(id)sender;

- (IBAction)mapLocationButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *cityCategoryButton;

- (IBAction)citycategoryButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mapBackgrndView;

@property (strong, nonatomic) UIAlertController *alertCtrl2;

@end
