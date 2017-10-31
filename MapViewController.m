//
//  MapViewController.m
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import "CategoryTableViewCell.h"
#import "Reachability.h"
#import "ListViewController.h"
#import "UIImageView+WebCache.h"
#import "MVPlaceSearchTextField.h"
#import "SWRevealViewController.h"
#import "ListViewController.h"
#import "CouponDetailVC.h"
#import "CouponsListViewController.h"





static NSString * const KMapPlacesApiKey = @"AIzaSyA9NV07HEkJtwVymm-r6hQupJqXt8MQ6UM";
@interface MapViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,NSLayoutManagerDelegate,NSURLSessionDelegate,MyProtocolDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,NSURLSessionDelegate>
{
    MyProtocol*AlertController;
    Validation*textFieldValidation;
    
     GMSCameraPosition *cameraPosition;
     CLLocationManager *locationManager;
    
    MapViewController *map;
    NSString *  usrID;
    
    double			userLatitude;
    double			userLongitude;
    
    double			currentLatitude;
    double			currentLongitude;
    
    float			firstLatitude;
    float			firstLongitude;
    
    NSString * categoryID;
    NSString * currentLocationStr;
    NSString * countryString;
    
    NSArray * latitudeArray;
    NSArray * longitudeArray;
    
    GMSMarker *markerD;
    GMSMarker *categoryMarkers;
    GMSMarker *locationMarker;
    
    NSString * citynameStr;
    NSString*categotyString;
    
    UIView * popUpView;
    UIView * alertView;
    UILabel * selectLabel;
    UITableView * categoryTableView;
    CategoryTableViewCell*CatCell;
    
    UIImageView*mapCategoryImag;
    
    NSArray * idArray;
    NSArray * categoryNameArray;
    
    NSArray * mapCategoryID;
    NSArray * mapCategoryName;
    
    NSString * categoryType;
    
    UIView *infowindow;
    
    SWRevealViewController *revelview;
    UIButton *barbutt,*rightButt;
    UIView *frontView;
    
    UITextField *txtCity;
     NSString * userID;
    UIImageView *imageView,*imageView2;
    
    NSString *str,*str2;
    
    NSURLSession *mySession;
    int j;
    
    NSString *tzName;
}
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataArray;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *SearchCityView;

@property(strong, nonatomic) GMSMapView *mapView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *mapResncArray;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *locaionArray;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *CategoryListAry;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    tzName = [timeZone name];
    
    NSLog(@"%@",tzName);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSError *error2 = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error2];
    
    NSLog(@"%@", jsonDict);
    
    imageView=[[UIImageView alloc]init];
    imageView2=[[UIImageView alloc]init];
    userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];

    _topView.hidden=YES;

//    UINavigationBar *headerView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    headerView.backgroundColor=[UIColor clearColor];
//    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@""];
//    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(SidebarBtnAction:)];
//    [buttonCarrier setLeftBarButtonItem:barBackButton];
//    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
//    barBackButton.target = self.revealViewController;
//    barBackButton.action = @selector(revealToggle:);
//    self.revealViewController.delegate = self;
//    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    [headerView setItems:barItemArray];
//    [self.view addSubview:headerView];
//   
//    headerView.barTintColor = [UIColor clearColor];
//    headerView.tintColor = [UIColor clearColor];
//    headerView.translucent = YES;
    
    _searchView.layer.borderWidth=1.0;
     [[_searchView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    _SearchCityView.layer.borderWidth=1.0;
    [[_SearchCityView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    UIView *topbgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    topbgView.backgroundColor=[UIColor colorWithRed:228.0/255.0f green:59.0/255.0f blue:48.0/255.0f alpha:1.0];
    [self.view addSubview:topbgView];
    
    
    self.revealViewController.delegate = self;
    
    frontView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    frontView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [frontView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [frontView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    frontView.hidden=YES;
    [self.view addSubview:frontView];
    
  
    UIImageView *leftbutt=[[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 30, 30)];
    leftbutt.image=[UIImage imageNamed:@"Menu.png"];
    leftbutt.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:leftbutt];
    
    
    
    self.revealViewController.rearViewRevealWidth=260;
    barbutt = [UIButton buttonWithType:UIButtonTypeCustom];
    barbutt.frame=CGRectMake(0,15, 50, 60);
    [barbutt addTarget:revelview action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:barbutt];
    
    
    UIImageView *Rightimag=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-45,35, 30, 30)];
    Rightimag.image=[UIImage imageNamed:@"List_view.png"];
    Rightimag.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:Rightimag];
    
    rightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt.frame=CGRectMake(self.view.frame.size.width-50,15, 50, 60);
    [rightButt addTarget:self action:@selector(RightbarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButt];
    
    
    _SearchCityView.layer.cornerRadius=3.0;
    _searchView.layer.cornerRadius=3.0;
    
    UIView *cityView=[[UIView alloc] initWithFrame:CGRectMake(55, 15, self.view.frame.size.width-110, 40)];
    cityView.backgroundColor=[UIColor whiteColor];
    cityView.layer.cornerRadius=3.0;
    cityView.hidden=YES;
    [self.view addSubview:cityView];
    
//    _searchDropRef=[[MVPlaceSearchTextField alloc] initWithFrame:CGRectMake(5, 5, cityView.frame.size.width-37, 30)];
//    _searchDropRef.placeholder=@"Select City";
//    _searchDropRef.textColor=[UIColor colorWithRed:173.0/255.0f green:173.0/255.0f blue:173.0/255.0f alpha:1.0];
//    _searchDropRef.font=[UIFont systemFontOfSize:14];
//    _searchDropRef.textAlignment=NSTextAlignmentLeft;
//    [cityView addSubview:_searchDropRef];
    
    UILabel *linelab=[[UILabel alloc]initWithFrame:CGRectMake(cityView.frame.size.width-31, 0, 0.5, cityView.frame.size.height)];
    linelab.backgroundColor=[UIColor lightGrayColor];
    [cityView addSubview:linelab];
    
    UIImageView *searchView=[[UIImageView alloc] initWithFrame:CGRectMake(cityView.frame.size.width-25, 10, 20, 20)];
    searchView.contentMode=UIViewContentModeScaleAspectFit;
    searchView.image=[UIImage imageNamed:@""];
    [cityView addSubview:searchView];
    
    
    
    
   //  [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    
   // self.searchView.hidden=YES;
    
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    textFieldValidation=[[Validation alloc]init];
    
    _searchDropRef.delegate=self;
    _categoryTF.delegate=self;
//    [_cityTF setTextFieldPlaceholderText:@"City"];
//    _cityTF.btmLineColor = [UIColor whiteColor];
//    _cityTF.btmLineSelectionColor = [UIColor whiteColor];
//    _cityTF.placeHolderTextColor = [UIColor whiteColor];
//    _cityTF.selectedPlaceHolderTextColor = [UIColor whiteColor];
    
    [_categoryTF setTextFieldPlaceholderText:@"All Categories"];
    _categoryTF.btmLineColor = [UIColor whiteColor];
    _categoryTF.btmLineSelectionColor = [UIColor whiteColor];
    _categoryTF.placeHolderTextColor = [UIColor whiteColor];
    _categoryTF.selectedPlaceHolderTextColor = [UIColor whiteColor];
    

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];
    
    userLatitude = locationManager.location.coordinate.latitude;
    userLongitude = locationManager.location.coordinate.longitude;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"stlatitude"];
    NSObject * object2 = [prefs objectForKey:@"stlongitude"];
    if(object != nil)
    {
        NSString *strlat=[[NSUserDefaults standardUserDefaults]objectForKey:@"stlatitude"];
        NSString *strlong=[[NSUserDefaults standardUserDefaults]objectForKey:@"stlongitude"];
        currentLatitude = [strlat floatValue];
        currentLongitude = [strlong floatValue];
    }
    else if (object2 != nil)
    {
        NSString *strlat=[[NSUserDefaults standardUserDefaults]objectForKey:@"stlatitude"];
        NSString *strlong=[[NSUserDefaults standardUserDefaults]objectForKey:@"stlongitude"];
        currentLatitude = [strlat floatValue];
        currentLongitude = [strlong floatValue];
    }
    else
    {
        currentLatitude = locationManager.location.coordinate.latitude;
        currentLongitude = locationManager.location.coordinate.longitude;
    }

    
  
    
    firstLatitude = locationManager.location.coordinate.latitude;
    firstLongitude = locationManager.location.coordinate.longitude;
    
    
    
    self.mapView =[[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate=self;
   
    NSBundle *mainBundle = [NSBundle mainBundle];
     NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
    NSError *error;
    
    // Set the map style by passing the URL for style.json.
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    
    _mapView.mapStyle = style;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLatitude
                                                            longitude:currentLongitude
                                                                 zoom:8];
    self.mapView.camera=camera;
    self.mapView.myLocationEnabled=YES;
    [self.mapBackgrndView addSubview:self.mapView];
    
//    locationMarker = [[GMSMarker alloc] init];
//    locationMarker.position = CLLocationCoordinate2DMake(userLatitude, userLongitude);
//    locationMarker.title=@"Current Location";
//    locationMarker.map = self.mapView;
   
    
    usrID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    
    NSObject * object3 = [prefs objectForKey:@"categotyString"];
    if(object3 != nil)
    {
         _categoryTF.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"categotyString"];
         categotyString=[[NSUserDefaults standardUserDefaults] objectForKey:@"categotyString"];
    }
    else
    {
       _categoryTF.text=@"All Categories";
        categotyString=@"All Categories";
    }

    NSObject * object4 = [prefs objectForKey:@"categoryID"];
    if(object4 != nil)
    {
        categoryID=[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryID"];
    }
    else
    {
        categoryID=@"";
    }
    

    
    
  
    
    [self getAllDealsApi];
    
    [self selectCategoryApi];
    
   
    
    [self getUserProfileDetails];
    
    [self performSelector:@selector(AcceptedResponse7:) withObject:self afterDelay:2.0];
  //  [self performSelector:@selector(ResetMarker:) withObject:self afterDelay:15.0];
}



-(void)ResetMarker:(id)sender
{
    
    if (_mapResncArray.count==0)
    {
        [self performSelector:@selector(ResetMarker:) withObject:self afterDelay:5.0];
    }
    else
    {
        [self.mapView clear];
        [self.mapView reloadInputViews];
        
//        locationMarker = [[GMSMarker alloc] init];
//       locationMarker.position = CLLocationCoordinate2DMake(userLatitude, userLongitude);
//        locationMarker.title=@"Current Location";
//        locationMarker.map = self.mapView;
        
        for(int i=0; i<[_mapResncArray count]; i++)
        {
            NSString *lat = [[_mapResncArray objectAtIndex:i] objectForKey:@"latitude"];
            NSString *lon = [[_mapResncArray objectAtIndex:i] objectForKey:@"longitude"];
            double lt=[lat doubleValue];
            double ln=[lon doubleValue];
            
            categoryMarkers = [[GMSMarker alloc] init];
            categoryMarkers.position = CLLocationCoordinate2DMake(lt,ln);
            categoryMarkers.title = [[_mapResncArray objectAtIndex:i] objectForKey:@"name"];
            categoryMarkers.snippet =[[_mapResncArray objectAtIndex:i] objectForKey:@"category_name"];
            categoryMarkers.userData = [_mapResncArray objectAtIndex:i];
            
            
            NSString *imageUrl =[[_mapResncArray objectAtIndex:i] objectForKey:@"category_pic"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                         placeholderImage:[UIImage imageNamed:@"pin2.png"]];
            
           // categoryMarkers.icon = imageView.image;
            categoryMarkers.icon = [UIImage imageNamed:@"pin2.png"];
            categoryMarkers.map = _mapView;
        }
        
         [self performSelector:@selector(ResetMarker:) withObject:self afterDelay:5.0];
    }
}


- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void)getUserProfileDetails
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user_profile/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@",userID]];
    
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
                }
                
            }
            else{
                
                [DejalBezelActivityView removeView];
                
                NSDictionary*jsonResponce = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"responce %@",jsonResponce);
                
                NSString * messageStr=[jsonResponce valueForKey:@"message"];
                
                
                if ([messageStr isEqualToString:@"User Found"])
                {
                    _dataArray=[jsonResponce valueForKey:@"data"];
                    
                    NSString *nameStr=[_dataArray valueForKey:@"name"];
                 
                    [[NSUserDefaults standardUserDefaults]setObject:nameStr forKey:@"name"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    NSString *imageUrlStr=[_dataArray valueForKey:@"pic"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:imageUrlStr forKey:@"imageUrl"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
                else
                {
                    [AlertController showMessage:@"User details not found." withTitle:@"Promo Analytics"];
                }
                
            }
        }];
        
    }];
    
    [dataTask resume];
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
    ListViewController *list=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    
    str= [NSString stringWithFormat:@"%f", currentLatitude];
    str2= [NSString stringWithFormat:@"%f", currentLongitude];
    
    list.categotyString=_categoryTF.text;
    list.categoryID=categoryID;
    list.strAddress=_searchDropRef.text;
    list.stlatitude=str;
    list.stlongitude=str2;
    
    [[NSUserDefaults standardUserDefaults]setObject:_categoryTF.text forKey:@"categotyString"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:categoryID forKey:@"categoryID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:_searchDropRef.text forKey:@"strAddress"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"stlatitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str2 forKey:@"stlongitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [self.navigationController pushViewController:list animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    str= [NSString stringWithFormat:@"%f", currentLatitude];
    str2= [NSString stringWithFormat:@"%f", currentLongitude];
    
    [[NSUserDefaults standardUserDefaults]setObject:_categoryTF.text forKey:@"categotyString"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:categoryID forKey:@"categoryID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:_searchDropRef.text forKey:@"strAddress"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"stlatitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:str2 forKey:@"stlongitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // [self currentLocationMethod];
    
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
    
   
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        
    }else
    {
        [self performSelector:@selector(AcceptedResponse7:) withObject:self afterDelay:4.0];
    }

    
    
    
    [locationManager requestAlwaysAuthorization];
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [locationManager requestAlwaysAuthorization];
        //[self currentLocationMethod];
    
    }else{
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Location services are disabled in your App settings Please enable the Location Settings." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self SettingsClicked];
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
        

//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Location services are disabled in your App settings Please enable the Location Settings." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
//        [alert show];
        
    }
}

-(void)SettingsClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == [alertView firstOtherButtonIndex])
//    {
//       [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
//    }
//}

-(void)AcceptedResponse7:(id)sender
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [locationManager requestAlwaysAuthorization];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        [locationManager requestAlwaysAuthorization];
        
      //  currentLatitude = locationManager.location.coordinate.latitude;
      //  currentLongitude = locationManager.location.coordinate.longitude;
        
        
        usrID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
        
        
        cameraPosition = [GMSCameraPosition cameraWithLatitude:currentLatitude
                                                     longitude:currentLongitude
                                                          zoom:8
                                                       bearing:0
                                                  viewingAngle:0];
        
        [self.mapView animateToCameraPosition:cameraPosition];
        
        self.mapView.camera = cameraPosition;
        
        [self currentLocationMethod];
        
      
        
        [self getAllDealsApi];
        
    }else
    {
        [self performSelector:@selector(AcceptedResponse7:) withObject:self afterDelay:4.0];
    }
}



-(void)viewDidAppear:(BOOL)animated
{
    _searchDropRef.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _searchDropRef.autoCompleteBoldFontName = @"HelveticaNeue";
    _searchDropRef.autoCompleteTableCornerRadius=0.0;
    _searchDropRef.autoCompleteRowHeight=35;
    _searchDropRef.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _searchDropRef.autoCompleteFontSize=14;
    _searchDropRef.autoCompleteTableBorderWidth=1.0;
    _searchDropRef.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _searchDropRef.autoCompleteShouldHideOnSelection=YES;
    _searchDropRef.autoCompleteShouldHideClosingKeyboard=YES;
    _searchDropRef.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _searchDropRef.autoCompleteTableFrame = CGRectMake(5, 107, self.view.frame.size.width-10, 200.0);
}


#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict
{
    [self.view endEditing:YES];
    
     citynameStr=_searchDropRef.text;
    
    _cityCategoryTF.text=citynameStr;
    
   // categotyString=@"";
  //  categoryID=@"";
  //  _categoryTF.text=@"";
    
    
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



#pragma mark  Get All Coupon Method

-(void)getAllDealsApi
{
    
    cameraPosition = [GMSCameraPosition cameraWithLatitude:currentLatitude
                                                 longitude:currentLongitude
                                                      zoom:8
                                                   bearing:0
                                              viewingAngle:0];

    
    [self.mapView animateToCameraPosition:cameraPosition];
    self.mapView.camera = cameraPosition;
    
    
    categoryMarkers.map  = nil;
    [_mapView clear];
    
//    locationMarker = [[GMSMarker alloc] init];
//    locationMarker.position = CLLocationCoordinate2DMake(userLatitude, userLongitude);
//    locationMarker.title=@"Current Location";
//    locationMarker.map = self.mapView;

    
    
     [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all_map/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"category=%@&latitude=%f&longitude=%f&page=%@&time_zone=%@",categoryID,currentLatitude,currentLongitude,@"0",tzName]];
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
                
                
                NSDictionary*jsonResponce = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                NSLog(@"Map responce %@",jsonResponce);

                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    
                _mapResncArray=[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"];
                
                latitudeArray=[[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"]valueForKey:@"latitude"];

                longitudeArray=[[[jsonResponce valueForKey:@"data"]valueForKey:@"detail"]valueForKey:@"longitude"];
                    j=0;
                    
                [self loadimages];
                       
                        
                       // categoryMarkers.icon = [UIImage imageNamed:newIMAGE];
                        // categoryMarkers.icon = [UIImage imageNamed:@"pin2.png"];
                    

                   // }
                    
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    categoryMarkers.map  = nil;
                    _mapResncArray=[NSMutableArray new];
                    [_mapResncArray removeAllObjects];
                    [_mapView clear];
                    
//                    locationMarker = [[GMSMarker alloc] init];
//                    locationMarker.position = CLLocationCoordinate2DMake(userLatitude, userLongitude);
//                    locationMarker.title=@"Current Location";
//                    locationMarker.map = self.mapView;

                    
                    [AlertController showMessage:@"No Deal Found in this City/Category" withTitle:@"Promo Analytics"];
                }

                
                [DejalBezelActivityView removeView];
            }
        }];
        
    }];
    
    [dataTask resume];
}


-(void)loadimages
{
    
    if (j<_mapResncArray.count)
    {
        //self.view = _mapView;
        NSString *lat = [[_mapResncArray objectAtIndex:j] objectForKey:@"latitude"];
        NSString *lon = [[_mapResncArray objectAtIndex:j] objectForKey:@"longitude"];
        double lt=[lat doubleValue];
        double ln=[lon doubleValue];
        
        categoryMarkers = [[GMSMarker alloc] init];
        categoryMarkers.position = CLLocationCoordinate2DMake(lt,ln);
        categoryMarkers.title = [[_mapResncArray objectAtIndex:j] objectForKey:@"name"];
        categoryMarkers.snippet =[[_mapResncArray objectAtIndex:j] objectForKey:@"category_name"];
        categoryMarkers.userData = [_mapResncArray objectAtIndex:j];
        
        
        NSString *imageUrl2 =[[_mapResncArray objectAtIndex:j] objectForKey:@"category_pic_main"];
        
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2]
                      placeholderImage:[UIImage imageNamed:@"placeholder-3.png"] options:SDWebImageRefreshCached];
        
        NSString *imageUrl =[[_mapResncArray objectAtIndex:j] objectForKey:@"category_pic"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholderImage:[UIImage imageNamed:@"placeholder-3.png"] options:SDWebImageRefreshCached];
        
        
        NSURL *url = [NSURL URLWithString:imageUrl2];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        UIView *Mainview = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,60)];
        Mainview.backgroundColor=[UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,10,50,50)];
        view.layer.cornerRadius = 4.0;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [UIColor colorWithRed:244.0/255.0f green:62.0/255.0f blue:51.0/255.0f alpha:1.0].CGColor;
        UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        pinImageView.image = img;
        pinImageView.contentMode=UIViewContentModeScaleAspectFit;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 20, 20)];
        label.font=[UIFont systemFontOfSize:12];
        label.layer.cornerRadius = 10.0;
        label.layer.masksToBounds = YES;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.backgroundColor= [UIColor colorWithRed:244.0/255.0f green:62.0/255.0f blue:51.0/255.0f alpha:1.0];
        label.text = [[_mapResncArray objectAtIndex:j] objectForKey:@"store_count"];
        [view addSubview:pinImageView];
        [Mainview addSubview:view];
        [Mainview addSubview:label];
        //i.e. customize view to get what y
        
        
       // categoryMarkers.icon = imageView.image;
        
        UIImage *markerIcon = [self imageFromView:Mainview];
        categoryMarkers.icon = markerIcon;
        
       // categoryMarkers.icon = img;
        
        categoryMarkers.map = _mapView;
        
        j++;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadimages) object:nil];
        [self performSelector:@selector(loadimages) withObject:nil afterDelay:0.1];

    }
    else
    {
        
    }
}

- (UIImage *)imageFromView:(UIView *) view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float totalsize=(totalBytesExpectedToWrite/1024)/1024.f;
    float writtensize=(totalBytesWritten/1024)/1024.f;
    
    NSLog(@"Downloading...\n%.2f MB Of %.2f MB",writtensize,totalsize);
}






- (IBAction)crossButton:(id)sender {
    
    //_crossButton.hidden=YES;
    _categoryTF.text=@"All Categories";
}


- (IBAction)mapLocationButton:(id)sender {
    
     [self.view endEditing:YES];
    self.mapView.myLocationEnabled=YES;

    cameraPosition = [GMSCameraPosition cameraWithLatitude:firstLatitude
                                                 longitude:firstLongitude
                                                      zoom:8
                                                   bearing:0
                                              viewingAngle:0];
    
    [self.mapView animateToCameraPosition:cameraPosition];

    
//    markerD = [[GMSMarker alloc] init];
//    markerD.position = CLLocationCoordinate2DMake(currentLatitude, currentLongitude);
//    markerD.title = currentLocationStr;
//    markerD.snippet = countryString;
//    markerD.appearAnimation = kGMSMarkerAnimationNone;
//    markerD.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
////  markerD.icon = [UIImage imageNamed:@"map-marker"]];
//    markerD.map = self.mapView;
    
    
    citynameStr=currentLocationStr;
    _searchDropRef.text=currentLocationStr;
    _cityCategoryTF.text=currentLocationStr;
    
   // _searchView.hidden=NO;
    
    categoryID=@"";
    
    [self getLattitudeAndLongitude];
}

- (IBAction)citycategoryButtonAction:(id)sender {
    
    self.searchView.hidden=NO;
    [self.mapBackgrndView addSubview:self.searchView];
    
//    if ([sender isSelected])
//    {
//        
//    //[self viewSlideInFromTopToBottom:self.searchView];
//      self.searchView.hidden=NO;
//      [self.mapView addSubview:self.searchView];
//        
//        [sender setSelected:NO];
//        
//    } else {
//        
//       // [self viewSlideInFromBottomToTop:self.searchView];
//        self.searchView.hidden=YES;
//        [sender setSelected:YES];
//    }
    
}

#pragma mark  -- Google Maps Delegate Methods --


-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    //locationView.hidden=YES;
    
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
   // [self viewSlideInFromBottomToTop:self.searchView];
   // self.searchView.hidden=YES;
   [self.view endEditing:YES];
    
}
-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
    //locationView.hidden=YES;
}
    

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
//{
//    NSDictionary *dic = marker.userData;
//    NSLog(@"%@",dic);
//    
//    if ([dic count] == 0)
//    {
//        UIView *mainView=[[UIView alloc]init];
//        mainView.backgroundColor=[UIColor clearColor];
//        
//        UIView *HeadView=[[UIView alloc] init];
//        HeadView.backgroundColor=[UIColor whiteColor];
//        
//        
//        
//        UILabel *labelname=[[UILabel alloc] init];
//        labelname.numberOfLines=0;
//        labelname.font=[UIFont boldSystemFontOfSize:14];
//        labelname.textAlignment=NSTextAlignmentLeft;
//        labelname.text=[NSString stringWithFormat:@"%@",@"Current Location"];
//        CGRect textRect = [labelname.text boundingRectWithSize:labelname.frame.size
//                                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
//                                                       context:nil];
//        CGSize size = textRect.size;
//        CGSize descriptionSize = [labelname sizeThatFits:CGSizeMake(170,size.height)];
//        
//        
//        
//        
//        UILabel *labeladdress=[[UILabel alloc] init];
//        labeladdress.numberOfLines=0;
//        labeladdress.font=[UIFont systemFontOfSize:12];
//        labeladdress.textAlignment=NSTextAlignmentLeft;
//        labeladdress.text=[NSString stringWithFormat:@"%@",currentLocationStr];
//        CGRect textRect2 = [labeladdress.text boundingRectWithSize:labeladdress.frame.size
//                                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                                           context:nil];
//        CGSize size2 = textRect2.size;
//        CGSize descriptionSize2 = [labeladdress sizeThatFits:CGSizeMake(170,size2.height)];
//        
//        
//        
//        
//        mainView.frame = CGRectMake(0,0, 280, descriptionSize.height+descriptionSize2.height+47);
//        HeadView.frame = CGRectMake(5,5, 270, descriptionSize.height+descriptionSize2.height+30);
//        [mainView addSubview:HeadView];
//        
//        UIImageView *logoimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, HeadView.frame.size.height/2-25, 50, 50)];
//        NSString *imageUrl =@"";
//        [logoimage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
//                     placeholderImage:[UIImage imageNamed:@"placeholder-3.png"]];
//        logoimage.contentMode=UIViewContentModeScaleAspectFit;
//        [HeadView addSubview:logoimage];
//        
//        
//        labelname.frame = CGRectMake(60,13, descriptionSize.width, descriptionSize.height);
//        labeladdress.frame = CGRectMake(60,labelname.frame.origin.y+labelname.frame.size.height+5, descriptionSize2.width, descriptionSize2.height);
//        
//        [HeadView addSubview:labelname];
//        [HeadView addSubview:labeladdress];
//        
//        
//        UIImageView *Downimage=[[UIImageView alloc] initWithFrame:CGRectMake(HeadView.frame.size.width/2-5, HeadView.frame.size.height+HeadView.frame.origin.y-5, 20, 20)];
//        Downimage.image=[UIImage imageNamed:@"down-arrow-2.png"];
//        Downimage.contentMode=UIViewContentModeScaleAspectFit;
//        [mainView addSubview:Downimage];
//        
//        
//       return mainView;
//    }
//    else
//    {
//        UIView *mainView=[[UIView alloc]init];
//        mainView.backgroundColor=[UIColor clearColor];
//        
//        UIView *HeadView=[[UIView alloc] init];
//        HeadView.backgroundColor=[UIColor whiteColor];
//        
//        
//        
//        UILabel *labelname=[[UILabel alloc] init];
//        labelname.numberOfLines=0;
//        labelname.font=[UIFont boldSystemFontOfSize:14];
//        labelname.textAlignment=NSTextAlignmentLeft;
//        labelname.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
//        CGRect textRect = [labelname.text boundingRectWithSize:labelname.frame.size
//                                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
//                                                       context:nil];
//        CGSize size = textRect.size;
//        CGSize descriptionSize = [labelname sizeThatFits:CGSizeMake(170,size.height)];
//        
//        
//        
//        
//        UILabel *labeladdress=[[UILabel alloc] init];
//        labeladdress.numberOfLines=0;
//        labeladdress.font=[UIFont systemFontOfSize:12];
//        labeladdress.textAlignment=NSTextAlignmentLeft;
//        labeladdress.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"address"]];
//        CGRect textRect2 = [labeladdress.text boundingRectWithSize:labeladdress.frame.size
//                                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                                           context:nil];
//        CGSize size2 = textRect2.size;
//        CGSize descriptionSize2 = [labeladdress sizeThatFits:CGSizeMake(170,size2.height)];
//        
//        
//        
//        
//        mainView.frame = CGRectMake(0,0, 280, descriptionSize.height+descriptionSize2.height+47);
//        HeadView.frame = CGRectMake(5,5, 270, descriptionSize.height+descriptionSize2.height+30);
//        [mainView addSubview:HeadView];
//        
//        UIImageView *logoimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, HeadView.frame.size.height/2-25, 50, 50)];
//        NSString *imageUrl =[dic  objectForKey:@"category_pic_main"];
//        [logoimage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
//                     placeholderImage:[UIImage imageNamed:@"placeholder-3.png"]];
//        NSURL *url = [NSURL URLWithString:imageUrl];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [[UIImage alloc] initWithData:data];
//        logoimage.image = img;
//        logoimage.contentMode=UIViewContentModeScaleAspectFit;
//        [HeadView addSubview:logoimage];
//        
//        
//        labelname.frame = CGRectMake(60,13, descriptionSize.width, descriptionSize.height);
//        labeladdress.frame = CGRectMake(60,labelname.frame.origin.y+labelname.frame.size.height+5, descriptionSize2.width, descriptionSize2.height);
//        
//        [HeadView addSubview:labelname];
//        [HeadView addSubview:labeladdress];
//        
//        
//        UIImageView *Downimage=[[UIImageView alloc] initWithFrame:CGRectMake(HeadView.frame.size.width/2-5, HeadView.frame.size.height+HeadView.frame.origin.y-5, 20, 20)];
//        Downimage.image=[UIImage imageNamed:@"down-arrow-2.png"];
//        Downimage.contentMode=UIViewContentModeScaleAspectFit;
//        [mainView addSubview:Downimage];
//        
//        UIImageView *Rightimage=[[UIImageView alloc] initWithFrame:CGRectMake(HeadView.frame.size.width-25, HeadView.frame.size.height/2-10, 20, 20)];
//        Rightimage.image=[UIImage imageNamed:@"right-arrow-4.png"];
//        Rightimage.contentMode=UIViewContentModeScaleAspectFit;
//        [HeadView addSubview:Rightimage];
//        
//        return mainView;
//    }
//}
//    
//    
//-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
//{
//    ListViewController * lcv=[[ListViewController alloc]init];
//    
//    NSDictionary *dic = marker.userData;
//    
//    NSLog(@"%@",dic);
//    
//    
//    if ([dic count] == 0)
//    {
//        
//    }
//    else
//    {
//        lcv.catStrValue=@"map";
//        
//        [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"category_name"] forKey:@"mapCategoryName"];
//        [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"category_id"] forKey:@"mapCategoryID"];
//        [[NSUserDefaults standardUserDefaults]setValue:@"map" forKey:@"map"];
//        
//        //    ListViewController *list=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
//        //    [self.navigationController pushViewController:list animated:YES];
//        
//        CouponDetailVC * dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"CouponDetailVC"];
//        [self.navigationController pushViewController:dvc animated:YES];
//        
//        dvc.dealidString=[NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
//        
//        // self.tabBarController.selectedIndex=1;
//    }
//}
//

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSDictionary *dic = marker.userData;
    
    CouponsListViewController *list=[self.storyboard instantiateViewControllerWithIdentifier:@"CouponsListViewController"];
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"couponslist"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController pushViewController:list animated:YES];
    
   
    
    
//
//    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_all_store/",BaseUrl]]];
//    request.HTTPMethod = @"POST";
//    NSMutableString* profile = [NSMutableString string];
//    [profile appendString:[NSString stringWithFormat:@"latitude=%@&longitude=%@&user_id=%@&time_zone=%@&store_id=%@&page=%@",[dic objectForKey:@"latitude"],[dic objectForKey:@"longitude"],userID,tzName,[dic objectForKey:@"store_id"],@"0"]];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    request.HTTPBody  = [profile dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLSessionConfiguration *configuration =[NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//        
//            if(error){
//                
//                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
//                {
//                    [DejalBezelActivityView removeView];
//                    [AlertController showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
//                    
//                }
//                if ([error.localizedDescription isEqualToString:@"The request timed out."])
//                {
//                    [DejalBezelActivityView removeView];
//                    
//                }
//                
//            }
//            else{
//                
//                [DejalBezelActivityView removeView];
//                
//                NSDictionary*jsonResponce = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                
//                NSLog(@"%@",jsonResponce);
//                
//            }
//        }];
//        
//    }];
//    
//    [dataTask resume];
    
    return YES;
}






//#pragma mark -- Google Place Delegates --
//#pragma mark  - GMSAutocompleteFetcherDelegate --
//
//- (IBAction)searchDropRef:(id)sender {
//    
//    self.searchView.hidden=YES;
//   
//    
//    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
//    acController.delegate = self;
//    [self presentViewController:acController animated:YES completion:nil];
//    
//    
//}
//
//-(void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
//
//{
//    
//    //  NSString*str=place.name;
//    
//    citynameStr=place.name;
//    _searchDropRef.text=citynameStr;
//    _cityCategoryTF.text=citynameStr;
//    
//    categotyString=@"";
//    categoryID=@"";
//    _categoryTF.text=@"";
//    
//    //    [_cityTF setTextFieldPlaceholderText:@"City"];
//    //    _cityTF.btmLineColor = [UIColor whiteColor];
//    //    _cityTF.btmLineSelectionColor = [UIColor whiteColor];
//    //    _cityTF.placeHolderTextColor = [UIColor whiteColor];
//    //    _cityTF.selectedPlaceHolderTextColor = [UIColor whiteColor];
//   
//    [self getLattitudeAndLongitude];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)wasCancelled:(GMSAutocompleteViewController *)viewController{
//    
//    //    _cityTF.text=nil;
//    //    [_cityTF setTextFieldPlaceholderText:@"City"];
//    //    _cityTF.btmLineColor = [UIColor whiteColor];
//    //    _cityTF.btmLineSelectionColor = [UIColor whiteColor];
//    //    _cityTF.placeHolderTextColor = [UIColor whiteColor];
//    //    _cityTF.selectedPlaceHolderTextColor = [UIColor whiteColor];
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
//   // NSString*errorStr = [NSString stringWithFormat:@"%@", error.localizedDescription];
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


-(void)getLattitudeAndLongitude
{
    
    NSString * nameStr=citynameStr;
    
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"[&@!?.,' ]+" withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, nameStr.length)];
    
    NSString * urlString =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",nameStr];
    
    NSURL * url=[NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse * response;
    NSError * error;
    
    NSData * responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //    NSString * outputData=[[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    if (responseData==nil)
    {
        
         [AlertController showMessage:@"City not found" withTitle:@"Promo Analytics"];
        
        
    }else{
        NSDictionary  *googleAPIresponce = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:Nil];
        
        NSString * statusStr=[googleAPIresponce valueForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            
            _locaionArray=[googleAPIresponce valueForKey:@"results"];
            
            currentLatitude=[NSString stringWithFormat:@"%@",[[[[_locaionArray objectAtIndex:0] valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lat"]].floatValue;
            
            currentLongitude=[NSString stringWithFormat:@"%@",[[[[_locaionArray objectAtIndex:0] valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lng"]].floatValue;
            
          //_categoryTF.text=[categoryNameArray componentsJoinedByString: @","];
        //    _categoryTF.text=@"All Categories";
    
            [self getAllDealsApi];
            
            
        }else{
            
            [AlertController showMessage:@"City not found" withTitle:@"Promo Analytics"];
        }
        
    }
    
}



#pragma mark  -- Category Button Action --

- (IBAction)categoryButtonAction:(id)sender
{
     [self.view endEditing:YES];
     // self.searchView.hidden=YES;
    [self popUpViewMethod];
    
    categoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, alertView.frame.size.width, 300) style:UITableViewStylePlain];
    [alertView addSubview:categoryTableView];
    categoryTableView.estimatedRowHeight=44;
    categoryTableView.delegate=self;
    categoryTableView.dataSource=self;
    selectLabel.text=@"All Categories";
}


-(void)selectCategoryApi
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
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
                
              //  _categoryTF.text=[categoryNameArray componentsJoinedByString: @","];
              //  _categoryTF.text=@"All Categories";
                
            }
        }];
        
    }];
    
    [dataTask resume];
}

#pragma mark  Categoty popUp Delidates
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
    
    
    if ([categotyString isEqualToString:[[_CategoryListAry valueForKey:@"name"]objectAtIndex:indexPath.row]])
    {
        CatCell.cellCatImage.image=[UIImage imageNamed:@"Select"] ;
    }
    
    return CatCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    categotyString=[[_CategoryListAry valueForKey:@"name"]objectAtIndex:indexPath.row];
    categoryID=[[_CategoryListAry valueForKey:@"id"]objectAtIndex:indexPath.row];
    
    
   // NSLog(@"%@",citynameStr);
    _categoryTF.text=categotyString;
    
    
    if ([citynameStr isEqualToString:@""] || citynameStr==nil)
    {
         _cityCategoryTF.text=[NSString stringWithFormat:@"%@",categotyString];
    }else{
    _cityCategoryTF.text=[NSString stringWithFormat:@"%@,%@",citynameStr,categotyString];
    }
    popUpView.hidden=YES;
    
    [self getAllDealsApi];
}




#pragma mark  UITextfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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
    if (_categoryTF==textField)
    {
    [(ACFloatingTextField *)textField textFieldDidEndEditing];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view.tag == 1)
    {
        popUpView.hidden=YES;
    }
}

#pragma mark  - Current Location Brtton Action -

-(void)currentLocationMethod
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        
        [AlertController showMessage:@"Please check your mobile Data/WiFi" withTitle:@"NetWork Error!"];
          }
    
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSObject * object = [prefs objectForKey:@"strAddress"];
        if(object != nil)
        {
            _searchDropRef.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"strAddress"];
            currentLocationStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"strAddress"];
        }
        else
        {
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
                                   
                                   //                      NSLog(@"placemarks=%@",[placemarks objectAtIndex:0]);
                                   CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                   //
                                   //                       NSLog(@"placemark.ISOcountryCode =%@",placemark.ISOcountryCode);
                                   //                       NSLog(@"placemark.country =%@",placemark.country);
                                   //                       NSLog(@"placemark.postalCode =%@",placemark.postalCode);
                                   //                       NSLog(@"placemark.administrativeArea =%@",placemark.administrativeArea);
                                   //                       NSLog(@"placemark.locality =%@",placemark.locality);
                                   //                       NSLog(@"placemark.subLocality =%@",placemark.subLocality);
                                   //                       NSLog(@"placemark.subThoroughfare =%@",placemark.subThoroughfare);
                                   
                                   //currentLocationStr=placemark.subLocality;
                                   
                                   NSString *strl=[NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.locality];
                                   
                                   if (strl == (id)[NSNull null] || strl.length == 0 )
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
                                               //  locationMarker.title=currentLocationStr;
                                           }
                                       }
                                       else
                                       {
                                           NSString *str1=[NSString stringWithFormat:@"%@",placemark.locality];
                                           
                                           if (str1 == (id)[NSNull null] || str1.length == 0 || [str1 isEqualToString:@"(null)"])
                                           {
                                               currentLocationStr=[NSString stringWithFormat:@"%@",placemark.subLocality];
                                               // locationMarker.title=currentLocationStr;
                                           }
                                           else
                                           {
                                               currentLocationStr=[NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.locality];
                                               // locationMarker.title=currentLocationStr;
                                           }
                                       }
                                       
                                   }
                                   
                                   
                                   if (currentLocationStr.length>0) {
                                       
                                       _cityCategoryTF.text=currentLocationStr;
                                       _searchDropRef.text=currentLocationStr;
                                       citynameStr=currentLocationStr;
                                       
                                   }
                                   
                                   [DejalBezelActivityView removeView];
                                   
                               }];
                
            }else{
                
                [DejalBezelActivityView removeView];
                
                //             [AlertController showMessage:@"Location services are disabled in your App settings Please enable the Location Settings." withTitle:@"Promo Analytics"];
                
            }
        }
    }
}

#pragma mark -- View Animation --


-(void)viewSlideInFromLeftToRight:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)viewSlideInFromRightToLeft:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)viewSlideInFromTopToBottom:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.4;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)viewSlideInFromBottomToTop:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.4;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)fadeViewAnimation:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype =kCATransitionFromTop ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
