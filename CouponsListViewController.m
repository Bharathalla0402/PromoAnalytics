//
//  CouponsListViewController.m
//  PromoAnalytics
//
//  Created by think360 on 26/09/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "CouponsListViewController.h"
#import "CouponCVCell.h"
#import "CouponDetailVC.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "CategoryTableViewCell.h"

@interface CouponsListViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MyProtocolDelegate,NSURLSessionDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>

{
    NSString * userID;
    
    CouponCVCell * coupaonCell;
    UICollectionViewFlowLayout*layout;
    MyProtocol*AlertController;
    
    NSString * selectedDealID;
    NSString * statusID;
    
    NSArray* nameArray;
    NSArray* logoArray;
    NSArray* favouritImagArray;
    NSArray* descriptionArray;
    NSArray* couponIDArray;
    NSArray * discountArray;
    NSArray* DateArray;
    
    
    NSString * nextPage;
    NSString * previusPage;
    
    int x;
    NSString * perCentStr;
    
    SWRevealViewController *revelview;
    UIButton *barbutt;
    UIView *frontView;
    
    UIView * popUpView;
    UIView * alertView;
    UILabel * selectLabel;
    UITableView * categoryTableView;
    CategoryTableViewCell*CatCell;
    NSString * categoryID;
    
    NSString *tzName;
    
    NSDictionary *dic;
    
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,retain)NSString*categotyString;

@property (nonatomic, strong) NSMutableArray <NSDictionary *>*savedCouponArray;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *CategoryListAry;


@end

@implementation CouponsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     perCentStr=@"%Off";
    
    dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"couponslist"];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    tzName = [timeZone name];
    
    NSLog(@"%@",tzName);

    
    userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    
    self.savedCollectionView.delegate=self;
    self.savedCollectionView.dataSource=self;
    
    
    layout=[[UICollectionViewFlowLayout alloc]init];
    [self.savedCollectionView setCollectionViewLayout:layout];
    //[layout setItemSize:CGSizeMake(self.collectionVwWallPaper.frame.size.width/2, 100)];
    layout.minimumLineSpacing=5;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    [self savedCouponApiMethod];

}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   
    
    [self savedCouponApiMethod];
  
}




#pragma mark  UnFeatured Coupon Method

-(void)savedCouponApiMethod
{
    //    x=1;
    //    NSString*pageNum=[NSString stringWithFormat:@"%d",x];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all_store/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"latitude=%@&longitude=%@&user_id=%@&time_zone=%@&store_id=%@&page=%@",[dic objectForKey:@"latitude"],[dic objectForKey:@"longitude"],userID,tzName,[dic objectForKey:@"store_id"],@"0"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody  = [profile dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            if(error){
                
                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
                {
                    [DejalBezelActivityView removeView];
                    [AlertController showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
                }
                if ([error.localizedDescription isEqualToString:@"The request timed out."])
                {
                    [DejalBezelActivityView removeView];
                }
            }
            else{
                
                [DejalBezelActivityView removeView];
                
                NSDictionary*jsonResponce = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"responce %@",jsonResponce);
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    _savedCouponArray=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
                    
                    nameArray=[_savedCouponArray valueForKey:@"name"];
                    descriptionArray=[_savedCouponArray valueForKey:@"description"];
                    logoArray=[_savedCouponArray valueForKey:@"logo"];
                    favouritImagArray=[_savedCouponArray valueForKey:@"is_fav"];
                    couponIDArray=[_savedCouponArray valueForKey:@"id"];
                    discountArray=[_savedCouponArray valueForKey:@"discount"];
                    DateArray=[_savedCouponArray valueForKey:@"datetime"];
                    
                    nextPage=[NSString stringWithFormat:@"%@" ,[[jsonResponce valueForKey:@"data"]valueForKey:@"nextPage"]];
                }
                
                if ([msgStr isEqualToString:@"0"])
                {
                    
                    _savedCouponArray=[NSMutableArray new];
                    [_savedCouponArray removeAllObjects];
                    
                    _savedCoupon.text=[NSString stringWithFormat:@" Coupons List"];
                    
                    [self.savedCollectionView reloadData];
                    
                    [AlertController showMessage:@"No Deals Found in Saved Coupon" withTitle:@"Promo Analytics"];
                    
                }
            }
            [self.savedCollectionView reloadData];
            
        }];
        
    }];
    
    [dataTask resume];
    
}


#pragma mark  CollectionView Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _savedCouponArray.count;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return CGSizeMake(self.view.frame.size.width/2-15, 150);
        
    }
    return CGSizeMake(self.view.frame.size.width/4-15, 150);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"CouponCVCell";
    
    coupaonCell = [self.savedCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    coupaonCell.cellBgrndView=[[UIView alloc]init];
    coupaonCell.cellBgrndView.frame=CGRectMake(coupaonCell.frame.size.width/2-75, 0, 150, 160);
    coupaonCell.cellBgrndView.backgroundColor=[UIColor whiteColor];
    [coupaonCell addSubview:coupaonCell.cellBgrndView];
    coupaonCell.cellBgrndView.layer.cornerRadius=1;
    [[coupaonCell.cellBgrndView layer] setBorderWidth:0.1f];
    [[coupaonCell.cellBgrndView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    coupaonCell.cellBgrndView.clipsToBounds = NO;
    coupaonCell.cellBgrndView.layer.shadowColor = [[UIColor blackColor] CGColor];
    coupaonCell.cellBgrndView.layer.shadowOffset = CGSizeMake(2,2);
    
    coupaonCell.couponImage=[[UIImageView alloc]initWithFrame:CGRectMake(coupaonCell.cellBgrndView.frame.size.width/2-25, 10, 50, 50)];
    coupaonCell.couponImage.contentMode = UIViewContentModeScaleAspectFill;
    NSString *imageUrlStr=[logoArray objectAtIndex:indexPath.row];
    [coupaonCell.couponImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"empty_coupon.png"]];
    [coupaonCell.cellBgrndView addSubview:coupaonCell.couponImage];
    
    
    coupaonCell.favouritButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coupaonCell.favouritButton.frame=CGRectMake(coupaonCell.cellBgrndView.frame.size.width-35,5, 30, 30);
    [coupaonCell.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
     [coupaonCell.favouritButton addTarget:self action:@selector(favouritSaveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [coupaonCell.cellBgrndView addSubview:coupaonCell.favouritButton];
    NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagArray objectAtIndex:indexPath.row]];
    if ([fevImgStr isEqualToString:@"1"]) {
        [coupaonCell.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
        [coupaonCell.favouritButton setSelected:NO];
        
        
    }else{
        [coupaonCell.favouritButton setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateNormal];
        [coupaonCell.favouritButton setSelected:YES];
    }
    coupaonCell.favouritButton.tag=indexPath.row;
    
    coupaonCell.flatOFFlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 63, coupaonCell.cellBgrndView.frame.size.width, 30)];
    coupaonCell.flatOFFlabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
    coupaonCell.flatOFFlabel.text=[NSString stringWithFormat:@"%@%@", [discountArray objectAtIndex:indexPath.row],perCentStr];
    coupaonCell.flatOFFlabel.numberOfLines = 1;
    coupaonCell.flatOFFlabel.textColor = [UIColor colorWithRed:54/255.0f green:70/255.0f blue:171/255.0f alpha:1.0f];
    coupaonCell.flatOFFlabel.backgroundColor=[UIColor clearColor];
    coupaonCell.flatOFFlabel.textAlignment = NSTextAlignmentCenter;
    [coupaonCell.cellBgrndView addSubview:coupaonCell.flatOFFlabel];
    
    coupaonCell.DatetimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 93, coupaonCell.cellBgrndView.frame.size.width-4, 15)];
    coupaonCell.DatetimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11];
    //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
    coupaonCell.DatetimeLabel.text=[NSString stringWithFormat:@"%@", [DateArray objectAtIndex:indexPath.row]];
    coupaonCell.DatetimeLabel.numberOfLines = 1;
    coupaonCell.DatetimeLabel.textColor = [UIColor darkGrayColor];
    coupaonCell.DatetimeLabel.backgroundColor=[UIColor clearColor];
    coupaonCell.DatetimeLabel.textAlignment = NSTextAlignmentCenter;
    [coupaonCell.cellBgrndView addSubview:coupaonCell.DatetimeLabel];
    
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 110, coupaonCell.cellBgrndView.frame.size.width, 1)];
    label.backgroundColor=[UIColor lightGrayColor];
    [coupaonCell.cellBgrndView addSubview:label];
    
    coupaonCell.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 112, coupaonCell.cellBgrndView.frame.size.width, 35)];
    coupaonCell.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
    coupaonCell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];;
    coupaonCell.nameLabel.numberOfLines = 0;
    coupaonCell.nameLabel.textColor = [UIColor darkGrayColor];
    coupaonCell.nameLabel.backgroundColor=[UIColor clearColor];
    coupaonCell.nameLabel.textAlignment = NSTextAlignmentCenter;
    [coupaonCell.cellBgrndView addSubview:coupaonCell.nameLabel];
    
    return coupaonCell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CouponDetailVC * dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"CouponDetailVC"];
    [self.navigationController pushViewController:dvc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
    dvc.dealidString=[couponIDArray objectAtIndex:indexPath.row];
}



-(void)favouritSaveButtonAction:(UIButton*)sender
{
    
    

    UICollectionViewCell * cell = (UICollectionViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.savedCollectionView indexPathForCell:cell];
    
    //    CGPoint buttonPosition = [sender convertPoint:CGPointZero
    //                                           toView:self.featuredCouponCV];
    //    NSIndexPath *tappedIP = [self.featuredCouponCV indexPathForItemAtPoint:buttonPosition];
    //    coupaonCell = [self.featuredCouponCV cellForItemAtIndexPath:tappedIP];
    
    NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagArray objectAtIndex:sender.tag]];
    
    NSLog(@"%@",fevImgStr);
    
    if ([fevImgStr isEqualToString:@"0"])
    {
        statusID=[NSString stringWithFormat:@"%@",@"1"];
    }
    else
    {
        statusID=[NSString stringWithFormat:@"%@",@"0"];
    }
    
    selectedDealID = [NSString stringWithFormat:@"%@",[couponIDArray objectAtIndex:sender.tag]];
    
    if (sender.tag== indexPath.row)
    {
        selectedDealID = [couponIDArray objectAtIndex:indexPath.row];
        
    }
    
    [self userFavoritAndUnFavoueMethod];
    
    

}




-(void)userFavoritAndUnFavoueMethod
{
    
    if ([statusID isEqualToString:@"0"])
    {
        
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Do You Want to Save this Coupon?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self yesClicked];
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
        
    }
}


-(void)yesClicked
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user_fav/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&deal_id=%@&status=%@",userID,selectedDealID,statusID]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody  = [profile dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            if(error){
                
                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
                {
                    [DejalBezelActivityView removeView];
                    [AlertController showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
                    
                }
                if ([error.localizedDescription isEqualToString:@"The request timed out."])
                {
                    [DejalBezelActivityView removeView];
                    
                    //                [AlertController showMessage:@"Your internet connection is too low please try again" withTitle:@"NetWork Error!"];
                    //          NSLog(@"%@",error.localizedDescription);
                }
            }
            else{
                
                [DejalBezelActivityView removeView];
                
                NSDictionary*jsonResponce = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    [self savedCouponApiMethod];
                }
                else {
                    
                    [coupaonCell.favouritButton setSelected:YES];
                    [AlertController showMessage:@"Coupon not removed please try again" withTitle:@"Promo Analytics"];
                    
                }
            }
        }];
        
    }];
    
    [dataTask resume];

}






- (IBAction)backButtClcicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
