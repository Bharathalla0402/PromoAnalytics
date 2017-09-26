//
//  CouponDetailVC.m
//  PromoAnalytics
//
//  Created by amit on 3/20/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "CouponDetailVC.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "UIImageView+WebCache.h"
#import "Validation.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "LCBannerView.h"


@interface CouponDetailVC ()<MyProtocolDelegate,NSURLSessionDelegate,CLLocationManagerDelegate,LCBannerViewDelegate>
{
    CLLocation *currentLocation;
    NSString *strLocation;
    
    float			UserLatitude;
    float			UserLongitude;
    
    NSString*currentLocationStr;
    
    CLLocationManager *locationManager;
    
    MyProtocol*AlertController;
    Validation*textFieldValidation;
   
    NSString * userID;
    NSString*statusID;
    NSString*couponID;
    
    NSString * perCentStr;
    UIView *topview,*popview,*footerview;
    
    NSString * imageLink,*imageLink2;
    
    NSString *fevImgStr;
    
    NSArray *URLs;
}
@property (weak, nonatomic) IBOutlet UIScrollView *banerScrool;
@property (weak, nonatomic) IBOutlet UILabel *scanlab;
@property (weak, nonatomic) IBOutlet UILabel *aboutlal;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*dealDataArray;
@property (nonatomic, weak) LCBannerView *bannerView1;
@property (nonatomic, weak) LCBannerView *bannerView2;
@end

@implementation CouponDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scanlab.hidden=YES;
   
 //[self.tabBarController.tabBar setHidden:NO];
    _imageCoupon.layer.cornerRadius=2;
    _imageCoupon.clipsToBounds=YES;
    
    userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    
      
    UserLatitude = locationManager.location.coordinate.latitude;
    UserLongitude = locationManager.location.coordinate.longitude;
    
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    textFieldValidation=[[Validation alloc]init];

    _offerLabel.layer.cornerRadius=25;
    _offerLabel.clipsToBounds = YES;
    
   // _shareButton.layer.cornerRadius=20;
  //  _shareButton.clipsToBounds = YES;
    
    [[_emailTFview layer] setBorderWidth:1.5f];
    [[_emailTFview layer] setBorderColor:[UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f].CGColor];
    _emailTFview.clipsToBounds=YES;
    
     perCentStr=@"% Off";
    
    [self detailCouponApiMethod];
    [self timezone];
    
    
    UIImageView *imagebig=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-46, 132, 36, 36)];
    imagebig.image=[UIImage imageNamed:@"ic_aspect_ratio_white_3x.png"];
    imagebig.contentMode = UIViewContentModeScaleAspectFill;
    imagebig.hidden=YES;
    [_scrollViewDetail addSubview:imagebig];
    
    UIButton *imagebutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 130, 50, 50)];
    imagebutton.backgroundColor=[UIColor clearColor];
    [imagebutton addTarget:self action:@selector(imageButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    imagebutton.hidden=YES;
    [_scrollViewDetail addSubview:imagebutton];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.alpha = 0.0;
    [UIView animateWithDuration:.4 animations:^{
        self.tabBarController.tabBar.alpha = 1.0;
    }];
}


-(void)timezone
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://think360.in/promo/api/index.php/12345/timezone/"]];
    [request setHTTPMethod:@"GET"];
    //[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async (dispatch_get_main_queue(), ^{
            
            if (error)
            {
                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
                {
                   
                    
                }
                if ([error.localizedDescription isEqualToString:@"The request timed out."])
                {
                    [DejalBezelActivityView removeView];
                }
                
                
            } else
            {
                if(data != nil) {
                    NSError *err;
                    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    NSLog(@"%@",responseJSON);
                }
            }
        });
    }] resume];

}



#pragma mark  Detail API Coupon Method

-(void)detailCouponApiMethod
{
    [DejalBezelActivityView activityViewForView:self.scrollViewDetail withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_detail/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&deal_id=%@",userID,_dealidString]];
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
                
                NSLog(@"responce %@",jsonResponce);
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    
                    _dealDataArray=[jsonResponce valueForKey:@"data"];
                    
                    imageLink=[_dealDataArray valueForKey:@"image"];
                    
                   // [_imageCoupon sd_setImageWithURL:[NSURL URLWithString:imageLink] placeholderImage:[UIImage imageNamed:@"Noimage600X400"]];
                    
                    _nameCouponLbl.text=[_dealDataArray valueForKey:@"name"];
                    _offerLabel.text=[NSString stringWithFormat:@"%@%@",[_dealDataArray valueForKey:@"discount"],perCentStr];
                    _couponCodeLbl.text=[_dealDataArray valueForKey:@"code"];
                    //_addressLabel.text=[NSString stringWithFormat:@"Address: %@",[_dealDataArray valueForKey:@"address"]];
                    _validCouponLbl.text=[_dealDataArray valueForKey:@"valid"];
                    _aboutCouponLabel.text=[_dealDataArray valueForKey:@"detail"];
                    _aboutlal.text=[_dealDataArray valueForKey:@"description"];
                    
                    couponID=[_dealDataArray valueForKey:@"id"];
                    
                    NSArray *arrlist=[_dealDataArray valueForKey:@"address"];
                    
                    NSString * stringToDisplay = [arrlist componentsJoinedByString:@"\n"];
                    _addressLabel.text = stringToDisplay;
                    
                    
                    imageLink2=[_dealDataArray valueForKey:@"barCode"];
                    
                    if ([imageLink2 isEqualToString:@""])
                    {
                        _imageheight.constant = 0;
                        _imag2height.constant=0;
                        _scanlab.hidden=YES;
                    }
                    else
                    {
                        _scanlab.hidden=NO;
                     [_barcodeImage sd_setImageWithURL:[NSURL URLWithString:imageLink2] placeholderImage:[UIImage imageNamed:@""]];
                    }
                    
                   
                    NSArray *URL=[_dealDataArray valueForKey:@"coupon_gallery"];
                    
                    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:URL];
                    URLs = [orderedSet array];
                    
                    
                    [_banerScrool addSubview:({
                        
                        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, _banerScrool.frame.size.width, _banerScrool.frame.size.height)
                                                                            delegate:self
                                                                           imageURLs:URLs
                                                                placeholderImageName:@"Noimage600X400"
                                                                        timeInterval:5.0f
                                                       currentPageIndicatorTintColor:[UIColor redColor]
                                                              pageIndicatorTintColor:[UIColor whiteColor]];
                        
                        
                        bannerView.didClickedImageIndexBlock = ^(LCBannerView *bannerView, NSInteger index) {
                            
                            NSLog(@"Block: Clicked image in %p at index: %d", bannerView, (int)index);
                            
                            //  [self presentationView];
                        };
                        self.bannerView1 = bannerView;
                    })];

                    
                    
//                    UIColor *highlightColor2 = [UIColor blackColor];
//                    UIColor *normalColor2 = [UIColor blackColor];
//                    UIFont *font4 = [UIFont boldSystemFontOfSize:14.0];
//                    UIFont *font3 = [UIFont systemFontOfSize:14.0];
//                    NSDictionary *highlightAttributes2 = @{NSFontAttributeName:font3, NSForegroundColorAttributeName:highlightColor2};
//                    NSDictionary *normalAttributes2 = @{NSFontAttributeName:font4, NSForegroundColorAttributeName:normalColor2};
//                    NSString *str4=[NSString stringWithFormat:@"%@",strval];
//                    NSAttributedString *normalText2 = [[NSAttributedString alloc] initWithString:@"Address: " attributes:normalAttributes2];
//                    NSAttributedString *highlightedText3= [[NSAttributedString alloc] initWithString:str4 attributes:highlightAttributes2];
//                    NSMutableAttributedString *finalAttributedString2 = [[NSMutableAttributedString alloc] initWithAttributedString:normalText2];
//                    [finalAttributedString2 appendAttributedString:highlightedText3];
//                    _addressLabel.attributedText=finalAttributedString2;

                    
                    fevImgStr=[NSString stringWithFormat:@"%@",[_dealDataArray valueForKey:@"is_fav"]];
                  if ([fevImgStr isEqualToString:@"1"]) {
                        [self.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
                        [self.favouritButton setSelected:NO];
                        
                        
                    }else{
                        [self.favouritButton setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateNormal];
                        [self.favouritButton setSelected:YES];
                    }

                    
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                     [AlertController showMessage:@"No Deal Found" withTitle:@"Promo Analytics"];
                }
                
                
            }
        }];
        
    }];
    
    [dataTask resume];

}




- (IBAction)favouritButtonAction:(id)sender
{
    if ([fevImgStr isEqualToString:@"0"])
    {
        statusID=[NSString stringWithFormat:@"%@",@"1"];
    }
    else
    {
        statusID=[NSString stringWithFormat:@"%@",@"0"];
    }
    
    [self userFavoritAndUnFavoueMethod];
    
//    
//    if ([sender isSelected])
//    {
//        [sender setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
//        
//        statusID=@"1";
//        [self userFavoritAndUnFavoueMethod];
//        
//    } else {
//        [sender setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
//        
//        statusID=@"0";
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
        
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Do You Want to Save the Coupon?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//        [alert show];
    }
}


-(void)yesClicked
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user_fav/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&deal_id=%@&status=%@&address=%@&latitude=%f&longitude=%f",userID,couponID,statusID,strLocation,UserLatitude,UserLongitude]];
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
                    
                    fevImgStr=@"1";
                    [self.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
                    [AlertController showMessage:@"Coupon added to saved list." withTitle:@"Promo Analytics"];
                }
               else
               {
                 [AlertController showMessage:[jsonResponce valueForKey:@"message"] withTitle:@"Promo Analytics"];
               }
            }
        }];
        
    }];
    
    [dataTask resume];

}




- (IBAction)shareButtonAction:(id)sender {
    
//    NSString *message;
//    
//    if (_emailTF.text.length<=0 || ![textFieldValidation validateEmail:_emailTF.text])
//    {
//        message = @"Please enter valid email";
//    }
//    
//    if ([message length]>1)
//    {
//        [AlertController showMessage:message withTitle:@"Promo Analytics"];
//        
//    }else{
//        
//        [self sendEmailAPImethod];
//        [self.view endEditing:YES];
//        
//    }
    
    NSString *strCompany=[NSString stringWithFormat:@"Company Name : %@",[_dealDataArray valueForKey:@"company_name"]];
    NSString *strCoupon=[NSString stringWithFormat:@"Coupon Name : %@",[_dealDataArray valueForKey:@"name"]];

    NSString *strCode=[NSString stringWithFormat:@"Coupon Code : %@",_couponCodeLbl.text];
    
    NSArray *strlocations=[_dealDataArray valueForKey:@"address"];
    
    NSString *strlocation=[NSString stringWithFormat:@"\nValid in Store locations :\n\n %@",[strlocations componentsJoinedByString:@"\n\n"]];
    
    NSString *strDiscount=[NSString stringWithFormat:@"\nDiscount : %@",_offerLabel.text];
    
   
    NSArray *activityItems = @[strCompany,strCoupon,strCode,strlocation,strDiscount,@"For more coupons download app from here",@"App link will be here",];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [activityViewControntroller setValue:@"Coupon Details of Promo_Analytics" forKey:@"subject"];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
    
    
//     NSString *strCode=[NSString stringWithFormat:@"Coupon Code : %@",_couponCodeLbl.text];
//     NSString *strDiscount=[NSString stringWithFormat:@"Discount : %@",_offerLabel.text];
//    
//        NSArray* sharedObjects=[NSArray arrayWithObjects:strCode,strDiscount,@"For more coupons download app from here",@"App link will be here",nil];
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
//        [activityVC setValue:@"Coupon Details of Promo_Analytics" forKey:@"subject"];
//        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
//        [self presentViewController:activityVC animated:TRUE completion:nil];
    
    
    
}

-(void)sendEmailAPImethod
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@deal_share/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&email=%@&coupon_id=%@",userID,_emailTF.text,couponID]];
    
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
                
               // NSLog(@"%@",jsonResponce);
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    _emailTF.text=@"";
                     [AlertController showMessage:@"Coupon send successfully" withTitle:@"Promo Analytics"];
                    
                }
                else {
                    
                    [AlertController showMessage:@"Coupon not send Please try again" withTitle:@"Promo Analytics"];
                    
                }
                
            }
        }];
        }];
        
        [dataTask resume];
    }


- (IBAction)baceButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark  UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //  [self animateTextField:textField up:YES];
    
    //[(ACFloatingTextField *)textField textFieldDidBeginEditing];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    [self animateTextField:textField up:NO];
    // [(ACFloatingTextField *)textField textFieldDidEndEditing];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (void)dismissKeyboard
{
    [_emailTF resignFirstResponder];
}


#pragma mark - PopView Clicked Clicked

-(IBAction)imageButtClicked:(id)sender
{
    popview = [[ UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    footerview.backgroundColor = [UIColor blackColor];
    [popview addSubview:footerview];
    
    
    UIButton *Backbutt=[[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25, 25)];
    [Backbutt setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    Backbutt.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [Backbutt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Backbutt.titleLabel.font = [UIFont systemFontOfSize:15];
    [Backbutt addTarget:self action:@selector(Backked:) forControlEvents:UIControlEventTouchUpInside];
    Backbutt.backgroundColor=[UIColor clearColor];
    [footerview addSubview:Backbutt];
    
    UIButton *Backbutt2=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    [Backbutt2 addTarget:self action:@selector(Backked:) forControlEvents:UIControlEventTouchUpInside];
    Backbutt2.backgroundColor=[UIColor clearColor];
    [footerview addSubview:Backbutt2];
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-130)];
    [image sd_setImageWithURL:[NSURL URLWithString:imageLink] placeholderImage:[UIImage imageNamed:@"Noimage600X400"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:image];
        
}




#pragma mark  - Current Location Brtton Action -

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





-(IBAction)Backked:(id)sender
{
    [footerview removeFromSuperview];
    popview.hidden = YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
