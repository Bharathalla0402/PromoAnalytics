//
//  CouponsListViewController.h
//  PromoAnalytics
//
//  Created by think360 on 26/09/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *savedCoupon;

@property (weak, nonatomic) IBOutlet UICollectionView *savedCollectionView;

@end
