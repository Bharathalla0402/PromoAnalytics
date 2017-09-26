//
//  SidebarViewController.m
//  PromoAnalytics
//
//  Created by think360 on 12/06/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "SidebarViewController.h"
#import "Customcell1.h"
#import "MapViewController.h"
#import "SavedCouponVC.h"
#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"

@interface SidebarViewController ()<UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate>
{
    SWRevealViewController *revel;
    NSMutableArray *arrimage;
    NSMutableArray *arrtitle;
    NSMutableData *mdata;
    
    NSMutableArray *arr;
    NSString *str;
    
    NSString *strtotal;
    NSString *strcancelled;
    
    
    NSMutableArray *arrcars;
    NSMutableArray *arrid;
    
    NSMutableArray *arrdetails;
    
    Customcell1 *cell;
    
    NSMutableArray *arrcount;
    
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // arrtitle=[[NSMutableArray alloc]initWithObjects:@"Map",@"Saved Coupons",@"Profile",@"Logout", nil];
    
  //  arrimage=[[NSMutableArray alloc]initWithObjects:@"Map.png",@"saved_coupons.png",@"Profile.png",@"logout.png", nil];
    
    
    arrtitle=[[NSMutableArray alloc]initWithObjects:@"Map",@"Saved Coupons",@"Profile", nil];
    
    arrimage=[[NSMutableArray alloc]initWithObjects:@"Map.png",@"saved_coupons.png",@"Profile.png", nil];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    _profiimage.layer.cornerRadius = _profiimage.frame.size.height /2;
    _profiimage.layer.masksToBounds = YES;
    _profiimage.layer.borderWidth = 0;
    
    revel.delegate=self;
    
  //  _profileView.backgroundColor= [UIColor colorWithRed:105.0/255.0f green:43.0/255.0f blue:82.0/255.0f alpha:1.0];
  //  _backView.backgroundColor=[UIColor colorWithRed:105.0/255.0f green:43.0/255.0f blue:82.0/255.0f alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    _userName.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    NSString *strurl=[[NSUserDefaults standardUserDefaults]objectForKey:@"imageUrl"];
    
    [_profiimage sd_setImageWithURL:[NSURL URLWithString:strurl]
                  placeholderImage:[UIImage imageNamed:@"profilepic.png"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrtitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellClassName = @"Customcell1";
    
    cell = (Customcell1 *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
    
    if (cell == nil)
    {
        cell = [[Customcell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Customcell1"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UILabel *lblName=(UILabel *)[cell viewWithTag:2];
    UIImageView *image=(UIImageView*)[cell viewWithTag:1];
    lblName.text=[arrtitle objectAtIndex:indexPath.row];
    NSString *imageName=[arrimage objectAtIndex:indexPath.row];
    image.image=[UIImage imageNamed:imageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        MapViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[edit] animated: NO ];
        [self.revealViewController setFrontViewController:navController animated:YES];
    }
    else if (indexPath.row==1)
    {
        SavedCouponVC *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedCouponVC"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[edit] animated: NO ];
        [self.revealViewController setFrontViewController:navController animated:YES];
    }
    else if (indexPath.row==2)
    {
        ProfileViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[edit] animated: NO ];
        [self.revealViewController setFrontViewController:navController animated:YES];
    }
    else if (indexPath.row==3)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveUserID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        ViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[edit] animated: NO ];
        [self.revealViewController setFrontViewController:navController animated:YES];
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


- (IBAction)ProfilePicClicked:(UIButton *)sender
{
    ProfileViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[edit] animated: NO ];
    [self.revealViewController setFrontViewController:navController animated:YES];
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
