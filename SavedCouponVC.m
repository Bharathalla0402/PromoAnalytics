//
//  SavedCouponVC.m
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "SavedCouponVC.h"
#import "CouponCVCell.h"
#import "CouponDetailVC.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "CategoryTableViewCell.h"

@interface SavedCouponVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MyProtocolDelegate,NSURLSessionDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>


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

}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,retain)NSString*categotyString;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*savedCouponArray;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *CategoryListAry;



@end

@implementation SavedCouponVC
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
    
    [self selectCategoryApi];
   
     perCentStr=@"%Off";
    
    _categotyString=@"All Categories";
    
    userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    UIImageView *filterImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-46, 71, 30, 30)];
    filterImage.image=[UIImage imageNamed:@"filter.png"];
    filterImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:filterImage];
    

    
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
    
    
    
    self.revealViewController.delegate = self;
    
    frontView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    frontView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [frontView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [frontView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    frontView.hidden=YES;
    [self.view addSubview:frontView];
    
    UIImageView *leftbutt=[[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    leftbutt.image=[UIImage imageNamed:@"Menu-white.png"];
    leftbutt.contentMode=UIViewContentModeScaleAspectFit;
    [_topView addSubview:leftbutt];
    
    self.revealViewController.rearViewRevealWidth=260;
    barbutt = [UIButton buttonWithType:UIButtonTypeCustom];
    barbutt.frame=CGRectMake(0,0, 60, 60);
    [barbutt addTarget:revelview action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:barbutt];
    


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
    
    [self savedCouponApiMethod];

//    UITabBar *tabBar = self.tabBar;
//    UITabBarItem *targetTabBarItem = [[tabBar items] objectAtIndex:0]; // whichever tab-item
//    UIImage *selectedIcon = [UIImage imageNamed:@"name-of-selected-image.png"];
//    [targetTabBarItem setSelectedImage:selectedIcon];
}

#pragma mark  UnFeatured Coupon Method

-(void)savedCouponApiMethod
{
//    x=1;
//    NSString*pageNum=[NSString stringWithFormat:@"%d",x];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@fav_list/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    if (categoryID == (id)[NSNull null] || categoryID.length == 0 )
    {
         [profile appendString:[NSString stringWithFormat:@"user_id=%@",userID]];
    }
    else
    {
        [profile appendString:[NSString stringWithFormat:@"user_id=%@&category=%@",userID,categoryID]];
    }
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
                    
                    _savedCoupon.text=[NSString stringWithFormat:@" Saved Coupons(%lu)",(unsigned long)_savedCouponArray.count];
                    
                   // nextPage=[NSString stringWithFormat:@"%@" ,[[jsonResponce valueForKey:@"data"]valueForKey:@"nextPage"]];
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    _savedCouponArray=[NSMutableArray new];
                    [_savedCouponArray removeAllObjects];
                    
                     _savedCoupon.text=[NSString stringWithFormat:@" Saved Coupons"];
                    
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
   // [coupaonCell.favouritButton addTarget:self action:@selector(favouritSaveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [coupaonCell.cellBgrndView addSubview:coupaonCell.favouritButton];
    NSString * fevImgStr=[NSString stringWithFormat:@"%@",[favouritImagArray objectAtIndex:indexPath.row]];
    if ([fevImgStr isEqualToString:@"1"]) {
        [coupaonCell.favouritButton setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
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
    coupaonCell.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
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
    
    if (sender.tag== indexPath.row)
    {
        selectedDealID = [couponIDArray objectAtIndex:indexPath.row];
        
    }
    
    if ([sender isSelected])
    {
        //[sender setImage:[UIImage imageNamed:@"hearts"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        statusID=@"0";
        
     //   [self userFavoritAndUnFavoueMethod];
        
}
//    else {
//        [sender setImage:[UIImage imageNamed:@"hrtunfilled"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
//        
//        statusID=@"0";
//        NSLog(@"feature coupn %@",statusID);
//        
//    }

    
}


-(void)userFavoritAndUnFavoueMethod
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
- (IBAction)filterbuttonClicked:(id)sender
{
    [self.view endEditing:YES];
    
    [self popUpViewMethod];
    
    categoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 46, alertView.frame.size.width, 300) style:UITableViewStylePlain];
    [alertView addSubview:categoryTableView];
    categoryTableView.estimatedRowHeight=44;
    categoryTableView.delegate=self;
    categoryTableView.dataSource=self;
    selectLabel.text=@"Select Category";
    
    //[self selectCategoryApi];
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
    categoryID=[[_CategoryListAry valueForKey:@"id"]objectAtIndex:indexPath.row];
    
   // _categoryTF.text=_categotyString;
    
    popUpView.hidden=YES;
    
    
    [self savedCouponApiMethod];
 //   [self unFeaturedCouponsApiMethod];
    
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
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.view.tag == 1)
    {
        popUpView.hidden=YES;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
