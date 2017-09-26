//
//  ViewController.m
//  PromoAnalytics
//
//  Created by amit on 3/16/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>
#import "SocialRegisterVC.h"
#import "ForgotPassWordVC.h"
#import "MapViewController.h"
#import "SidebarViewController.h"

@interface ViewController ()<UITextFieldDelegate,CAAnimationDelegate,MyProtocolDelegate,
NSURLSessionDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
{
    MyProtocol*AlertController;
    Validation*textFieldValidation;
    
    UIScrollView * scrollVwLR;
    UIImageView * logoImage;
    UISegmentedControl *loginRegSegment;

    UIView * loginView;
    UIButton * rememberButton;
    UISwitch*rememberMeSwtch;
    UILabel * rememberLabel;
    
    UITextField *emailTF;
    UITextField *passWordTF;
    UITextField *forgotPasswordMobile,*forgotPasswordMobile1;
    
    UIButton * forgtPWbtn;
    UIButton * loginButton;
    UILabel * emailLbl;
    UIImageView * emailImage;
    UILabel *pwLabel,*forgotPasswordMobileUnderlabel;
    UIImageView* pwImage;
    UILabel * fogotpassLbl,*fogotpassLbl1;
    
    UIButton * faceBookButton;
    UIButton * goodlePlusBtn;
    
    
    UIView * registerView;
    UITextField *firstNameTFReg;
    UITextField *dobTFReg;
    UITextField *emailTFRegister;
    UITextField *phoneNumTFReg;
    UITextField *passWordTFReg;
    UITextField *reEnterPwTFReg;
    
    
    UIButton* acceptCondBtn;
    UIButton *registerButton;
    
    UIButton* faceBookBtnregistrtn;
    UIButton* googlePlusBtnregistrtn;
   
    
    NSString * termsCondString;
    
    NSString* socialEmailStr;
    NSString * socialNameStr;
    
    UIActivityIndicatorView*myActivityIndicator;
    
    int googleLogin;
    int googleRegistaration;
    
    int socialReg;
    
   
    UIView * userNmVw;
    UIView * passWrdVw;
    
    UIView * userNmVwRegistr;
    UIImageView* userNmimage;
    UIView * DobViewTfVW;
    UIImageView* Dobimage;
    UIView * emailViewTfVW;
    UIImageView* emailimage;
    UIView * phoneViewTfVW;
    UIImageView* phnNumImage;
    UIView * passWrdTFVW;
    UIImageView* passWrgImage;
    UIView * reEnterPWTfVW;
    UIImageView* ReEnterPWImage;
    
    UIView *forgotpassNmVw,*forgotpassNmVw1;
    
    UILabel*userNameLblReg,*genderLblReg,*DobLblReg,*emailLblReg,*phnLblReg,*pwLblReg,*reEntrPwLblReg;
  
    UIImageView *maleb,*femaleb;
    NSString *strgender;
    
    UIView *popview;
    UIView *footerview;
    
    UIDatePicker *datePicker;
    UIBarButtonItem *rightBtn;
    UIButton *DoneButton,*DoneButton2;
    
    NSString *strage,*userIDStr;

}

//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
//@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;


@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUp];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    [GIDSignInButton class];
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate=self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIView *topbgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    topbgView.backgroundColor=[UIColor colorWithRed:228.0/255.0f green:59.0/255.0f blue:48.0/255.0f alpha:1.0];
    [self.view addSubview:topbgView];
    
    // FaceBook & Gmail Social Login
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
    
    FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
    [loginmanager logOut];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    

    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    textFieldValidation=[[Validation alloc]init];
    
    
    scrollVwLR =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)];
    scrollVwLR.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scrollVwLR];
    
    
    logoImage =[[UIImageView alloc]initWithFrame:CGRectMake(scrollVwLR.frame.size.width/2-100, 5, 200, 140)];
    logoImage.image=[UIImage imageNamed:@"logo-3.png"];
    logoImage.contentMode=UIViewContentModeScaleAspectFit;
    [scrollVwLR addSubview:logoImage];
    
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"LOGIN", @"REGISTER", nil];
    loginRegSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
    loginRegSegment.frame = CGRectMake(scrollVwLR.frame.size.width/2-100, logoImage.frame.origin.y+120, 200, 40);
    //loginRegSegment.segmentedControlStyle = UISegmentedControlStylePlain;
    [loginRegSegment addTarget:self action:@selector(segmentControlAction:) forControlEvents: UIControlEventValueChanged];
    loginRegSegment.selectedSegmentIndex = 0;
    [scrollVwLR addSubview:loginRegSegment];
    loginRegSegment.tintColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    loginRegSegment.layer.cornerRadius=20;
    [[loginRegSegment layer] setBorderWidth:1.5f];
    [[loginRegSegment layer] setBorderColor:[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f].CGColor];
    loginRegSegment.clipsToBounds=YES;
    
    
    
    
    [self loginViewMethod];
    [self registarationViewMethod];
    
    registerView.hidden=YES;
    loginView.hidden=NO;
    
    scrollVwLR.contentSize=CGSizeMake(self.view.frame.size.width, loginView.frame.size.height+100);
    
    
    
    termsCondString=@"0";
    
    googleLogin=0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    emailTF.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveEmail"];
    passWordTF.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"savePassword"];
    
    if (emailTF.text.length>0 && passWordTF.text.length>0)
    {
        [rememberMeSwtch setOn:YES animated:YES];
//        [rememberButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        [rememberButton setSelected:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


    NSString * userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    if (userID.length>0)
    {
//        MapViewController*mvc=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
//        [self.navigationController pushViewController:mvc animated:YES];
        
    }
    

}






#pragma mark  SegmentControll Action
- (void)segmentControlAction:(UISegmentedControl*)sender {
    
    if(loginRegSegment.selectedSegmentIndex == 0)
    {
        scrollVwLR.contentSize=CGSizeMake(self.view.frame.size.width, loginView.frame.size.height+100);
       // self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        firstNameTFReg.text=@"";
        emailTFRegister.text=@"";
        phoneNumTFReg.text=@"";
        passWordTFReg.text=@"";
        
        registerView.hidden=YES;
        loginView.hidden=NO;
        
        [self fadeViewAnimation:self.view];
        [self dismissKeyboard];
        
        googleLogin=0;
    }
    if(loginRegSegment.selectedSegmentIndex == 1)
    {
        scrollVwLR.contentSize=CGSizeMake(self.view.frame.size.width, registerView.frame.size.height+210);
        emailTF.text=@"";
        passWordTF.text=@"";
        
        registerView.hidden=NO;
        loginView.hidden=YES;
        
        [rememberMeSwtch setOn:NO animated:YES];
       // [rememberButton setSelected:YES];
       //  [rememberButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveEmail"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savePassword"];
        
        
        [self fadeViewAnimation:self.view];
        [self dismissKeyboard];
        
        googleLogin=1;
    }
    
}


#pragma mark  LoginView Method

-(void)loginViewMethod
{
    loginView=[[UIScrollView alloc]initWithFrame:CGRectMake(10,loginRegSegment.frame.origin.y+45, self.view.frame.size.width-20, self.view.frame.size.height-180)];
    loginView.backgroundColor = [UIColor clearColor];
    [scrollVwLR addSubview:loginView];
    scrollVwLR.contentSize=CGSizeMake(self.view.frame.size.width, loginView.frame.size.height+100);
    
    //Email
    userNmVw=[[UIView alloc]initWithFrame:CGRectMake(10, 30, loginView.frame.size.width-20, 40)];
     userNmVw.backgroundColor = [UIColor clearColor];
    [[userNmVw layer] setBorderWidth:2.0f];
    [[userNmVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    userNmVw.clipsToBounds=YES;
    [loginView addSubview:userNmVw];
    //[UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f].CGColor]
    
    emailImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    emailImage.image=[UIImage imageNamed:@"user-grey.png"];
    [userNmVw addSubview: emailImage];
    
    
    emailTF=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, userNmVw.frame.size.width-35, 38)];
    emailTF.borderStyle = UITextBorderStyleNone;
    emailTF.textColor=[UIColor darkGrayColor];
    emailTF.font = [UIFont systemFontOfSize:15];
    emailTF.placeholder = @"Enter Email/Mobile number";
    emailTF.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTF.keyboardType = UIKeyboardTypeDefault;
    emailTF.returnKeyType = UIReturnKeyDone;
    emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTF.delegate = self;
    [userNmVw addSubview:emailTF];
    
    emailLbl=[[UILabel alloc]initWithFrame:CGRectMake(userNmVw.frame.origin.x, userNmVw.frame.origin.y-24, 140, 20)];
    emailLbl.text=@"Email/Mobile number";
    emailLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    emailLbl.backgroundColor = [UIColor clearColor];
    emailLbl.textColor = [UIColor darkGrayColor];
    emailLbl.textAlignment = NSTextAlignmentLeft;
    [loginView addSubview:emailLbl];
    
    
    //PassWord
   passWrdVw=[[UIView alloc]initWithFrame:CGRectMake(10, userNmVw.frame.origin.y+70, loginView.frame.size.width-20, 40)];
    passWrdVw.backgroundColor = [UIColor clearColor];
    [[passWrdVw layer] setBorderWidth:2.0f];
    [[passWrdVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    passWrdVw.clipsToBounds=YES;
    [loginView addSubview:passWrdVw];
    
    pwImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    pwImage.image=[UIImage imageNamed:@"password.png"];
    [passWrdVw addSubview: pwImage];
    
    passWordTF=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, passWrdVw.frame.size.width-35, 38)];
    passWordTF.borderStyle = UITextBorderStyleNone;
    passWordTF.font = [UIFont systemFontOfSize:15];
    passWordTF.placeholder = @"**********";
    passWordTF.textColor=[UIColor darkGrayColor];
    passWordTF.autocorrectionType = UITextAutocorrectionTypeNo;
    passWordTF.keyboardType = UIKeyboardTypeDefault;
    passWordTF.returnKeyType = UIReturnKeyDone;
    passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWordTF.delegate = self;
    [passWordTF setSecureTextEntry:YES];
    [passWrdVw addSubview:passWordTF];
    
    pwLabel=[[UILabel alloc]initWithFrame:CGRectMake(passWrdVw.frame.origin.x, passWrdVw.frame.origin.y-24, 140, 20)];
    pwLabel.text=@"Password";
    pwLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    pwLabel.backgroundColor = [UIColor clearColor];
    pwLabel.textColor = [UIColor darkGrayColor];
    pwLabel.textAlignment = NSTextAlignmentLeft;
    [loginView addSubview:pwLabel];
    
    //Remember Switch
    rememberMeSwtch=[[UISwitch alloc]initWithFrame: CGRectMake(10, passWrdVw.frame.origin.y+50, 30, 30)];
    rememberMeSwtch.tintColor=[UIColor redColor];
    rememberMeSwtch.onTintColor=[UIColor redColor];
    [rememberMeSwtch addTarget: self action: @selector(rememberSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [loginView addSubview: rememberMeSwtch];
    //[rememberMeSwtch setOn:YES animated:YES];
    rememberMeSwtch.backgroundColor=[UIColor redColor];
    rememberMeSwtch.layer.cornerRadius=15;
    
    rememberLabel=[[UILabel alloc]initWithFrame:CGRectMake(rememberMeSwtch.frame.origin.x+55, rememberMeSwtch.frame.origin.y, 90, 30)];
    rememberLabel.text=@"Remember me";
    rememberLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    rememberLabel.backgroundColor = [UIColor clearColor];
    rememberLabel.textColor = [UIColor darkGrayColor];
    rememberLabel.textAlignment = NSTextAlignmentLeft;
    [loginView addSubview:rememberLabel];
   
    //ForgotPassword Button
    forgtPWbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgtPWbtn.frame=CGRectMake(loginView.frame.size.width-120,passWrdVw.frame.origin.y+50, 110, 30);
    forgtPWbtn.backgroundColor=[UIColor clearColor];
    [forgtPWbtn setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    forgtPWbtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    [forgtPWbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal ];
    forgtPWbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgtPWbtn addTarget:self action:@selector(forgotPasswordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:forgtPWbtn];
    
    //LoginButton
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame=CGRectMake(10,rememberMeSwtch.frame.origin.y+50, loginView.frame.size.width-20, 40);
    loginButton.backgroundColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    loginButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginButton addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius=20;
    loginButton.clipsToBounds=YES;
    [loginView addSubview:loginButton];

    
    UILabel * orLabel =[[UILabel alloc]initWithFrame:CGRectMake(loginView.frame.size.width/2-100, loginButton.frame.origin.y+80, 200, 30)];
    orLabel.text=@"OR LOGIN WITH SOCIAL ACCOUNT";
    orLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textColor = [UIColor darkGrayColor];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:orLabel];
    //orLabel.layer.cornerRadius=15;
    //orLabel.clipsToBounds=YES;
    //[[orLabel layer] setBorderWidth:1.5f];
    //[[orLabel layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    
    UILabel * leftLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, orLabel.frame.origin.y+14, loginView.frame.size.width/2-110, 1)];
    leftLbl.backgroundColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    [loginView addSubview:leftLbl];
    
    UILabel * rightLbl =[[UILabel alloc]initWithFrame:CGRectMake(orLabel.frame.origin.x+orLabel.frame.size.width+10, orLabel.frame.origin.y+14, loginView.frame.size.width/2-110, 1)];
    rightLbl.backgroundColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    [loginView addSubview:rightLbl];
    
    //Social Login Buttons
    faceBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBookButton.frame=CGRectMake(loginView.frame.size.width/2-50,orLabel.frame.origin.y+40, 40, 40);
    [faceBookButton setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [faceBookButton addTarget:self action:@selector(facebookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:faceBookButton];
    
    goodlePlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodlePlusBtn.frame=CGRectMake(loginView.frame.size.width/2+10,faceBookButton.frame.origin.y, 40, 40);
    [goodlePlusBtn setImage:[UIImage imageNamed:@"google90"] forState:UIControlStateNormal];
    [goodlePlusBtn addTarget:self action:@selector(googleSignInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:goodlePlusBtn];

}


-(void)rememberSwitchAction:(UISwitch*)sender
{
    if (rememberMeSwtch.isOn) {
        
        if (emailTF.text.length==0 || passWordTF.text.length==0)
        {
            [rememberMeSwtch setOn:NO animated:YES];
            [AlertController showMessage:@"Please enter Email/Password" withTitle:@"Promo Analytics"];
        }
        
        else{
            [[NSUserDefaults standardUserDefaults]setValue:emailTF.text forKey:@"saveEmail"];
            [[NSUserDefaults standardUserDefaults]setValue:passWordTF.text forKey:@"savePassword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

    }
    else{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveEmail"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savePassword"];
        
    }
    
    }

//- (void)rememberBtnAction:(UIButton*)sender {
//        if (emailTF.text.length==0 || passWordTF.text.length==0)
//    {
//         [AlertController showMessage:@"Please enter Email/Password" withTitle:@"Promo Analytics"];
//    }
//    else{
//    if ([sender isSelected])
//    {
//        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
//        [[NSUserDefaults standardUserDefaults]setValue:emailTF.text forKey:@"saveEmail"];
//        [[NSUserDefaults standardUserDefaults]setValue:passWordTF.text forKey:@"savePassword"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    } else {
//        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveEmail"];
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savePassword"];
//    }
//    }
//}

#pragma mark  Forgot Button Action Method

-(void)forgotPasswordBtnAction:(UIButton*)sender
{
    
//    ForgotPassWordVC * fpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassWordVC"];
//    [self.navigationController pushViewController:fpvc animated:YES];
    
    
    popview = [[UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-115, 300, 230)];
    footerview.backgroundColor = [UIColor whiteColor];
    [popview addSubview:footerview];
    
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, footerview.frame.size.width-40, 40)];
    lab.text=@"Forgot Password";
    lab.textColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=[UIFont boldSystemFontOfSize:16];
    [footerview addSubview:lab];
    
    UILabel *labeunder=[[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+1, footerview.frame.size.width, 2)];
    labeunder.backgroundColor=[UIColor clearColor];
    [footerview addSubview:labeunder];
    
    
    
    fogotpassLbl=[[UILabel alloc]initWithFrame:CGRectMake(20, labeunder.frame.size.height+labeunder.frame.origin.y+15, 140, 20)];
    fogotpassLbl.text=@"Email or Phone";
    fogotpassLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    fogotpassLbl.backgroundColor = [UIColor clearColor];
    fogotpassLbl.textColor = [UIColor darkGrayColor];
    fogotpassLbl.textAlignment = NSTextAlignmentLeft;
    [footerview addSubview:fogotpassLbl];
    
    
    forgotpassNmVw=[[UIView alloc]initWithFrame:CGRectMake(20, fogotpassLbl.frame.size.height+fogotpassLbl.frame.origin.y+5, footerview.frame.size.width-40, 40)];
    forgotpassNmVw.backgroundColor = [UIColor clearColor];
    [[forgotpassNmVw layer] setBorderWidth:2.0f];
    [[forgotpassNmVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    forgotpassNmVw.clipsToBounds=YES;
    [footerview addSubview:forgotpassNmVw];
    

    forgotPasswordMobile=[[UITextField alloc]initWithFrame:CGRectMake(10, 1, forgotpassNmVw.frame.size.width-20, 38)];
    forgotPasswordMobile.borderStyle = UITextBorderStyleNone;
    forgotPasswordMobile.textColor=[UIColor darkGrayColor];
    forgotPasswordMobile.font = [UIFont systemFontOfSize:15];
    forgotPasswordMobile.placeholder = @"Email or Phone";
    forgotPasswordMobile.autocorrectionType = UITextAutocorrectionTypeNo;
    forgotPasswordMobile.keyboardType = UIKeyboardTypeDefault;
    forgotPasswordMobile.returnKeyType = UIReturnKeyDone;
    forgotPasswordMobile.clearButtonMode = UITextFieldViewModeWhileEditing;
    forgotPasswordMobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    forgotPasswordMobile.delegate = self;
    [forgotpassNmVw addSubview:forgotPasswordMobile];
    
   
    
    forgotPasswordMobileUnderlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, forgotpassNmVw.frame.size.height+forgotpassNmVw.frame.origin.y+1, footerview.frame.size.width-20, 2)];
    forgotPasswordMobileUnderlabel.backgroundColor=[UIColor lightGrayColor];
    forgotPasswordMobileUnderlabel.hidden=YES;
    [footerview addSubview:forgotPasswordMobileUnderlabel];
    
    UIButton *butt=[[UIButton alloc]initWithFrame:CGRectMake(10,forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35,footerview.frame.size.width/2-15,40)];
    [butt setTitle:@"CANCEL" forState:UIControlStateNormal];
    butt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    butt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt addTarget:self action:@selector(CancelButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    butt.backgroundColor=[UIColor colorWithRed:233.0/255.0f green:233.0/255.0f blue:233.0/255.0f alpha:1.0];
    butt.layer.cornerRadius=20.0;
    butt.clipsToBounds=YES;
    [footerview addSubview:butt];
    
    UIButton *butt1=[[UIButton alloc]initWithFrame:CGRectMake(butt.frame.size.width+butt.frame.origin.x+10, forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35, footerview.frame.size.width/2-15, 40)];
    [butt1 setTitle:@"SEND OTP" forState:UIControlStateNormal];
    butt1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butt1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt1 addTarget:self action:@selector(DoneButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    butt1.backgroundColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    butt1.layer.cornerRadius=20.0;
    butt1.clipsToBounds=YES;
    [footerview addSubview:butt1];
}


-(IBAction)CancelButtClicked:(id)sender
{
    [footerview endEditing:YES];
    [footerview removeFromSuperview];
    popview.hidden = YES;
}

-(IBAction)DoneButtClicked:(id)sender
{
    [footerview endEditing:YES];
     NSString *message;
    if (forgotPasswordMobile.text.length==0)
    {
         message = @"Please Enter Your Registered Email Id/Mobile Number.";
    }
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        
          [self forgotPassWordMethod];
    }
}


-(void)forgotPassWordMethod
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@forget_password/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"mobile=%@",forgotPasswordMobile.text]];
    
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
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    [footerview endEditing:YES];
                    [footerview removeFromSuperview];
                    popview.hidden = YES;
                    
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    
                    userIDStr=[dataArray valueForKey:@"user_id"];
                    
                    [self ReverifyAccount];
                   
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    [AlertController showMessage:@"User not Register with PromoAnalytics Please Register." withTitle:@"Promo Analytics"];
                }
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
}




-(void)ReverifyAccount
{
    popview = [[UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-120, 300, 240)];
    footerview.backgroundColor = [UIColor whiteColor];
    [popview addSubview:footerview];
    
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, footerview.frame.size.width-40, 40)];
    lab.text=@"Verify Account";
    lab.textColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=[UIFont boldSystemFontOfSize:16];
    [footerview addSubview:lab];
    
    UILabel *labeunder=[[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+1, footerview.frame.size.width, 2)];
    labeunder.backgroundColor=[UIColor clearColor];
    [footerview addSubview:labeunder];
    
    
    
    fogotpassLbl=[[UILabel alloc]initWithFrame:CGRectMake(20, labeunder.frame.size.height+labeunder.frame.origin.y+15, 140, 20)];
    fogotpassLbl.text=@"Enter OTP Code";
    fogotpassLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    fogotpassLbl.backgroundColor = [UIColor clearColor];
    fogotpassLbl.textColor = [UIColor darkGrayColor];
    fogotpassLbl.textAlignment = NSTextAlignmentLeft;
    [footerview addSubview:fogotpassLbl];
    
    
    forgotpassNmVw=[[UIView alloc]initWithFrame:CGRectMake(20, fogotpassLbl.frame.size.height+fogotpassLbl.frame.origin.y+5, loginView.frame.size.width-40, 40)];
    forgotpassNmVw.backgroundColor = [UIColor clearColor];
    [[forgotpassNmVw layer] setBorderWidth:2.0f];
    [[forgotpassNmVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    forgotpassNmVw.clipsToBounds=YES;
    [footerview addSubview:forgotpassNmVw];
    
    
    forgotPasswordMobile=[[UITextField alloc]initWithFrame:CGRectMake(10, 1, forgotpassNmVw.frame.size.width-20, 38)];
    forgotPasswordMobile.borderStyle = UITextBorderStyleNone;
    forgotPasswordMobile.textColor=[UIColor darkGrayColor];
    forgotPasswordMobile.font = [UIFont systemFontOfSize:15];
    forgotPasswordMobile.placeholder = @"Enter OTP Code";
    forgotPasswordMobile.autocorrectionType = UITextAutocorrectionTypeNo;
    forgotPasswordMobile.keyboardType = UIKeyboardTypeDefault;
    forgotPasswordMobile.returnKeyType = UIReturnKeyDone;
    forgotPasswordMobile.clearButtonMode = UITextFieldViewModeWhileEditing;
    forgotPasswordMobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    forgotPasswordMobile.delegate = self;
    [forgotpassNmVw addSubview:forgotPasswordMobile];
    
    
    
    forgotPasswordMobileUnderlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, forgotpassNmVw.frame.size.height+forgotpassNmVw.frame.origin.y+1, footerview.frame.size.width-20, 2)];
    forgotPasswordMobileUnderlabel.backgroundColor=[UIColor lightGrayColor];
    forgotPasswordMobileUnderlabel.hidden=YES;
    [footerview addSubview:forgotPasswordMobileUnderlabel];
    
    forgotPasswordMobileUnderlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, forgotpassNmVw.frame.size.height+forgotpassNmVw.frame.origin.y+1, footerview.frame.size.width-20, 2)];
    forgotPasswordMobileUnderlabel.backgroundColor=[UIColor lightGrayColor];
    forgotPasswordMobileUnderlabel.hidden=YES;
    [footerview addSubview:forgotPasswordMobileUnderlabel];
    
    
    
    
    UIButton *butt=[[UIButton alloc]initWithFrame:CGRectMake(6,forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35,footerview.frame.size.width/3-8,40)];
    [butt setTitle:@"VERIFY" forState:UIControlStateNormal];
    butt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt addTarget:self action:@selector(DoneButtClicked1:) forControlEvents:UIControlEventTouchUpInside];
    butt.backgroundColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    butt.layer.cornerRadius=20.0;
    butt.clipsToBounds=YES;
    [footerview addSubview:butt];
    
    UIButton *butt1=[[UIButton alloc]initWithFrame:CGRectMake(butt.frame.size.width+butt.frame.origin.x+6, forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35, footerview.frame.size.width/3-8, 40)];
    [butt1 setTitle:@"RESEND" forState:UIControlStateNormal];
    butt1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butt1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt1 addTarget:self action:@selector(ResendButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    butt1.backgroundColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    butt1.layer.cornerRadius=20.0;
    butt1.clipsToBounds=YES;
    [footerview addSubview:butt1];
    
    UIButton *butt2=[[UIButton alloc]initWithFrame:CGRectMake(butt1.frame.size.width+butt1.frame.origin.x+6, forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35, footerview.frame.size.width/3-8, 40)];
    [butt2 setTitle:@"CANCEL" forState:UIControlStateNormal];
    butt2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    butt2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt2 addTarget:self action:@selector(CancelButtClicked1:) forControlEvents:UIControlEventTouchUpInside];
    butt2.backgroundColor=[UIColor colorWithRed:233.0/255.0f green:233.0/255.0f blue:233.0/255.0f alpha:1.0];
    butt2.layer.cornerRadius=20.0;
    butt2.clipsToBounds=YES;
    [footerview addSubview:butt2];

    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.tintColor=[UIColor whiteColor];
    numberToolbar.backgroundColor=[UIColor colorWithRed:90.0/255.0f green:143.0/255.0f blue:63.0/255.0f alpha:1.0];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad3)],
                           nil];
    [numberToolbar sizeToFit];
    
    forgotPasswordMobile.inputAccessoryView = numberToolbar;
}


-(void)doneWithNumberPad3
{
    [forgotPasswordMobile resignFirstResponder];
}


-(IBAction)CancelButtClicked1:(id)sender
{
    [footerview removeFromSuperview];
    popview.hidden = YES;
}


-(IBAction)DoneButtClicked1:(id)sender
{
    [footerview endEditing:YES];
    NSString *message;
    if (forgotPasswordMobile.text.length==0)
    {
        message = @"Please Enter Your OTP";
    }
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        
        [self VerifyAccountMethod];
    }

}

-(void)VerifyAccountMethod
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@verify_otp/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&otp=%@",userIDStr,forgotPasswordMobile.text]];
    
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
                
                
                NSLog(@"%@",jsonResponce);
                
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"])
                {
                    userIDStr=[[jsonResponce valueForKey:@"data"]valueForKey:@"user_id"];
                    
                    [footerview endEditing:YES];
                    [footerview removeFromSuperview];
                    popview.hidden = YES;
                    
                   
                    [self ChangePasswordAccount];
                    
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    [AlertController showMessage:@"OTP not verify Please try again." withTitle:@"Promo Analytics"];
                }
            }
        }];
        
    }];
    
    [dataTask resume];

}


-(IBAction)ResendButtClicked:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@resend_otp/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@",userIDStr]];
    
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
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"])
                {
                    
                   
                }
                
                if ([msgStr isEqualToString:@"0"])
                {
                    
                   
                }
            }
        }];
        
    }];
    
    [dataTask resume];

}



-(void)ChangePasswordAccount
{

    popview = [[UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-150, 300, 300)];
    footerview.backgroundColor = [UIColor whiteColor];
    [popview addSubview:footerview];
    
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, footerview.frame.size.width-40, 40)];
    lab.text=@"Change Password";
    lab.textColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=[UIFont boldSystemFontOfSize:16];
    [footerview addSubview:lab];
    
    UILabel *labeunder=[[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+1, footerview.frame.size.width, 2)];
    labeunder.backgroundColor=[UIColor clearColor];
    [footerview addSubview:labeunder];
    
    
    
    fogotpassLbl=[[UILabel alloc]initWithFrame:CGRectMake(20, labeunder.frame.size.height+labeunder.frame.origin.y+15, 140, 20)];
    fogotpassLbl.text=@"New Password";
    fogotpassLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    fogotpassLbl.backgroundColor = [UIColor clearColor];
    fogotpassLbl.textColor = [UIColor darkGrayColor];
    fogotpassLbl.textAlignment = NSTextAlignmentLeft;
    [footerview addSubview:fogotpassLbl];
    
    
    forgotpassNmVw=[[UIView alloc]initWithFrame:CGRectMake(20, fogotpassLbl.frame.size.height+fogotpassLbl.frame.origin.y+5, loginView.frame.size.width-40, 40)];
    forgotpassNmVw.backgroundColor = [UIColor clearColor];
    [[forgotpassNmVw layer] setBorderWidth:2.0f];
    [[forgotpassNmVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    forgotpassNmVw.clipsToBounds=YES;
    [footerview addSubview:forgotpassNmVw];
    
    
    forgotPasswordMobile=[[UITextField alloc]initWithFrame:CGRectMake(10, 1, forgotpassNmVw.frame.size.width-20, 38)];
    forgotPasswordMobile.borderStyle = UITextBorderStyleNone;
    forgotPasswordMobile.textColor=[UIColor darkGrayColor];
    forgotPasswordMobile.font = [UIFont systemFontOfSize:15];
    forgotPasswordMobile.placeholder = @"New Password";
    forgotPasswordMobile.autocorrectionType = UITextAutocorrectionTypeNo;
    forgotPasswordMobile.keyboardType = UIKeyboardTypeDefault;
    forgotPasswordMobile.returnKeyType = UIReturnKeyDone;
    forgotPasswordMobile.clearButtonMode = UITextFieldViewModeWhileEditing;
    forgotPasswordMobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    forgotPasswordMobile.delegate = self;
    [forgotpassNmVw addSubview:forgotPasswordMobile];
    
    
    
    
    fogotpassLbl1=[[UILabel alloc]initWithFrame:CGRectMake(20, forgotpassNmVw.frame.size.height+forgotpassNmVw.frame.origin.y+15, 220, 20)];
    fogotpassLbl1.text=@"Confirm New Password";
    fogotpassLbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    fogotpassLbl1.backgroundColor = [UIColor clearColor];
    fogotpassLbl1.textColor = [UIColor darkGrayColor];
    fogotpassLbl1.textAlignment = NSTextAlignmentLeft;
    [footerview addSubview:fogotpassLbl1];
    
    
    forgotpassNmVw1=[[UIView alloc]initWithFrame:CGRectMake(20, fogotpassLbl1.frame.size.height+fogotpassLbl1.frame.origin.y+5, loginView.frame.size.width-40, 40)];
    forgotpassNmVw1.backgroundColor = [UIColor clearColor];
    [[forgotpassNmVw1 layer] setBorderWidth:2.0f];
    [[forgotpassNmVw1 layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    forgotpassNmVw1.clipsToBounds=YES;
    [footerview addSubview:forgotpassNmVw1];
    
    
    forgotPasswordMobile1=[[UITextField alloc]initWithFrame:CGRectMake(10, 1, forgotpassNmVw1.frame.size.width-20, 38)];
    forgotPasswordMobile1.borderStyle = UITextBorderStyleNone;
    forgotPasswordMobile1.textColor=[UIColor darkGrayColor];
    forgotPasswordMobile1.font = [UIFont systemFontOfSize:15];
    forgotPasswordMobile1.placeholder = @"Confirm New Password";
    forgotPasswordMobile1.autocorrectionType = UITextAutocorrectionTypeNo;
    forgotPasswordMobile1.keyboardType = UIKeyboardTypeDefault;
    forgotPasswordMobile1.returnKeyType = UIReturnKeyDone;
    forgotPasswordMobile1.clearButtonMode = UITextFieldViewModeWhileEditing;
    forgotPasswordMobile1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    forgotPasswordMobile1.delegate = self;
    [forgotpassNmVw1 addSubview:forgotPasswordMobile1];
    
    
    
    forgotPasswordMobileUnderlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, forgotpassNmVw1.frame.size.height+forgotpassNmVw1.frame.origin.y+1, footerview.frame.size.width-20, 2)];
    forgotPasswordMobileUnderlabel.backgroundColor=[UIColor lightGrayColor];
    forgotPasswordMobileUnderlabel.hidden=YES;
    [footerview addSubview:forgotPasswordMobileUnderlabel];
    
    UIButton *butt=[[UIButton alloc]initWithFrame:CGRectMake(10,forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35,footerview.frame.size.width/2-15,40)];
    [butt setTitle:@"CANCEL" forState:UIControlStateNormal];
    butt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    butt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt addTarget:self action:@selector(CancelButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    butt.backgroundColor=[UIColor colorWithRed:233.0/255.0f green:233.0/255.0f blue:233.0/255.0f alpha:1.0];
    butt.layer.cornerRadius=20.0;
    butt.clipsToBounds=YES;
    [footerview addSubview:butt];
    
    UIButton *butt1=[[UIButton alloc]initWithFrame:CGRectMake(butt.frame.size.width+butt.frame.origin.x+10, forgotPasswordMobileUnderlabel.frame.origin.y+forgotPasswordMobileUnderlabel.frame.size.height+35, footerview.frame.size.width/2-15, 40)];
    [butt1 setTitle:@"Done" forState:UIControlStateNormal];
    butt1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    butt1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butt1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butt1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [butt1 addTarget:self action:@selector(DoneButtClicked3:) forControlEvents:UIControlEventTouchUpInside];
    butt1.backgroundColor=[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
    butt1.layer.cornerRadius=20.0;
    butt1.clipsToBounds=YES;
    [footerview addSubview:butt1];
}


-(IBAction)DoneButtClicked3:(id)sender
{
    [footerview endEditing:YES];
    NSString *message;
    if (forgotPasswordMobile.text.length==0)
    {
        message = @"Please Enter Newpassword";
    }
    if (forgotPasswordMobile1.text.length==0)
    {
        message = @"Please Enter Confirm Newpassword";
    }
    if (![forgotPasswordMobile.text isEqualToString: forgotPasswordMobile1.text])
    {
        message = @"Confirm Password Doesnot Match";
    }
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        
          [self updateUserProfileMethod];
    }
}


-(void)updateUserProfileMethod
{

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@edit_profile/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&password=%@",userIDStr,forgotPasswordMobile.text]];
    
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
                
                
                NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
                
                if ([msgStr isEqualToString:@"1"])
                {
                    [footerview endEditing:YES];
                    [footerview removeFromSuperview];
                    popview.hidden = YES;
                
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    [AlertController showMessage:@"Please try again." withTitle:@"Promo Analytics"];
                }
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
}





#pragma mark  Simple Login Method

-(void)loginBtnAction:(UIButton*)sender
{
    
   [emailTF resignFirstResponder];
    [passWordTF resignFirstResponder];
    
    NSString *message;
    
    if (emailTF.text.length<=0)
    {
        message = @"Please enter valid Email/Mobile number.";
    }
    else if (passWordTF.text.length<=0)
    {
        message = @"Please enter Password.";
    }
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        
        [self simpleLoginMethod];
        
    }
}

-(void)simpleLoginMethod
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@login/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"mobile=%@&password=%@&is_social=%@",emailTF.text,passWordTF.text,@"0"]];
    
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
                
                NSString * messageStr=[jsonResponce valueForKey:@"message"];
                
                if ([messageStr isEqualToString:@"User Login"])
                {
                    
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    NSString * userID=[NSString stringWithFormat:@"%@",[dataArray valueForKey:@"user_id"]];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:userID forKey:@"saveUserID"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                   // UITabBarController * mapvc=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
                   // [self.navigationController pushViewController:mapvc animated:YES];
                    
                   // [AlertController showMessage:@"Successfully" withTitle:@"Promo Analytics"];
                    
                    
                    MapViewController *map=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                    [self.navigationController pushViewController:map animated:YES];
                    
                    
//                    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    // this any item in list you want navigate to
//                    MapViewController *home = (MapViewController *) [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
//                    
//                    SidebarViewController *slidemenu = (SidebarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SidebarViewController"];
//                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
//                    UINavigationController *smVC = [[UINavigationController alloc]initWithRootViewController:slidemenu];
//                    // define rear and frontviewcontroller
//                    SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:smVC frontViewController:nav];
//                    self.window.rootViewController=revealController;
                    
                }
                
                else  if ([messageStr isEqualToString:@"Wrong Credentials"])
                {
                    
                    [AlertController showMessage:@"You are entered Wrong Credentials please try again." withTitle:@"Promo Analytics"];
                }
                else if ([messageStr isEqualToString:@"User not exist"])
                {
                    [AlertController showMessage:@"User not Register with PromoAnalytics Please Register." withTitle:@"Promo Analytics"];
                    
                }
                
                
                
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
}




#pragma mark  FaceBook Login Method

-(void)facebookBtnAction:(UIButton*)sender
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            //self.lblReturn.text = [NSString stringWithFormat:@"FB: %@", error];
            // NSLog(@"%@",error);
            [DejalBezelActivityView removeView];
            
        } else if (result.isCancelled) {
            // Handle cancellations
            //NSLog(@"FB Cancelled");
            [DejalBezelActivityView removeView];
            
        } else {
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"email,name,first_name,last_name,gender,birthday,picture.width(100).height(100)"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         
                         
                        // NSLog(@"fetched user:%@", result);
                         
                         [DejalBezelActivityView removeView];
                         
                         socialEmailStr=[result valueForKey:@"email"];
                         
                         [self socialLoginMethod];
                         
                     }
                 }];
                
            }
        }
        
    }];
    
}

-(void)socialLoginMethod
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@login/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"mobile=%@&is_social=%@",socialEmailStr,@"1"]];
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
                
               NSLog(@"responce %@",jsonResponce);
                
                NSString * messageStr=[jsonResponce valueForKey:@"message"];
                
                if ([messageStr isEqualToString:@"User Login"])
                {
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    
                     NSString * userID=[NSString stringWithFormat:@"%@",[dataArray valueForKey:@"user_id"]];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:userID forKey:@"saveUserID"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                   // UITabBarController * mapvc=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
                  //  [self.navigationController pushViewController:mapvc animated:YES];
                    
                    // [AlertController showMessage:@"Successfully" withTitle:@"Promo Analytics"];
                    
                    MapViewController *map=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                    [self.navigationController pushViewController:map animated:YES];

                    
                    FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
                    [loginmanager logOut];
                    
                }
                
                else  if ([messageStr isEqualToString:@"Wrong Credentials"])
                {
                    
                    [AlertController showMessage:@"You are entered Wrong Credentials please try again." withTitle:@"Promo Analytics"];
                }
                else if ([messageStr isEqualToString:@"User not exist"])
                {
                  [AlertController showMessage:@"User not Register with PromoAnalytics Please Register." withTitle:@"Promo Analytics"];
                    
                }
                
                
            }
        }];
        
    }];
    
    [dataTask resume];

}



#pragma mark  Google SognIn Login Method

-(void)googleSignInBtnAction:(UIButton*)sender
{
    //NSLog(@"google signIn login");
    [[GIDSignIn sharedInstance] signInSilently];
    [GIDSignIn sharedInstance].delegate=self;
    [GIDSignIn sharedInstance].uiDelegate=self;
    [[GIDSignIn sharedInstance] signIn];
    
}



- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    [DejalBezelActivityView removeView];
    
    //    NSString *userId = user.userID;
    //    NSString *idToken = user.authentication.idToken;
    //    NSString *givenName = user.profile.givenName;
    //    NSString *familyName = user.profile.familyName;
    
    NSString * fullName= user.profile.name;
    NSString *email = user.profile.email;
    
    
    NSLog(@"%@",fullName);
    NSLog(@"%@",email);
    
    if (googleLogin==0) {
        
        if (email == (id)[NSNull null] || email.length == 0)
        {
            // [self dismissViewControllerAnimated:YES completion:nil];
             [DejalBezelActivityView removeView];
        }
        else{
            
            socialEmailStr=email;
            
            [self socialLoginMethod];
            
            [[GIDSignIn sharedInstance] signOut];
        }
     
    }
    else {
   
        if (email == (id)[NSNull null] || email.length == 0)
        {
            // [self dismissViewControllerAnimated:YES completion:nil];
            [DejalBezelActivityView removeView];
        }
        else{
            
            [DejalBezelActivityView removeView];
            
           // NSArray * nameArray=[fullName componentsSeparatedByString:@" "];
            
            SocialRegisterVC* srvc=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialRegisterVC"];
            [self.navigationController pushViewController:srvc animated:YES];
            
            srvc.firstNameStr=user.profile.name;
//            srvc.lastNameStr =[nameArray objectAtIndex:1];
            srvc.emailNameStr= user.profile.email;
            
            [[GIDSignIn sharedInstance] signOut];
            
        }
        
    }
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
   
    [DejalBezelActivityView removeView];
    
    //NSLog(@"%@",error.localizedDescription);
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
     [DejalBezelActivityView removeView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark  RegisterView Method

-(void)registarationViewMethod
{
    
   registerView=[[UIScrollView alloc]initWithFrame:CGRectMake(10,loginRegSegment.frame.origin.y+45, self.view.frame.size.width-20, 720)];
    //User name Fields
    registerView.backgroundColor = [UIColor clearColor];
    [scrollVwLR addSubview:registerView];
    scrollVwLR.contentSize=CGSizeMake(self.view.frame.size.width, registerView.frame.size.height+210);
    
    userNmVwRegistr=[[UIView alloc]initWithFrame:CGRectMake(10, 30, loginView.frame.size.width-20, 40)];
    userNmVwRegistr.backgroundColor = [UIColor clearColor];
    [[userNmVwRegistr layer] setBorderWidth:2.0f];
    [[userNmVwRegistr layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    userNmVwRegistr.clipsToBounds=YES;
    [registerView addSubview:userNmVwRegistr];
    
    userNmimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    userNmimage.image=[UIImage imageNamed:@"user-grey.png"];
    [userNmVwRegistr addSubview: userNmimage];
    
    firstNameTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, userNmVwRegistr.frame.size.width-35, 38)];
    firstNameTFReg.textColor=[UIColor darkGrayColor];
    firstNameTFReg.borderStyle = UITextBorderStyleNone;
    firstNameTFReg.font = [UIFont systemFontOfSize:15];
    firstNameTFReg.placeholder = @"Name";
    firstNameTFReg.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameTFReg.keyboardType = UIKeyboardTypeDefault;
    firstNameTFReg.returnKeyType = UIReturnKeyDone;
    firstNameTFReg.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstNameTFReg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    firstNameTFReg.delegate=self;
     [userNmVwRegistr addSubview:firstNameTFReg];
    
    userNameLblReg=[[UILabel alloc]initWithFrame:CGRectMake(userNmVwRegistr.frame.origin.x, userNmVwRegistr.frame.origin.y-24, 140, 20)];
    userNameLblReg.text=@"Name";
    userNameLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    userNameLblReg.backgroundColor = [UIColor clearColor];
    userNameLblReg.textColor = [UIColor darkGrayColor];
    userNameLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:userNameLblReg];
    
    
    
    //gender fields
    genderLblReg=[[UILabel alloc]initWithFrame:CGRectMake(userNmVwRegistr.frame.origin.x, userNmVwRegistr.frame.size.height+userNmVwRegistr.frame.origin.y+10, 140, 20)];
    genderLblReg.text=@"Gender";
    genderLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    genderLblReg.backgroundColor = [UIColor clearColor];
    genderLblReg.textColor = [UIColor darkGrayColor];
    genderLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:genderLblReg];
   
    maleb=[[UIImageView alloc]initWithFrame:CGRectMake(userNmVwRegistr.frame.origin.x, genderLblReg.frame.size.height+genderLblReg.frame.origin.y+10, 20, 20)];
    maleb.image=[UIImage imageNamed:@"uncheck.png"];
    maleb.contentMode = UIViewContentModeScaleAspectFill;
    [registerView addSubview:maleb];
    
    UILabel *malelab=[[UILabel alloc] initWithFrame:CGRectMake(maleb.frame.size.width+maleb.frame.origin.x+2, genderLblReg.frame.size.height+genderLblReg.frame.origin.y+5, 50, 30)];
    malelab.text=@"Male";
    malelab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    malelab.font=[UIFont systemFontOfSize:15];
    [registerView addSubview:malelab];
    
    
    UIButton *malebutt=[[UIButton alloc] initWithFrame:CGRectMake(userNmVwRegistr.frame.origin.x, genderLblReg.frame.size.height+genderLblReg.frame.origin.y+5, 80, 30)];
    [malebutt addTarget:self action:@selector(MaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    malebutt.backgroundColor=[UIColor clearColor];
    [registerView addSubview:malebutt];
    
    
    femaleb=[[UIImageView alloc]initWithFrame:CGRectMake(malelab.frame.size.width+malelab.frame.origin.x+20, genderLblReg.frame.size.height+genderLblReg.frame.origin.y+10, 20, 20)];
    femaleb.image=[UIImage imageNamed:@"uncheck.png"];
    femaleb.contentMode = UIViewContentModeScaleAspectFill;
    [registerView addSubview:femaleb];
    
    UILabel *femalelab=[[UILabel alloc] initWithFrame:CGRectMake(femaleb.frame.size.width+femaleb.frame.origin.x+2, genderLblReg.frame.size.height+genderLblReg.frame.origin.y+5, 50, 30)];
    femalelab.text=@"Female";
    femalelab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    femalelab.font=[UIFont systemFontOfSize:15];
    [registerView addSubview:femalelab];
    
    UIButton *femalebutt=[[UIButton alloc] initWithFrame:CGRectMake(malelab.frame.size.width+malelab.frame.origin.x+20, genderLblReg.frame.size.height+genderLblReg.frame.origin.y+5, 80, 30)];
    [femalebutt addTarget:self action:@selector(FemaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    femalebutt.backgroundColor=[UIColor clearColor];
    [registerView addSubview:femalebutt];
    
    
    
    
    
    
    
    //Dob  Fields
    DobViewTfVW=[[UIView alloc]initWithFrame:CGRectMake(10, malelab.frame.size.height+malelab.frame.origin.y+30, loginView.frame.size.width-20, 40)];
    DobViewTfVW.backgroundColor = [UIColor clearColor];
    [[DobViewTfVW layer] setBorderWidth:2.0f];
    [[DobViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    DobViewTfVW.clipsToBounds=YES;
    [registerView addSubview:DobViewTfVW];
    
    
    Dobimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    Dobimage.image=[UIImage imageNamed:@"dob.png"];
    [DobViewTfVW addSubview: Dobimage];
    
    dobTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, DobViewTfVW.frame.size.width-35, 38)];
    dobTFReg.textColor=[UIColor darkGrayColor];
    dobTFReg.borderStyle = UITextBorderStyleNone;
    dobTFReg.font = [UIFont systemFontOfSize:15];
    dobTFReg.placeholder = @"DD/MM/YYYY";
    dobTFReg.autocorrectionType = UITextAutocorrectionTypeNo;
    dobTFReg.returnKeyType = UIReturnKeyDone;
    dobTFReg.clearButtonMode = UITextFieldViewModeWhileEditing;
    dobTFReg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [dobTFReg setKeyboardType:UIKeyboardTypeEmailAddress];
    dobTFReg.delegate=self;
    [DobViewTfVW addSubview:dobTFReg];
    
    DobLblReg=[[UILabel alloc]initWithFrame:CGRectMake(DobViewTfVW.frame.origin.x, DobViewTfVW.frame.origin.y-24, 140, 20)];
    DobLblReg.text=@"DOB";
    DobLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    DobLblReg.backgroundColor = [UIColor clearColor];
    DobLblReg.textColor = [UIColor darkGrayColor];
    DobLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:DobLblReg];

    
    UIButton *Dobbutt=[[UIButton alloc] initWithFrame:CGRectMake(10, malelab.frame.size.height+malelab.frame.origin.y+30, loginView.frame.size.width-20, 40)];
    [Dobbutt addTarget:self action:@selector(DobButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    Dobbutt.backgroundColor=[UIColor clearColor];
    [registerView addSubview:Dobbutt];
    
    


    
    //Email  Fields
    emailViewTfVW=[[UIView alloc]initWithFrame:CGRectMake(10, DobViewTfVW.frame.size.height+DobViewTfVW.frame.origin.y+30, loginView.frame.size.width-20, 40)];
    emailViewTfVW.backgroundColor = [UIColor clearColor];
    [[emailViewTfVW layer] setBorderWidth:2.0f];
    [[emailViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    emailViewTfVW.clipsToBounds=YES;
    [registerView addSubview:emailViewTfVW];
    
    
    emailimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    emailimage.image=[UIImage imageNamed:@"email.png"];
    [emailViewTfVW addSubview: emailimage];
    
    emailTFRegister=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, emailViewTfVW.frame.size.width-35, 38)];
    emailTFRegister.textColor=[UIColor darkGrayColor];
    emailTFRegister.borderStyle = UITextBorderStyleNone;
    emailTFRegister.font = [UIFont systemFontOfSize:15];
    emailTFRegister.placeholder = @"Email";
    emailTFRegister.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTFRegister.returnKeyType = UIReturnKeyDone;
    emailTFRegister.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTFRegister.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [emailTFRegister setKeyboardType:UIKeyboardTypeEmailAddress];
    emailTFRegister.delegate=self;
    [emailViewTfVW addSubview:emailTFRegister];
    
    emailLblReg=[[UILabel alloc]initWithFrame:CGRectMake(emailViewTfVW.frame.origin.x, emailViewTfVW.frame.origin.y-24, 140, 20)];
    emailLblReg.text=@"Email Address";
    emailLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    emailLblReg.backgroundColor = [UIColor clearColor];
    emailLblReg.textColor = [UIColor darkGrayColor];
    emailLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:emailLblReg];
    
    //Phone number Fields
    phoneViewTfVW=[[UIView alloc]initWithFrame:CGRectMake(10, emailViewTfVW.frame.origin.y+70, loginView.frame.size.width-20, 40)];
    phoneViewTfVW.backgroundColor = [UIColor clearColor];
    [[phoneViewTfVW layer] setBorderWidth:2.0f];
    [[phoneViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    phoneViewTfVW.clipsToBounds=YES;
    [registerView addSubview:phoneViewTfVW];
    
    
   phnNumImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    phnNumImage.image=[UIImage imageNamed:@"call-2.png"];
    [phoneViewTfVW addSubview: phnNumImage];
    
    phoneNumTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, phoneViewTfVW.frame.size.width-35, 38)];
    phoneNumTFReg.borderStyle = UITextBorderStyleNone;
    phoneNumTFReg.textColor=[UIColor darkGrayColor];
    phoneNumTFReg.font = [UIFont systemFontOfSize:15];
    phoneNumTFReg.placeholder = @"Phone Number";
    phoneNumTFReg.autocorrectionType = UITextAutocorrectionTypeNo;
    phoneNumTFReg.returnKeyType = UIReturnKeyDone;
    phoneNumTFReg.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumTFReg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneNumTFReg setKeyboardType:UIKeyboardTypeNumberPad];
    phoneNumTFReg.delegate=self;
    [phoneViewTfVW addSubview:phoneNumTFReg];
    
    phnLblReg=[[UILabel alloc]initWithFrame:CGRectMake(phoneViewTfVW.frame.origin.x, phoneViewTfVW.frame.origin.y-24, 140, 20)];
    phnLblReg.text=@"Phone Number";
    phnLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    phnLblReg.backgroundColor = [UIColor clearColor];
    phnLblReg.textColor = [UIColor darkGrayColor];
    phnLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:phnLblReg];
    
    //PassWord Fields
    passWrdTFVW=[[UIView alloc]initWithFrame:CGRectMake(10, phoneViewTfVW.frame.origin.y+70, loginView.frame.size.width-20, 40)];
    passWrdTFVW.backgroundColor = [UIColor clearColor];
    [[passWrdTFVW layer] setBorderWidth:2.0f];
    [[passWrdTFVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    passWrdTFVW.clipsToBounds=YES;
    [registerView addSubview:passWrdTFVW];
    
    
    passWrgImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    passWrgImage.image=[UIImage imageNamed:@"password.png"];
    [passWrdTFVW addSubview: passWrgImage];
    
    passWordTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, passWrdTFVW.frame.size.width-35, 38)];
    passWordTFReg.borderStyle = UITextBorderStyleNone;
    passWordTFReg.font = [UIFont systemFontOfSize:15];
    passWordTFReg.placeholder = @"password";
    passWordTFReg.textColor=[UIColor darkGrayColor];
    passWordTFReg.autocorrectionType = UITextAutocorrectionTypeNo;
    passWordTFReg.returnKeyType = UIReturnKeyDone;
    passWordTFReg.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordTFReg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passWordTFReg setKeyboardType:UIKeyboardTypeDefault];
    [passWordTFReg setSecureTextEntry:YES];
     passWordTFReg.delegate=self;
    [passWrdTFVW addSubview:passWordTFReg];
    
    pwLblReg=[[UILabel alloc]initWithFrame:CGRectMake(passWrdTFVW.frame.origin.x, passWrdTFVW.frame.origin.y-24, 140, 20)];
    pwLblReg.text=@"Password";
    pwLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    pwLblReg.backgroundColor = [UIColor clearColor];
    pwLblReg.textColor = [UIColor darkGrayColor];
    pwLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:pwLblReg];
    
   //Re enter PW Fields
    reEnterPWTfVW=[[UIView alloc]initWithFrame:CGRectMake(10, passWrdTFVW.frame.origin.y+70, loginView.frame.size.width-20, 40)];
    reEnterPWTfVW.backgroundColor = [UIColor clearColor];
    [[reEnterPWTfVW layer] setBorderWidth:2.0f];
    [[reEnterPWTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    reEnterPWTfVW.clipsToBounds=YES;
    [registerView addSubview:reEnterPWTfVW];
    
    
    ReEnterPWImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    ReEnterPWImage.image=[UIImage imageNamed:@"password.png"];
    [reEnterPWTfVW addSubview: ReEnterPWImage];
    
    reEnterPwTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, reEnterPWTfVW.frame.size.width-35, 38)];
    reEnterPwTFReg.borderStyle = UITextBorderStyleNone;
    reEnterPwTFReg.font = [UIFont systemFontOfSize:15];
    reEnterPwTFReg.placeholder = @"Re-enter Pasword";
    reEnterPwTFReg.textColor=[UIColor darkGrayColor];
    reEnterPwTFReg.autocorrectionType = UITextAutocorrectionTypeNo;
    reEnterPwTFReg.returnKeyType = UIReturnKeyDone;
    reEnterPwTFReg.clearButtonMode = UITextFieldViewModeWhileEditing;
    reEnterPwTFReg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [reEnterPwTFReg setKeyboardType:UIKeyboardTypeDefault];
    [reEnterPwTFReg setSecureTextEntry:YES];
    reEnterPwTFReg.delegate=self;
    [reEnterPWTfVW addSubview:reEnterPwTFReg];
    
    reEntrPwLblReg=[[UILabel alloc]initWithFrame:CGRectMake(reEnterPWTfVW.frame.origin.x, reEnterPWTfVW.frame.origin.y-24, 140, 20)];
    reEntrPwLblReg.text=@"Re-enter password";
    reEntrPwLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    reEntrPwLblReg.backgroundColor = [UIColor clearColor];
    reEntrPwLblReg.textColor = [UIColor darkGrayColor];
    reEntrPwLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:reEntrPwLblReg];
    
    acceptCondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptCondBtn.frame = CGRectMake(10, reEnterPWTfVW.frame.origin.y+50, 30, 30);
    [acceptCondBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [acceptCondBtn addTarget:self action:@selector(termsandCondtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   [acceptCondBtn setSelected:YES];
    [registerView addSubview:acceptCondBtn];
    
    
    UILabel*termsLbl=[[UILabel alloc]initWithFrame:CGRectMake(acceptCondBtn.frame.origin.x+35, acceptCondBtn.frame.origin.y, 300, 30)];
    termsLbl.backgroundColor = [UIColor whiteColor];
    termsLbl.textAlignment = NSTextAlignmentLeft;
    UIColor *highlightColor2 = [UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    UIColor *normalColor2 = [UIColor darkGrayColor];
    UIFont *font3 = [UIFont boldSystemFontOfSize:13.0];
    UIFont *font4 = [UIFont systemFontOfSize:13.0];
    NSDictionary *highlightAttributes2 = @{NSFontAttributeName:font3, NSForegroundColorAttributeName:highlightColor2};
    NSDictionary *normalAttributes2 = @{NSFontAttributeName:font4, NSForegroundColorAttributeName:normalColor2};
    NSAttributedString *normalText2 = [[NSAttributedString alloc] initWithString:@"I accept all the " attributes:normalAttributes2];
    NSAttributedString *highlightedText3= [[NSAttributedString alloc] initWithString:@"terms and conditions" attributes:highlightAttributes2];
    NSMutableAttributedString *finalAttributedString2 = [[NSMutableAttributedString alloc] initWithAttributedString:normalText2];
    [finalAttributedString2 appendAttributedString:highlightedText3];
    termsLbl.attributedText = finalAttributedString2;
    [registerView addSubview:termsLbl];
    
    
    
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame=CGRectMake(10,acceptCondBtn.frame.origin.y+50, registerView.frame.size.width-20, 40);
    registerButton.backgroundColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    [registerButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    registerButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [registerButton addTarget:self action:@selector(registartionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.cornerRadius=20;
    registerButton.clipsToBounds=YES;
    [registerView addSubview:registerButton];
    
    
    UILabel * orLabel =[[UILabel alloc]initWithFrame:CGRectMake(registerView.frame.size.width/2-110, registerButton.frame.origin.y+85, 220, 30)];
    orLabel.text=@"OR REGISTER WITH SOCIAL ACCOUNT";
    orLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textColor = [UIColor darkGrayColor];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [registerView addSubview:orLabel];
   // orLabel.layer.cornerRadius=15;
   // orLabel.clipsToBounds=YES;
   // [[orLabel layer] setBorderWidth:2.0];
   // [[orLabel layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    
    UILabel * leftLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, orLabel.frame.origin.y+14, registerView.frame.size.width/2-120, 1)];
    leftLbl.backgroundColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    [registerView addSubview:leftLbl];
    
    UILabel * rightLbl =[[UILabel alloc]initWithFrame:CGRectMake(orLabel.frame.origin.x+orLabel.frame.size.width+10, orLabel.frame.origin.y+14, registerView.frame.size.width/2-120, 1)];
    rightLbl.backgroundColor=[UIColor colorWithRed:238/255.0f green:63/255.0f blue:55/255.0f alpha:1.0f];
    [registerView addSubview:rightLbl];
    
    
    
    faceBookBtnregistrtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBookBtnregistrtn.frame=CGRectMake(registerView.frame.size.width/2-50,orLabel.frame.origin.y+40, 40, 40);
    [faceBookBtnregistrtn setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [faceBookBtnregistrtn addTarget:self action:@selector(facebookBtnRegistartionAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:faceBookBtnregistrtn];
    
    
    googlePlusBtnregistrtn = [UIButton buttonWithType:UIButtonTypeCustom];
    googlePlusBtnregistrtn.frame=CGRectMake(registerView.frame.size.width/2+10,faceBookBtnregistrtn.frame.origin.y, 40, 40);
    [googlePlusBtnregistrtn setImage:[UIImage imageNamed:@"google90"] forState:UIControlStateNormal];
    [googlePlusBtnregistrtn addTarget:self action:@selector(googleSignInRegistartionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:googlePlusBtnregistrtn];
    
}


#pragma mark - MaleButton Clicked

-(IBAction)MaleButtonClicked:(id)sender
{
    maleb.image=[UIImage imageNamed:@"Check.png"];
    femaleb.image=[UIImage imageNamed:@"uncheck.png"];
    strgender=@"m";
}


#pragma mark - FemaleButton Clicked

-(IBAction)FemaleButtonClicked:(id)sender
{
    maleb.image=[UIImage imageNamed:@"uncheck.png"];
    femaleb.image=[UIImage imageNamed:@"Check.png"];
    strgender=@"f";
}


- (IBAction)DobButtClicked:(id)sender
{
    [firstNameTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    [passWordTFReg resignFirstResponder];
    [reEnterPwTFReg resignFirstResponder];
    [[DobViewTfVW layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
    
    popview = [[ UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-160, 300, 40)];
    topView.backgroundColor=[UIColor whiteColor];
    [popview addSubview:topView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(70, 5, topView.frame.size.width-140, 30)];
    label.text=@"Select Date";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:29.0/255.0f green:29.0/255.0f blue:38.0/255.0f alpha:1.0];
    label.font=[UIFont boldSystemFontOfSize:16];
    [topView addSubview:label];
    
    DoneButton2=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    [DoneButton2 setTitle:@"Cancel" forState:UIControlStateNormal];
    DoneButton2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    DoneButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [DoneButton2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [DoneButton2 addTarget:self action:@selector(save2:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:DoneButton2];
    
    DoneButton=[[UIButton alloc] initWithFrame:CGRectMake(topView.frame.size.width-60, 0, 60, 40)];
    [DoneButton setTitle:@"Done" forState:UIControlStateNormal];
    DoneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    DoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [DoneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [DoneButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    DoneButton.userInteractionEnabled=NO;
    [topView addSubview:DoneButton];
    
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-120,300, 240)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.backgroundColor=[UIColor colorWithRed:105.0/255.0f green:43.0/255.0f blue:82.0/255.0f alpha:1.0];
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [popview addSubview:datePicker];
}


-(void)LabelTitle:(id)sender
{
    DoneButton.userInteractionEnabled=YES;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    strage=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    
    NSArray *arrdata=[strage componentsSeparatedByString:@"/"];
    NSString *strDateofbirth=[NSString stringWithFormat:@"%@/%@/%@",arrdata[1],arrdata[0],arrdata[2]];
    
    dobTFReg.text=strDateofbirth;
}

-(void)save:(id)sender
{
    [[DobViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    self.navigationItem.rightBarButtonItem=nil;
    [datePicker removeFromSuperview];
    [popview removeFromSuperview];
}

-(void)save2:(id)sender
{
    [[DobViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    self.navigationItem.rightBarButtonItem=nil;
    [datePicker removeFromSuperview];
    [popview removeFromSuperview];
}






-(void)termsandCondtnBtnAction:(UIButton*)sender
{
    if ([sender isSelected])
    {
        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        termsCondString=@"1";
        
        
    } else {
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        
         termsCondString=@"0";
    }
}


#pragma mark  Simple Registaration Method

-(void)registartionBtnAction:(UIButton*)sender
{
    
    [firstNameTFReg resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    [passWordTFReg resignFirstResponder];
    [reEnterPwTFReg resignFirstResponder];

    
    NSString *message;
    
    if (firstNameTFReg.text.length<=0)
    {
        message = @"Please enter User name.";
    }
    else if (strgender == (id)[NSNull null] || strgender.length == 0 )
    {
        message = @"Please Select gender.";
    }
    else if (dobTFReg.text.length<=0)
    {
        message = @"Please Select Date of birth";
    }
    else if (![textFieldValidation validateEmail:emailTFRegister.text])
    {
        message =@"Please enter valid Email";
    }
    else if (phoneNumTFReg.text.length<=9 || phoneNumTFReg.text.length>=11 )
    {
        message =@"Please enter valid number.";
        
    }
    else if (passWordTFReg.text.length<=0)
    {
        message = @"Please enter Password";
    }
    else if (![passWordTFReg.text isEqualToString: reEnterPwTFReg.text])
    {
        message = @"Re-entered Password Doesnot match Please try again";
    }
    else if ([termsCondString isEqualToString:@"0"])
    {
        message = @"Please accept all the terms and conditiond";
    }
    
    
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        
        [self simpleRegistarationAPI];
        
    }
}


-(void)simpleRegistarationAPI
{
     [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@register/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"name=%@&gender=%@&dob=%@&email=%@&mobile=%@&password=%@&is_social=%@",firstNameTFReg.text,strgender,strage,emailTFRegister.text,phoneNumTFReg.text,passWordTFReg.text,@"0"]];
    
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
                
                NSLog(@"responce %@",jsonResponce);
               
                NSString * messageStr=[jsonResponce valueForKey:@"message"];
                
                if ([messageStr isEqualToString:@"register success"])
                {
                    
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    
                     NSString * userID=[NSString stringWithFormat:@"%@",[dataArray valueForKey:@"user_id"]];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:userID forKey:@"saveUserID"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                   // UITabBarController * mapvc=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
                  //  [self.navigationController pushViewController:mapvc animated:YES];
                    
                    MapViewController *map=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                    [self.navigationController pushViewController:map animated:YES];

                    
                    [AlertController showMessage:@"User Successfully registered" withTitle:@"Promo Analytics"];
                    
                }
                
              else  if ([messageStr isEqualToString:@"Mobile or Email already exist"])
                {
                    
                    [AlertController showMessage:@"User already exist" withTitle:@"Promo Analytics"];
                }
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
    
}



#pragma mark  FaceBook Registaration Method

-(void)facebookBtnRegistartionAction:(UIButton*)sender
{
    
//    passWordTFReg.hidden=YES;
//    phnLbl.hidden=YES;
//    phnImage.hidden=YES;
//    acceptCondBtn.frame = CGRectMake(10, phoneNumTFReg.frame.origin.y+50, 30, 30);
    
    
    [firstNameTFReg resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    [passWordTFReg resignFirstResponder];
    [reEnterPwTFReg resignFirstResponder];

    
//    NSString *message;
//
//     if (phoneNumTFReg.text.length<=9 || phoneNumTFReg.text.length>=11 )
//    {
//        message =@"Please enter valid number.";
//        
//    }
//      else{
    

        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
                //self.lblReturn.text = [NSString stringWithFormat:@"FB: %@", error];
                // NSLog(@"%@",error);
                [DejalBezelActivityView removeView];
                
            } else if (result.isCancelled) {
                // Handle cancellations
                //NSLog(@"FB Cancelled");
                [DejalBezelActivityView removeView];
//                passWordTFReg.hidden=NO;
//                phnLbl.hidden=NO;
//                phnImage.hidden=NO;
//                acceptCondBtn.frame = CGRectMake(10, passWordTFReg.frame.origin.y+50, 30, 30);
                
            } else {
                
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"]) {
                    // Do work
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"email,name,first_name,last_name,gender,birthday,picture.width(100).height(100)"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                             
                             [DejalBezelActivityView removeView];
                             
                           
                             
                             
                            SocialRegisterVC* srvc=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialRegisterVC"];
                             
                             [self.navigationController pushViewController:srvc animated:YES];
                             
                             srvc.firstNameStr=[result valueForKey:@"name"];
                             
                             srvc.emailNameStr=[result valueForKey:@"email"];
                            
                             
                             
                             
                         }
                     }];
                    
                 }
             }
            
        }];
        
   //}
  
}





#pragma mark  Google SognIn Registaration Method

-(void)googleSignInRegistartionBtnAction:(UIButton*)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    

    [firstNameTFReg resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    [passWordTFReg resignFirstResponder];
    [reEnterPwTFReg resignFirstResponder];

    
    [[GIDSignIn sharedInstance] signInSilently];
    [GIDSignIn sharedInstance].delegate=self;
    [GIDSignIn sharedInstance].uiDelegate=self;
    [[GIDSignIn sharedInstance] signIn];
}



#pragma mark  UITextfield Delegates



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateTextField:textField up:YES];
    
    //[(ACFloatingTextField *)textField textFieldDidBeginEditing];
    if (textField==emailTF)
    {
        emailImage.image=[UIImage imageNamed:@"user-red.png"];
        emailLbl.textColor = [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[userNmVw layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
       // emailImage.image=[UIImage imageNamed:@"mailBlue"];
    }
    else if (textField==passWordTF)
    {
         pwImage.image=[UIImage imageNamed:@"password-red.png"];
        pwLabel.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[passWrdVw layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
       // pwImage.image=[UIImage imageNamed:@"passwordBlue"];
    }
    else if (textField==firstNameTFReg)
    {
        userNameLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[userNmVwRegistr layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
        userNmimage.image=[UIImage imageNamed:@"user-red.png"];
    }
    else if (textField==emailTFRegister)
    {
        emailLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[emailViewTfVW layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
        
        emailimage.image=[UIImage imageNamed:@"email_red.png"];
    }
    else if (textField==phoneNumTFReg)
    {
        phnLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[phoneViewTfVW layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
        phnNumImage.image=[UIImage imageNamed:@"call_red.png"];
    }
    else if (textField==passWordTFReg)
    {
        pwLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[passWrdTFVW layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
        passWrgImage.image=[UIImage imageNamed:@"password-red.png"];
    }
    else if (textField==reEnterPwTFReg)
    {
        reEntrPwLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[reEnterPWTfVW layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
        ReEnterPWImage.image=[UIImage imageNamed:@"password-red.png"];
    }
    else if (textField==forgotPasswordMobile)
    {
        //reEntrPwLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[forgotpassNmVw layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
    }
    else if (textField==forgotPasswordMobile1)
    {
        //reEntrPwLblReg.textColor =  [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[forgotpassNmVw1 layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    //[(ACFloatingTextField *)textField textFieldDidEndEditing];
    
    if (textField==emailTF)
    {
        emailImage.image=[UIImage imageNamed:@"user-grey.png"];
        emailLbl.textColor = [UIColor darkGrayColor];
        [[userNmVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
       // emailImage.image=[UIImage imageNamed:@"email"];
    }
    else if (textField==passWordTF)
    {
        pwImage.image=[UIImage imageNamed:@"password.png"];
        pwLabel.textColor = [UIColor darkGrayColor];
        [[passWrdVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
       // pwImage.image=[UIImage imageNamed:@"password"];
    }
    else if (textField==firstNameTFReg)
    {
        userNameLblReg.textColor = [UIColor darkGrayColor];
        [[userNmVwRegistr layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
        userNmimage.image=[UIImage imageNamed:@"user-grey.png"];
    }
    else if (textField==emailTFRegister)
    {
        emailLblReg.textColor = [UIColor darkGrayColor];
        [[emailViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
        emailimage.image=[UIImage imageNamed:@"email.png"];
    }
    else if (textField==phoneNumTFReg)
    {
        phnLblReg.textColor = [UIColor darkGrayColor];
        [[phoneViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
        phnNumImage.image=[UIImage imageNamed:@"call-2.png"];
    }
    else if (textField==passWordTFReg)
    {
        pwLblReg.textColor = [UIColor darkGrayColor];
        [[passWrdTFVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
        passWrgImage.image=[UIImage imageNamed:@"password.png"];
    }
    else if (textField==reEnterPwTFReg)
    {
        reEntrPwLblReg.textColor = [UIColor darkGrayColor];
        [[reEnterPWTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
        ReEnterPWImage.image=[UIImage imageNamed:@"password.png"];
    }
    else if (textField==forgotPasswordMobile)
    {
        [[forgotpassNmVw layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    }
    else if (textField==forgotPasswordMobile1)
    {
        [[forgotpassNmVw1 layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
    if (textField==emailTFRegister)
    {
        const int movementDistance = -60; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    else if (textField==phoneNumTFReg)
    {
        const int movementDistance = -120; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    else if (textField==passWordTFReg)
    {
        const int movementDistance = -150; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    else if (textField==reEnterPwTFReg)
    {
        const int movementDistance = -170; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    
    else if (textField==emailTF)
    {
        const int movementDistance = -60; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    else if (textField==passWordTF)
    {
        const int movementDistance = -80; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
        
    }
}


- (void)dismissKeyboard
{
    [emailTF resignFirstResponder];
    [passWordTF resignFirstResponder];
    
    [firstNameTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    [passWordTFReg resignFirstResponder];
    [reEnterPwTFReg resignFirstResponder];
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
    transition.duration = 1.0;//kAnimationDuration
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
    transition.duration = 1.0;//kAnimationDuration
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
