//
//  ListViewController.m
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "ListViewController.h"
#import "CouponCVCell.h"
#import "CouponCellTwo.h"
#import "CouponDetailVC.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "CategoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "MVPlaceSearchTextField.h"
#import "SWRevealViewController.h"
#import "MapViewController.h"

static NSString * const KMapPlacesApiKey = @"AIzaSyA9NV07HEkJtwVymm-r6hQupJqXt8MQ6UM";

@interface ListViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MyProtocolDelegate,NSURLSessionDelegate,CLLocationManagerDelegate,NSLayoutManagerDelegate,GMSAutocompleteViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>
{
    CLLocation *currentLocation;
    NSString *strLocation;
    
    MyProtocol*AlertController;
    Validation*textFieldValidation;
    
    CouponCVCell * coupaonCell;
    CouponCellTwo * coupaonCellTwo;
    
    UICollectionViewFlowLayout*layout;
    
    UICollectionViewFlowLayout*collectionLayout;
    
    CLLocationManager *locationManager;
    
    float			currentLatitude;
    float			currentLongitude;
    
    float			UserLatitude;
    float			UserLongitude;
    
    NSString * userID;
    
    UIView * popUpView;
    UIView * alertView;
    UILabel * selectLabel;
    UITableView * categoryTableView;
    CategoryTableViewCell*CatCell;
   
         
    NSArray* nameFUArray;
    NSArray* logoFUArray;
    NSArray* favouritImagFUArray;
    NSArray* descriptionFUArray;
    NSArray* couponIDfutrArray;
    NSArray* discountfutrArray;
    NSArray* DateArray;
    
    NSString * nextPage;
    NSString * previusPage;
    
    int x;
    
    NSArray* nameCouponArray;
    NSArray* logoCouponArray;
    NSArray* favouritImagCouponArray;
    NSArray* descriptionCouponArray;
    NSArray* couponIdUNfeaturedArray;
    NSArray* couponDiscountArray;
     NSArray* date2Array;
    
    NSString * nextPageY;
    NSString * previusPageY;
    
    int y;
    
    NSString *StrfaId;
    
    NSString * statusID;
    NSString * selectedDealID;
    
    NSString*currentLocationStr;
    NSArray* idArray,*categoryNameArray;
    NSString * perCentStr;
    
    int catIntValue;
    
     SWRevealViewController *revelview;
    UIButton *barbutt,*rightButt;
    UIView *frontView;
    
    NSString *str,*str2;
    
    NSString *tzName;
}
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UITabBar *mainTab;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *locaionArray;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *CategoryListAry;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *featuredCouponListAry;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *UNfeaturedCouponListAry;

@end

@implementation ListViewController

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
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    tzName = [timeZone name];
    
    NSLog(@"%@",tzName);
    
    
    //self..tag =2;
    
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    catIntValue=1;
    
    userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    self.revealViewController.delegate = self;
    
    frontView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    frontView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [frontView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [frontView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    frontView.hidden=YES;
    [self.view addSubview:frontView];
    
    
    
    textFieldValidation=[[Validation alloc]init];

    _featureCouponLabel.text=@"  Featured Coupons";
    _couponLabel.text=@"  Coupons";
    perCentStr=@"% Off";
    
   // _crossButton.hidden=YES;
    
    
     _searchDropRef.delegate=self;
    _categoryTF.delegate=self;
    
//    
//    [_cityTF setTextFieldPlaceholderText:@"City"];
//    _cityTF.btmLineColor = [UIColor whiteColor];
//    _cityTF.btmLineSelectionColor = [UIColor whiteColor];
//    _cityTF.placeHolderTextColor = [UIColor whiteColor];
//    _cityTF.selectedPlaceHolderTextColor = [UIColor whiteColor];
    
  //  [_categoryTF setTextFieldPlaceholderText:@"Category"];
  //  _categoryTF.btmLineColor = [UIColor whiteColor];
  //  _categoryTF.btmLineSelectionColor = [UIColor whiteColor];
  //  _categoryTF.placeHolderTextColor = [UIColor whiteColor];
  //  _categoryTF.selectedPlaceHolderTextColor = [UIColor whiteColor];
    
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    
    self.featuredCouponCV.delegate=self;
    self.featuredCouponCV.dataSource=self;
    
    self.couponCollectionView.delegate=self;
    self.couponCollectionView.dataSource=self;
    
    
    layout=[[UICollectionViewFlowLayout alloc]init];
    [self.featuredCouponCV setCollectionViewLayout:layout];
    layout.minimumLineSpacing=5;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    collectionLayout=[[UICollectionViewFlowLayout alloc]init];
    [self.couponCollectionView setCollectionViewLayout:collectionLayout];
    collectionLayout.minimumLineSpacing=5;
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    
    if (_stlatitude == (id)[NSNull null] || _stlatitude.length == 0 )
    {
        currentLatitude = locationManager.location.coordinate.latitude;
        currentLongitude = locationManager.location.coordinate.longitude;
    }
    else if (_stlongitude == (id)[NSNull null] || _stlongitude.length == 0 )
    {
        currentLatitude = locationManager.location.coordinate.latitude;
        currentLongitude = locationManager.location.coordinate.longitude;
    }
    else
    {
        currentLatitude = [_stlatitude floatValue];
        currentLongitude = [_stlongitude floatValue];
    }

    
   
    
    UserLatitude = locationManager.location.coordinate.latitude;
    UserLongitude = locationManager.location.coordinate.longitude;
    
//    currentLatitude=30.736238;
//    currentLongitude=76.735191;
    
//    NSLog(@"%@",_categoryID);
//    _categoryID=@"";
    
    
  
    
    
    UIImageView *leftbutt=[[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    leftbutt.image=[UIImage imageNamed:@"Menu-white.png"];
    leftbutt.contentMode=UIViewContentModeScaleAspectFit;
    [_topView addSubview:leftbutt];
    
    
    
    self.revealViewController.rearViewRevealWidth=260;
    barbutt = [UIButton buttonWithType:UIButtonTypeCustom];
    barbutt.frame=CGRectMake(0,0, 50, 60);
    [barbutt addTarget:revelview action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:barbutt];
    
    
    UIImageView *Rightimag=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-45,25, 30, 30)];
    Rightimag.image=[UIImage imageNamed:@"white_map.png"];
    Rightimag.contentMode=UIViewContentModeScaleAspectFit;
    [_topView addSubview:Rightimag];
    
    rightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt.frame=CGRectMake(self.view.frame.size.width-50,0, 50, 60);
    [rightButt addTarget:self action:@selector(RightbarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:rightButt];
    

    
    if (_categotyString == (id)[NSNull null] || _categotyString.length == 0 )
    {
         _categoryTF.text=@"All Categories";
    }
    else
    {
        _categoryTF.text=_categotyString;
        
    }
    
    if (_categoryID == (id)[NSNull null] || _categoryID.length == 0 )
    {
        _categoryID=@"";
    }
    else
    {
       // _categoryID=_categoryID;
    }
   
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
   

//    _catStrValue= [[NSUserDefaults standardUserDefaults]valueForKey:@"map"];
//    
//    
//    if ([_catStrValue isEqualToString:@"map"]) {
//        
//       // _categoryTF.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"mapCategoryName"];;
//        
//        _categoryID=[[NSUserDefaults standardUserDefaults]valueForKey:@"mapCategoryID"];
//    }
//    else{
//        _categoryID=@"";
//        
//    }
    
    [self selectCategoryApi];
    [self currentLocationMethod];
    
   
    
 //  [self featureAllDealsApi];
   [self unFeaturedCouponsApiMethod];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [frontView removeFromSuperview];
    
    frontView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    frontView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [frontView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [frontView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    frontView.hidden=YES;
    [self.view addSubview:frontView];
    
    _searchDropRef.placeSearchDelegate = self;
    _searchDropRef.strApiKey           = KMapPlacesApiKey;
    _searchDropRef.superViewOfList      = self.view;
    // View, on which Autocompletion list should be appeared.
    _searchDropRef.autoCompleteShouldHideOnSelection   = YES;
    _searchDropRef.maximumNumberOfAutoCompleteRows     = 5;
    

    
   // [locationManager requestAlwaysAuthorization];
    
     //[self selectCategoryApi];
    
   NSLog(@"%@",_categoryID);
    
    //[self selectCategoryApi];
    
    
//    _catStrValue= [[NSUserDefaults standardUserDefaults]valueForKey:@"map"];
//    
//    
//    if ([_catStrValue isEqualToString:@"map"]) {
//        
//      //  _categoryTF.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"mapCategoryName"];;
//        
//        _categoryID=[[NSUserDefaults standardUserDefaults]valueForKey:@"mapCategoryID"];
//        
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"map"];
//    }
//    else{
//        
//        if (catIntValue==1) {
//            
//        _categoryID=@"";
//       // _categoryTF.text=[categoryNameArray componentsJoinedByString: @","];
//             _categoryTF.text=@"All Categories";
//        //_crossButton.hidden=NO;
//            catIntValue=0;
//        }
//       
//    }
    
    

    [self featureAllDealsApi];
    [self unFeaturedCouponsApiMethod];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    _searchDropRef.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _searchDropRef.autoCompleteBoldFontName = @"HelveticaNeue";
    _searchDropRef.autoCompleteTableCornerRadius=0.0;
    _searchDropRef.autoCompleteRowHeight=35;
    _searchDropRef.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _searchDropRef.autoCompleteFontSize=14;
    _searchDropRef.autoCompleteTableBorderWidth=0.0;
    _searchDropRef.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _searchDropRef.autoCompleteShouldHideOnSelection=YES;
    _searchDropRef.autoCompleteShouldHideClosingKeyboard=YES;
    _searchDropRef.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _searchDropRef.autoCompleteTableFrame = CGRectMake(_searchDropRef.frame.origin.x-2, _searchDropRef.frame.size.height+75.0, self.searchDropRef.frame.size.width+4, 200.0);
}




#pragma mark  Side bar button  Method

-(void)SidebarBtnAction:(UIButton*)sender
{
    [self.revealViewController revealToggle:sender];
}


- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        
        frontView.hidden=YES;
    } else {
        
        frontView.hidden=NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        
        frontView.hidden=YES;
    } else {
        
        frontView.hidden=NO;
    }
}


-(void)RightbarBtnAction:(UIButton*)sender
{
    MapViewController *list=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:list animated:YES];
    
    
    str= [NSString stringWithFormat:@"%f", currentLatitude];
    str2= [NSString stringWithFormat:@"%f", currentLongitude];
    
    [[NSUserDefaults standardUserDefaults]setObject:_categoryTF.text forKey:@"categotyString"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:_categoryID forKey:@"categoryID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:_searchDropRef.text forKey:@"strAddress"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"stlatitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str2 forKey:@"stlongitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)viewWillDisappear:(BOOL)animated
{
    str= [NSString stringWithFormat:@"%f", currentLatitude];
    str2= [NSString stringWithFormat:@"%f", currentLongitude];
    
    [[NSUserDefaults standardUserDefaults]setObject:_categoryTF.text forKey:@"categotyString"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:_categoryID forKey:@"categoryID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:_searchDropRef.text forKey:@"strAddress"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"stlatitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str2 forKey:@"stlongitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict
{
    [self.view endEditing:YES];
    
//    citynameStr=_searchDropRef.text;
//    
//    _cityCategoryTF.text=citynameStr;
    
   // _categotyString=@"";
  //  _categoryID=@"";
  //  _categoryTF.text=@"All Categories";
    
    
    [self getLattitudeAndLongitude];
}


-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField
{
    
}

-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField
{
    
}

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index
{
    
    if(index%2==0){
        
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
    }else{
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    }
}



#pragma mark  Featured Coupon Method

-(void)featureAllDealsApi
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];

    x=1;
    NSString*pageNum=[NSString stringWithFormat:@"%d",x];


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all/",BaseUrl]]];
    NSLog(@"%@",request);
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"category=%@&latitude=%f&longitude=%f&feature=%@&user_id=%@&page=%@&time_zone=%@",_categoryID,currentLatitude,currentLongitude,@"1",userID,pageNum,tzName]];
    NSLog(@"%@",profile);
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
                
               NSLog(@" Featurev responce %@",jsonResponce);
                
            NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
            
            _featuredCouponListAry=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
            
            if ([msgStr isEqualToString:@"1"]) {
                
              
                self.hightLayOutFutrCpnBackView.constant=180;
        
                [self.featureCpnBackView layoutIfNeeded];
                
                
                nameFUArray=[_featuredCouponListAry valueForKey:@"name"];
                 descriptionFUArray=[_featuredCouponListAry valueForKey:@"description"];
                logoFUArray=[_featuredCouponListAry valueForKey:@"logo"];
                favouritImagFUArray=[_featuredCouponListAry valueForKey:@"is_fav"];
                couponIDfutrArray=[_featuredCouponListAry valueForKey:@"id"];
                discountfutrArray=[_featuredCouponListAry valueForKey:@"discount"];
                DateArray=[_featuredCouponListAry valueForKey:@"datetime"];
                
                nextPage=[NSString stringWithFormat:@"%@" ,[[jsonResponce valueForKey:@"data"]valueForKey:@"nextPage"]];
              
                
            }
            
            if ([msgStr isEqualToString:@"0"]) {
                
                _featuredCouponListAry=[NSMutableArray new];
                [self.featuredCouponCV reloadData];
            
                self.hightLayOutFutrCpnBackView.constant=1;
            }

                
            }
        [_featuredCouponCV reloadData];
        
        }];
        
    }];
    
    [dataTask resume];
    
    
}

#pragma mark  Coupon Method

-(void)unFeaturedCouponsApiMethod
{
    
    
    y=1;
    NSString*pageNum=[NSString stringWithFormat:@"%d",y];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all/",BaseUrl]]];
    NSLog(@"%@",request);
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"category=%@&latitude=%f&longitude=%f&feature=%@&user_id=%@&page=%@&time_zone=%@",_categoryID,currentLatitude,currentLongitude,@"0",userID,pageNum,tzName]];
    NSLog(@"%@",profile);
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
                
             NSLog(@"Un Featured First responce %@",jsonResponce);
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                _UNfeaturedCouponListAry=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    
                    self.hightLayoutCpnBackView.constant=180;
                    
                    nameCouponArray=[_UNfeaturedCouponListAry valueForKey:@"name"];
                    descriptionCouponArray=[_UNfeaturedCouponListAry valueForKey:@"description"];
                    logoCouponArray=[_UNfeaturedCouponListAry valueForKey:@"logo"];
                    favouritImagCouponArray=[_UNfeaturedCouponListAry valueForKey:@"is_fav"];
                    couponIdUNfeaturedArray=[_UNfeaturedCouponListAry valueForKey:@"id"];
                     couponDiscountArray=[_UNfeaturedCouponListAry valueForKey:@"discount"];
                    date2Array=[_UNfeaturedCouponListAry valueForKey:@"datetime"];
                    
                    nextPageY=[NSString stringWithFormat:@"%@" ,[[jsonResponce valueForKey:@"data"]valueForKey:@"nextPage"]];
                    
                    
//                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//                    {
                        if (_UNfeaturedCouponListAry.count %2)
                    {
                        self.hightLayOutCouponCV.constant=_UNfeaturedCouponListAry.count/2*150+150;
                    self.hightLayoutCpnBackView.constant=_UNfeaturedCouponListAry.count/2*180+180;
                    
                    }
                    else
                    {
                        self.hightLayOutCouponCV.constant=_UNfeaturedCouponListAry.count/2*150;
                         self.hightLayoutCpnBackView.constant=_UNfeaturedCouponListAry.count/2*180;
                    }

                    //}
                                        
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    [self.couponBackView layoutIfNeeded];
                   
                    self.hightLayoutCpnBackView.constant=1;

                    [self.couponCollectionView reloadData];
                    
                    if (_featuredCouponListAry.count==0) {
                        
                        if ( _UNfeaturedCouponListAry.count==0) {
                            
                [AlertController showMessage:[NSString stringWithFormat:@"No Coupons available in %@",_searchDropRef.text] withTitle:@"Promo Analytics"];
                        }
                    }
                    
                }
                
            }
            [_couponCollectionView reloadData];
            
        }];
        
    }];
    
    [dataTask resume];
  
    
}


#pragma mark  CollectionView Delegates


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [collectionView numberOfSections]-1;
    NSInteger lastRowIndex = [collectionView numberOfItemsInSection:lastSectionIndex]-1;
    
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
    {
        

        if (collectionView==_featuredCouponCV) {
            if (nextPage==0)
            {
                //NSLog(@"%ld",(long)nextPage.integerValue);
                
            }
            else if (nextPage.integerValue==x+1)
            {
                
                x+=1;
                NSString*pageNum=[NSString stringWithFormat:@"%d",x];
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all/",BaseUrl]]];
                request.HTTPMethod = @"POST";
                NSMutableString* profile = [NSMutableString string];
                [profile appendString:[NSString stringWithFormat:@"category=%@&latitude=%f&longitude=%f&feature=%@&user_id=%@&page=%@&time_zone=%@",_categoryID,currentLatitude,currentLongitude,@"1",userID,pageNum,tzName]];
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
                            
                             self.hightLayOutFutrCpnBackView.constant=180;
                            
                            [DejalBezelActivityView removeView];
                            
                            NSDictionary*jsonResponce = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            
                       //     NSLog(@"responce %@",jsonResponce);
                            
                            NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                            
                            if ([msgStr isEqualToString:@"1"]) {
                                
                                
                                NSArray *myArray=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
                                
                                _featuredCouponListAry=[[_featuredCouponListAry arrayByAddingObjectsFromArray:myArray] mutableCopy];
                                
                                nameFUArray=[_featuredCouponListAry valueForKey:@"name"];
                                descriptionFUArray=[_featuredCouponListAry valueForKey:@"description"];
                                logoFUArray=[_featuredCouponListAry valueForKey:@"logo"];
                                favouritImagFUArray=[_featuredCouponListAry valueForKey:@"is_fav"];
                                couponIDfutrArray=[_featuredCouponListAry valueForKey:@"id"];
                                discountfutrArray=[_featuredCouponListAry valueForKey:@"discount"];
                                DateArray=[_featuredCouponListAry valueForKey:@"datetime"];
                                
                                nextPage=[NSString stringWithFormat:@"%@" ,[[jsonResponce valueForKey:@"data"]valueForKey:@"nextPage"]];
                            }
                            
                            if ([msgStr isEqualToString:@"0"]) {
                                
                                _featuredCouponListAry=[NSMutableArray new];
                                [_featuredCouponListAry removeAllObjects];
                                
                                [self.featuredCouponCV reloadData];
                                
                                 self.hightLayOutFutrCpnBackView.constant=0;
                                
                            }
                            
                            
                        }
                        [_featuredCouponCV reloadData];
                        
                    }];
                    
                }];
                
                [dataTask resume];

                
            }
        }
      
        
        else{
            
            
            if (nextPageY==0)
            {
                
                //NSLog(@"%ld",(long)nextPage.integerValue);
                
            }
            else if (nextPageY.integerValue==x+1)
            {
                y+=1;
                NSString*pageNum=[NSString stringWithFormat:@"%d",y];
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all/",BaseUrl]]];
                request.HTTPMethod = @"POST";
                NSMutableString* profile = [NSMutableString string];
                [profile appendString:[NSString stringWithFormat:@"category=%@&latitude=%f&longitude=%f&feature=%@&user_id=%@&page=%@&time_zone=%@",_categoryID,currentLatitude,currentLongitude,@"0",userID,pageNum,tzName]];
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
                            
                            NSLog(@"Collection view responce %@",jsonResponce);
                            
                            NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                            
                            if ([msgStr isEqualToString:@"1"]) {
                                
                                
                                NSArray *myArray=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
                                
                                _UNfeaturedCouponListAry=[[_UNfeaturedCouponListAry arrayByAddingObjectsFromArray:myArray] mutableCopy];
                                
                                //                                _featuredCouponListAry=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
                                
                                nameCouponArray=[_UNfeaturedCouponListAry valueForKey:@"name"];
                                descriptionCouponArray=[_UNfeaturedCouponListAry valueForKey:@"description"];
                                logoCouponArray=[_UNfeaturedCouponListAry valueForKey:@"logo"];
                                favouritImagCouponArray=[_UNfeaturedCouponListAry valueForKey:@"is_fav"];
                                couponIdUNfeaturedArray=[_UNfeaturedCouponListAry valueForKey:@"id"];
                                 couponDiscountArray=[_UNfeaturedCouponListAry valueForKey:@"discount"];
                                date2Array=[_UNfeaturedCouponListAry valueForKey:@"datetime"];
                                
                                nextPageY=[NSString stringWithFormat:@"%@" ,[[jsonResponce valueForKey:@"data"]valueForKey:@"nextPage"]];
                                
                                
                                if (_UNfeaturedCouponListAry.count %2)
                                {
                                    self.hightLayOutCouponCV.constant=_UNfeaturedCouponListAry.count/2*150+150;
                                    self.hightLayoutCpnBackView.constant=_UNfeaturedCouponListAry.count/2*180+180;
                                 
                                }
                                else
                                {
                                     self.hightLayOutCouponCV.constant=_UNfeaturedCouponListAry.count/2*150;
                                    self.hightLayoutCpnBackView.constant=_UNfeaturedCouponListAry.count/2*180;
                                    
                                }

                            }
                            
                            if ([msgStr isEqualToString:@"0"]) {
                                
                              
                                _UNfeaturedCouponListAry=[NSMutableArray new];
                                [_UNfeaturedCouponListAry removeAllObjects];
                                
                                [self.couponCollectionView reloadData];
                                
                              //  [AlertController showMessage:@"No Deal Found in Coupon" withTitle:@"Promo Analytics"];
                            }
                            
                        }
                        [_couponCollectionView reloadData];
                        
                    }];
                    
                }];
                
                [dataTask resume];
                
            }
    
        }
        
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView==_featuredCouponCV)
    {
        return _featuredCouponListAry.count;
    }
   else
   {
        return _UNfeaturedCouponListAry.count;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==_featuredCouponCV)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            return CGSizeMake(self.view.frame.size.width/2.15-10, 150);
            
        }
        return CGSizeMake(self.view.frame.size.width/3.15-10, 150);
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            return CGSizeMake(self.view.frame.size.width/2-15, 150);
            
        }
        return CGSizeMake(self.view.frame.size.width/4-15, 150);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0f;
}
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self.featuredCouponCV performBatchUpdates:nil completion:nil];
//}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
    
    if (_featuredCouponCV== collectionView)
    {
        
        static NSString *identifier = @"CouponCVCell";
        coupaonCell = [self.featuredCouponCV dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
       
        
        coupaonCell.cellBgrndView=[[UIView alloc]init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            coupaonCell.cellBgrndView.frame=CGRectMake(5, 0, self.view.frame.size.width/2.15-15, 160);
        }
        else
        {
            coupaonCell.cellBgrndView.frame=CGRectMake(5, 0, self.view.frame.size.width/3.15-15, 160);
        }
        coupaonCell.cellBgrndView.backgroundColor=[UIColor whiteColor];
        [coupaonCell addSubview:coupaonCell.cellBgrndView];
        coupaonCell.cellBgrndView.layer.cornerRadius=1;
        [[coupaonCell.cellBgrndView layer] setBorderWidth:0.1f];
        [[coupaonCell.cellBgrndView layer] setBorderColor:[UIColor clearColor].CGColor];
        coupaonCell.cellBgrndView.clipsToBounds = NO;
        coupaonCell.cellBgrndView.layer.shadowColor = [[UIColor blackColor] CGColor];
        coupaonCell.cellBgrndView.layer.shadowOffset = CGSizeMake(2,2);
        
        coupaonCell.couponImage=[[UIImageView alloc]initWithFrame:CGRectMake(coupaonCell.cellBgrndView.frame.size.width/2-25, 10, 50, 50)];
//        coupaonCell.couponImage.image=[UIImage imageNamed:@"MC"];
        NSString *imageUrlStr=[logoFUArray objectAtIndex:indexPath.row];
        [coupaonCell.couponImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"empty_coupon.png"]];
        coupaonCell.couponImage.contentMode = UIViewContentModeScaleAspectFill;
        [coupaonCell.cellBgrndView addSubview:coupaonCell.couponImage];
        
        
        coupaonCell.favouritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coupaonCell.favouritButton.frame=CGRectMake(coupaonCell.cellBgrndView.frame.size.width-35,5, 30, 30);
        [coupaonCell.favouritButton addTarget:self action:@selector(featureFavouritButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [coupaonCell.cellBgrndView addSubview:coupaonCell.favouritButton];
        NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagFUArray objectAtIndex:indexPath.row]];
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
        coupaonCell.flatOFFlabel.text=[NSString stringWithFormat:@"%@%@", [discountfutrArray objectAtIndex:indexPath.row],perCentStr];
        coupaonCell.flatOFFlabel.numberOfLines = 1;
        coupaonCell.flatOFFlabel.textColor = [UIColor colorWithRed:54/255.0f green:70/255.0f blue:171/255.0f alpha:1.0f];
        coupaonCell.flatOFFlabel.backgroundColor=[UIColor clearColor];
        coupaonCell.flatOFFlabel.textAlignment = NSTextAlignmentCenter;
        [coupaonCell.cellBgrndView addSubview:coupaonCell.flatOFFlabel];
        
        
        
        coupaonCell.DatetimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 93, coupaonCell.cellBgrndView.frame.size.width-4, 15)];
        coupaonCell.DatetimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
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
        
        coupaonCell.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 112, coupaonCell.cellBgrndView.frame.size.width-4, 35)];
        coupaonCell.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
        coupaonCell.nameLabel.text=[nameFUArray objectAtIndex:indexPath.row];
        coupaonCell.nameLabel.numberOfLines = 0;
        coupaonCell.nameLabel.textColor = [UIColor darkGrayColor];
        coupaonCell.nameLabel.backgroundColor=[UIColor clearColor];
        coupaonCell.nameLabel.textAlignment = NSTextAlignmentCenter;
        [coupaonCell.cellBgrndView addSubview:coupaonCell.nameLabel];
        
        return coupaonCell;
    }
    else
    {

        static NSString *identifier = @"CouponCellTwo";
        coupaonCellTwo = [self.couponCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
         
        
        coupaonCellTwo.cellBgrndView=[[UIView alloc]init];
        coupaonCellTwo.cellBgrndView.frame=CGRectMake(coupaonCellTwo.frame.size.width/2-75, 0, 150, 160);
        coupaonCellTwo.cellBgrndView.backgroundColor=[UIColor whiteColor];
        [coupaonCellTwo addSubview:coupaonCellTwo.cellBgrndView];
        coupaonCellTwo.cellBgrndView.layer.cornerRadius=1;
        [[coupaonCellTwo.cellBgrndView layer] setBorderWidth:0.1f];
        [[coupaonCellTwo.cellBgrndView layer] setBorderColor:[UIColor clearColor].CGColor];
        coupaonCellTwo.cellBgrndView.clipsToBounds = NO;
        coupaonCellTwo.cellBgrndView.layer.shadowColor = [[UIColor blackColor] CGColor];
        coupaonCellTwo.cellBgrndView.layer.shadowOffset = CGSizeMake(2,2);
        
        coupaonCellTwo.couponImage=[[UIImageView alloc]initWithFrame:CGRectMake(coupaonCellTwo.cellBgrndView.frame.size.width/2-25, 10, 50, 50)];
        //coupaonCellTwo.couponImage.image=[UIImage imageNamed:@"MC"];
        NSString *imageUrlStr=[logoCouponArray objectAtIndex:indexPath.row];
        [coupaonCellTwo.couponImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"empty_coupon.png"]];
        coupaonCellTwo.couponImage.contentMode = UIViewContentModeScaleAspectFill;
        [coupaonCellTwo.cellBgrndView addSubview:coupaonCellTwo.couponImage];
        
        
        
        coupaonCellTwo.favouritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coupaonCellTwo.favouritButton.frame=CGRectMake(coupaonCellTwo.cellBgrndView.frame.size.width-35,5, 30, 30);
        //[coupaonCellTwo.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
        [coupaonCellTwo.favouritButton addTarget:self action:@selector(couponFavouritButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [coupaonCellTwo.cellBgrndView addSubview:coupaonCellTwo.favouritButton];
        NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagCouponArray objectAtIndex:indexPath.row]];
        if ([fevImgStr isEqualToString:@"1"]) {
            [coupaonCellTwo.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
            [coupaonCellTwo.favouritButton setSelected:NO];
        }else{
            [coupaonCellTwo.favouritButton setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateNormal];
            [coupaonCellTwo.favouritButton setSelected:YES];
        }
        coupaonCellTwo.favouritButton.tag=indexPath.row;
        
        
        
        coupaonCellTwo.flatOFFlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 63, coupaonCellTwo.cellBgrndView.frame.size.width, 30)];
        coupaonCellTwo.flatOFFlabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
        coupaonCellTwo.flatOFFlabel.text=[NSString stringWithFormat:@"%@%@",[couponDiscountArray objectAtIndex:indexPath.row],perCentStr];
        coupaonCellTwo.flatOFFlabel.numberOfLines = 1;
        coupaonCellTwo.flatOFFlabel.textColor = [UIColor colorWithRed:54/255.0f green:70/255.0f blue:171/255.0f alpha:1.0f];
        coupaonCellTwo.flatOFFlabel.backgroundColor=[UIColor clearColor];
        coupaonCellTwo.flatOFFlabel.textAlignment = NSTextAlignmentCenter;
        [coupaonCellTwo.cellBgrndView addSubview:coupaonCellTwo.flatOFFlabel];
        
        
        coupaonCellTwo.DatetimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 93, coupaonCellTwo.cellBgrndView.frame.size.width-4, 15)];
        coupaonCellTwo.DatetimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11];
        //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
        coupaonCellTwo.DatetimeLabel.text=[NSString stringWithFormat:@"%@", [  [_UNfeaturedCouponListAry valueForKey:@"datetime"] objectAtIndex:indexPath.row]];
        coupaonCellTwo.DatetimeLabel.numberOfLines = 1;
        coupaonCellTwo.DatetimeLabel.textColor = [UIColor darkGrayColor];
        coupaonCellTwo.DatetimeLabel.backgroundColor=[UIColor clearColor];
        coupaonCellTwo.DatetimeLabel.textAlignment = NSTextAlignmentCenter;
        [coupaonCellTwo.cellBgrndView addSubview:coupaonCellTwo.DatetimeLabel];
        
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 110, coupaonCellTwo.cellBgrndView.frame.size.width, 1)];
        label.backgroundColor=[UIColor lightGrayColor];
        [coupaonCellTwo.cellBgrndView addSubview:label];
        
        coupaonCellTwo.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 112, coupaonCellTwo.cellBgrndView.frame.size.width-4, 35)];
        coupaonCellTwo.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        //collectionCell.discountLabel.font = [UIFont systemFontOfSize:25];
        coupaonCellTwo.nameLabel.text=[[_UNfeaturedCouponListAry valueForKey:@"name"] objectAtIndex:indexPath.row];
        coupaonCellTwo.nameLabel.numberOfLines = 0;
        coupaonCellTwo.nameLabel.textColor = [UIColor darkGrayColor];
        coupaonCellTwo.nameLabel.backgroundColor=[UIColor clearColor];
        coupaonCellTwo.nameLabel.textAlignment = NSTextAlignmentCenter;
        [coupaonCellTwo.cellBgrndView addSubview:coupaonCellTwo.nameLabel];
        
    
        return coupaonCellTwo;
    }
    
//    }else{
////    }
//    else{
//        
//        return 0;
//    }
//    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     [self.view endEditing:YES];
    
    if (collectionView==_featuredCouponCV) {
        
        
        CouponDetailVC * dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"CouponDetailVC"];
        [self.navigationController pushViewController:dvc animated:YES];
        
        dvc.dealidString=[NSString stringWithFormat:@"%@",[couponIDfutrArray objectAtIndex:indexPath.row]];
        
    }
    else{
        
        CouponDetailVC * dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"CouponDetailVC"];
        [self.navigationController pushViewController:dvc animated:YES];
        dvc.dealidString=[NSString stringWithFormat:@"%@",[couponIdUNfeaturedArray objectAtIndex:indexPath.row]];
    }
    
}

#pragma mark  Favourit method and ButtonActions

-(void)featureFavouritButtonAction:(UIButton*)sender
{
    
    StrfaId=@"1";
    
     UICollectionViewCell * cell = (UICollectionViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.featuredCouponCV indexPathForCell:cell];

//    CGPoint buttonPosition = [sender convertPoint:CGPointZero
//                                           toView:self.featuredCouponCV];
//    NSIndexPath *tappedIP = [self.featuredCouponCV indexPathForItemAtPoint:buttonPosition];
//    coupaonCell = [self.featuredCouponCV cellForItemAtIndexPath:tappedIP];
    
    NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagFUArray objectAtIndex:sender.tag]];
    
    NSLog(@"%@",fevImgStr);
    
    if ([fevImgStr isEqualToString:@"0"])
    {
        statusID=[NSString stringWithFormat:@"%@",@"1"];
    }
    else
    {
        statusID=[NSString stringWithFormat:@"%@",@"0"];
    }
    
    selectedDealID = [NSString stringWithFormat:@"%@",[couponIDfutrArray objectAtIndex:sender.tag]];
    
    if (sender.tag== indexPath.row)
    {
        selectedDealID = [couponIDfutrArray objectAtIndex:indexPath.row];
        
    }
    
      [self userFavoritAndUnFavoueMethod];
    
//    if ([sender isSelected])
//    {
//       // [sender setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
//        
//        statusID=@"1";
//      
//        //[self.featuredCouponCV reloadData];
//        
//    } else {
//       // [sender setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
//        
//        statusID=@"0";
//        [self userFavoritAndUnFavoueMethod];
//    }

}


-(void)couponFavouritButtonAction:(UIButton*)sender
{
      StrfaId=@"2";
    
    UICollectionViewCell * cell = (UICollectionViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.couponCollectionView indexPathForCell:cell];
    
    if (sender.tag== indexPath.row)
    {
        selectedDealID = [couponIdUNfeaturedArray objectAtIndex:indexPath.row];
        
    }
    selectedDealID = [NSString stringWithFormat:@"%@",[couponIdUNfeaturedArray objectAtIndex:sender.tag]];
    
    NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagCouponArray objectAtIndex:sender.tag]];
    
    NSLog(@"%@",fevImgStr);
    
    if ([fevImgStr isEqualToString:@"0"])
    {
        statusID=[NSString stringWithFormat:@"%@",@"1"];
    }
    else
    {
      statusID=[NSString stringWithFormat:@"%@",@"0"];
    }
    
   
    
    
    [self userFavoritAndUnFavoueMethod];
    
//    if ([sender isSelected])
//    {
//      //  [sender setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
//        
//        statusID=@"1";
//         [self userFavoritAndUnFavoueMethod];
//        
//        
//    } else {
//        
//        NSLog(@"%@",sender);
//        
//       // [sender setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
//        
//        statusID=@"0";
//        
//        [self userFavoritAndUnFavoueMethod];
//        
//    }
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
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&deal_id=%@&status=%@&address=%@&latitude=%f&longitude=%f",userID,selectedDealID,statusID,strLocation,UserLatitude,UserLongitude]];
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
                
                //  NSLog(@"responce %@",jsonResponce);
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    
                    if ([StrfaId isEqualToString:@"1"])
                    {
                        [self featureAllDealsApi];
                    }
                    else
                    {
                        [self unFeaturedCouponsApiMethod];
                    }
                    
                    
                    [AlertController showMessage:@"Coupon added to saved list." withTitle:@"Promo Analytics"];
                    
                }
                if ([msgStr isEqualToString:@"Remove success"]) {
                    
                    //  [AlertController showMessage:@"Coupon successfully removed from saved list." withTitle:@"Promo Analytics"];
                    
                }
            }
        }];
        
    }];
    
    [dataTask resume];
    

}





#pragma mark  UITextfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_categoryTF==textField) {
        [(ACFloatingTextField *)textField textFieldDidBeginEditing];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_categoryTF==textField) {
        [(ACFloatingTextField *)textField textFieldDidEndEditing];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissKeyboard
{
    
   // [_cityTF resignFirstResponder];
    [_categoryTF resignFirstResponder];
    [self.view endEditing:YES];
 
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.view.tag == 1)
    {
        [self.view endEditing:YES];
        popUpView.hidden=YES;
    }
    if(touch.view.tag == 2)
    {
        [self.view endEditing:YES];
       
    }
    
    
}


//#pragma mark  - GMSAutocompleteFetcherDelegate --
//
//
//- (IBAction)cityButtonAction:(id)sender {
//    
//    
//    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
//    acController.delegate = self;
//    [self presentViewController:acController animated:YES completion:nil];
//    
//}
//
//
//-(void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
//
//{
//
//    
//    _cityTF.text=place.name;
//    
//    [self getLattitudeAndLongitude];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)wasCancelled:(GMSAutocompleteViewController *)viewController{
//    
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//
//- (void)viewController:(GMSAutocompleteViewController *)viewController
//didFailAutocompleteWithError:(NSError *)error {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    //NSLog(@"Error: %@", [error description]);
//}
//- (void)didFailAutocompleteWithError:(NSError *)error {
//    
//    //NSString*errorStr = [NSString stringWithFormat:@"%@", error.localizedDescription];
//    //NSLog(@"%@",errorStr);
//}
//// Turn the network activity indicator on and off again.
//- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//}
//
//- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//}
//

-(void)getLattitudeAndLongitude
{
    
    NSString * nameStr=_searchDropRef.text;
    
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"[&@!?.,' ]+" withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, nameStr.length)];
    
    NSString * urlString =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",nameStr];
    
    NSURL * url=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse * response;
    NSError * error;
    
    NSData * responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //   NSLog(@"Error %@",error.localizedDescription);
    //   NSLog(@"URL Responce %@",response);
    //    NSString * outputData=[[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    if (responseData==nil) {
        
         [AlertController showMessage:@"City not found" withTitle:@"Promo Analytics"];

        
    }else{
        NSDictionary  *googleAPIresponce = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:Nil];
        
        NSString * statusStr=[googleAPIresponce valueForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            
            _locaionArray=[googleAPIresponce valueForKey:@"results"];
            
            currentLatitude=[NSString stringWithFormat:@"%@",[[[[_locaionArray objectAtIndex:0] valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lat"]].floatValue;
            
            currentLongitude=[NSString stringWithFormat:@"%@",[[[[_locaionArray objectAtIndex:0] valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lng"]].floatValue;
            
            
            NSString* arrStr=_searchDropRef.text;
            NSArray * LocArry=[arrStr componentsSeparatedByString:@","];
            NSString * firStr = [LocArry objectAtIndex:0];
           // NSLog(@"%@",firStr);
            
            
            
            _featureCouponLabel.text=[NSString stringWithFormat:@"  Featured Coupons In %@",firStr];
            
            _couponLabel.text=[NSString stringWithFormat:@"  Coupons In %@",firStr];
            
            [self featureAllDealsApi];
            [self unFeaturedCouponsApiMethod];
            
        }else{
            
              [AlertController showMessage:@"City not found" withTitle:@"Promo Analytics"];
            }
        
       }
    
}

#pragma mark  SelectCategoryButtonAction

- (IBAction)selectCategoryButtonAction:(id)sender {
    
     [self.view endEditing:YES];
    
    [self popUpViewMethod];
    
    categoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, alertView.frame.size.width, 300) style:UITableViewStylePlain];
    [alertView addSubview:categoryTableView];
    categoryTableView.estimatedRowHeight=44;
    categoryTableView.delegate=self;
    categoryTableView.dataSource=self;
    selectLabel.text=@"All Categories";
  
    //[self selectCategoryApi];
}

- (IBAction)crossButton:(id)sender {
    
    //_crossButton.hidden=YES;
    _categoryTF.text=@"All Categories";
}


-(void)selectCategoryApi
{
    
    //[DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_category/",BaseUrl]]];

    NSMutableString* profile = [NSMutableString string];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody  = [profile dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *configuration =     [NSURLSessionConfiguration defaultSessionConfiguration];
    // configuration.timeoutIntervalForRequest = 30.0;
    // configuration.timeoutIntervalForResource=60;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            
            
            if(error){
                
                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
                {
                    [DejalBezelActivityView removeView];
                    [AlertController showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
                    
                    //NSLog(@"%@",error.localizedDescription);
                    
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
                
                
                _CategoryListAry=[jsonResponce valueForKey:@"data"];
                
                idArray=[_CategoryListAry valueForKey:@"id"];
                
                categoryNameArray=[_CategoryListAry valueForKey:@"name"];
                
                
                
                if (_categotyString == (id)[NSNull null] || _categotyString.length == 0 )
                {
                    _categoryTF.text=@"All Categories";
                }
                else
                {
                    _categoryTF.text=_categotyString;
                }
                
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
}


-(void)popUpViewMethod
{
    
    popUpView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    popUpView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7f];
    [self.view addSubview:popUpView];
    popUpView.tag=1;
    
    alertView=[[UIView alloc]initWithFrame:CGRectMake(popUpView.frame.size.width/2-140, popUpView.frame.size.height/2-175, 280, 350)];
    alertView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [popUpView addSubview:alertView];
    alertView.layer.cornerRadius=5;
    [[alertView layer] setBorderWidth:1.0f];
    [[alertView layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    alertView.clipsToBounds=YES;
    
    selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertView.frame.size.width, 45)];
    selectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    selectLabel.numberOfLines = 1;
    selectLabel.backgroundColor = [UIColor colorWithRed:228.0/255.0f green:59.0/255.0f blue:48.0/255.0f alpha:1.0];
    selectLabel.textColor = [UIColor whiteColor];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:selectLabel];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, alertView.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [alertView addSubview:lineLabel];
    
}


#pragma mark  TableView Delidates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _CategoryListAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier= @"CategotyCell";
    CatCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (CatCell == nil)
    {
        CatCell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
    CatCell.cellCatImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
    CatCell.cellCatImage.image=[UIImage imageNamed:@"De-select"] ;
    [CatCell addSubview:CatCell.cellCatImage];
    
    CatCell.cellCategorylabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 180, 45)];
    CatCell.cellCategorylabel.text=[[_CategoryListAry valueForKey:@"name"]objectAtIndex:indexPath.row];        CatCell.cellCategorylabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    CatCell.cellCategorylabel.numberOfLines = 1;
    CatCell.cellCategorylabel.backgroundColor = [UIColor clearColor];
    CatCell.cellCategorylabel.textColor = [UIColor blackColor];
    CatCell.cellCategorylabel.textAlignment = NSTextAlignmentLeft;
    [CatCell addSubview:CatCell.cellCategorylabel];
    
    
    if ([_categotyString isEqualToString:[[_CategoryListAry valueForKey:@"name"]objectAtIndex:indexPath.row]])
    {
        CatCell.cellCatImage.image=[UIImage imageNamed:@"Select"] ;
    }
    
    
    
    return CatCell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    _categotyString=[[_CategoryListAry valueForKey:@"name"]objectAtIndex:indexPath.row];
    _categoryID=[[_CategoryListAry valueForKey:@"id"]objectAtIndex:indexPath.row];
    
    _categoryTF.text=_categotyString;
    
    popUpView.hidden=YES;
    
    
    [self featureAllDealsApi];
    [self unFeaturedCouponsApiMethod];
    
}


#pragma mark  - Current Location Brtton Action -

-(void)currentLocationMethod
{
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    
    
    if (networkStatus == NotReachable)
    {
        
        
       [AlertController showMessage:@"Please check your mobile Data/WiFi" withTitle:@"NetWork Error!"];
        
    }
    else
    {
        
        if (_strAddress == (id)[NSNull null] || _strAddress.length == 0 )
        {
            
            [locationManager requestWhenInUseAuthorization];
            
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
            
            
            [self.view endEditing:YES];
            
            
            [DejalBezelActivityView activityViewForView:popUpView withLabel:@"Loading..."];
            
            if([CLLocationManager locationServicesEnabled] &&
               [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
            {
                
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder reverseGeocodeLocation:locationManager.location
                               completionHandler:^(NSArray *placemarks, NSError *error) {
                                   // NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                                   
                                   if (error){
                                       
                                       [DejalBezelActivityView removeView];
                                       
                                       [AlertController showMessage:@"Please try again." withTitle:@"NetWork Error!"];
                                       
                                       //return;
                                       
                                   }
                                   
                                   //NSLog(@"placemarks=%@",[placemarks objectAtIndex:0]);
                                   
                                   CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                   
                                   
                                   
                                   NSString *strf=[NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.locality];
                                   
                                   if (strf == (id)[NSNull null] || strf.length == 0 )
                                   {
                                       currentLocationStr=@"";
                                   }
                                   else
                                   {
                                       NSString *str1=[NSString stringWithFormat:@"%@",placemark.subLocality];
                                       
                                       if (str1 == (id)[NSNull null] || str1.length == 0 || [str1 isEqualToString:@"(null)"] )
                                       {
                                           NSString *str1=[NSString stringWithFormat:@"%@",placemark.locality];
                                           
                                           if (str1 == (id)[NSNull null] || str1.length == 0 )
                                           {
                                               
                                               
                                               _searchDropRef.placeholder=@"Please Select Location";
                                           }
                                           else
                                           {
                                               currentLocationStr=[NSString stringWithFormat:@"%@",placemark.locality];
                                               
                                           }
                                       }
                                       else
                                       {
                                           NSString *str1=[NSString stringWithFormat:@"%@",placemark.locality];
                                           
                                           if (str1 == (id)[NSNull null] || str1.length == 0 || [str1 isEqualToString:@"(null)"])
                                           {
                                               currentLocationStr=[NSString stringWithFormat:@"%@",placemark.subLocality];
                                           }
                                           else
                                           {
                                               currentLocationStr=[NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.locality];
                                           }
                                       }
                                       
                                   }
                                   
                                   //   currentLocationStr=[NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.locality];
                                   
                                   if (currentLocationStr.length>0) {
                                       
                                       _searchDropRef.text=currentLocationStr;
                                       
                                   }
                                   
                                   [DejalBezelActivityView removeView];
                                   
                               }];
                
            }else{
                
                [DejalBezelActivityView removeView];
                
                //            [AlertController showMessage:@"Location services are disabled in your App settings Please enable the Location Settings." withTitle:@"Promo Analytics"];
            }

        }
        else
        {
            currentLocationStr = _strAddress;
            _searchDropRef.text = _strAddress;
            
        }

            
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSString *Address = [[NSString alloc]initWithString:locatedAt];
//            NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//            NSString *Country = [[NSString alloc]initWithString:placemark.country];
//            NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             
            strLocation=[NSString stringWithFormat:@"%@",Address];
             NSLog(@"%@",strLocation);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             
         }
       
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
