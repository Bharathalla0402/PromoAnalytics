//
//  SocialRegisterVC.m
//  PromoAnalytics
//
//  Created by amit on 3/27/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "SocialRegisterVC.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import "ACFloatingTextField.h"
#import "MapViewController.h"
#import "SidebarViewController.h"

@interface SocialRegisterVC ()<UITextFieldDelegate,MyProtocolDelegate,NSURLSessionDelegate>
{
    MyProtocol*AlertController;
    Validation*textFieldValidation;

    
    
    UIView * registerView;
    UITextField *firstNameTFReg;
    UITextField *emailTFRegister;
    UITextField *phoneNumTFReg;
    
    
    UIButton* acceptCondBtn;
    UIButton*  registerButton;
    
    UILabel* emailLbl;
    UIImageView* emailImage;
    UILabel*  pwLabel;
    UIImageView* pwImage;
    
    UIImageView*logoImage;
    NSString * termsCondString;
    
    UIView * phoneViewTfVW;
    UIImageView* phnNumImage;
    UILabel*userNameLblReg,*emailLblReg,*phnLblReg;
    UILabel *genderLblReg,*DobLblReg;
    
    UIImageView *maleb,*femaleb;
    NSString *strgender;
    NSString *strage,*userIDStr;
    
    UIView * DobViewTfVW;
    UIImageView* Dobimage;
     UITextField *dobTFReg;
    
    UIView *popview;
    UIView *footerview;
    
    UIDatePicker *datePicker;
    UIBarButtonItem *rightBtn;
    UIButton *DoneButton,*DoneButton2;
    
}
@end

@implementation SocialRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    termsCondString=@"0";
//    logoImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-66, 40, 132, 90)];
//    logoImage.image=[UIImage imageNamed:@"LogoImage"];
//    [self.view addSubview:logoImage];
    
    [self socialRegMethod];
    
    firstNameTFReg.delegate=self;
    emailTFRegister.delegate=self;
    phoneNumTFReg.delegate=self;
    
    
    firstNameTFReg.text=_firstNameStr;
  // lastNameTFReg.text=_lastNameStr;
    emailTFRegister.text=_emailNameStr;
    
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    textFieldValidation=[[Validation alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)socialRegMethod
{
    registerView=[[UIScrollView alloc]initWithFrame:CGRectMake(10,80, self.view.frame.size.width-20, self.view.frame.size.height-90)];
    
    registerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:registerView];
    
    
    UIView * userNmVwRegistr=[[UIView alloc]initWithFrame:CGRectMake(10, 30, registerView.frame.size.width-20, 40)];
    userNmVwRegistr.backgroundColor = [UIColor clearColor];
    [[userNmVwRegistr layer] setBorderWidth:2.0f];
    [[userNmVwRegistr layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    userNmVwRegistr.clipsToBounds=YES;
    [registerView addSubview:userNmVwRegistr];
    
    UIImageView* userNmimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    userNmimage.image=[UIImage imageNamed:@"user-grey.png"];
    [userNmVwRegistr addSubview: userNmimage];

    
    
    firstNameTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, userNmVwRegistr.frame.size.width-35, 38)];
    firstNameTFReg.textColor= [UIColor darkGrayColor];
    firstNameTFReg.borderStyle = UITextBorderStyleNone;
    firstNameTFReg.font = [UIFont systemFontOfSize:15];
    firstNameTFReg.placeholder = @"Name";
    firstNameTFReg.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameTFReg.keyboardType = UIKeyboardTypeDefault;
    firstNameTFReg.returnKeyType = UIReturnKeyDone;
    firstNameTFReg.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstNameTFReg.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    firstNameTFReg.delegate=self;
    firstNameTFReg.enabled=NO;
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
    DobViewTfVW=[[UIView alloc]initWithFrame:CGRectMake(10, malelab.frame.size.height+malelab.frame.origin.y+30, registerView.frame.size.width-20, 40)];
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
    
    
    UIButton *Dobbutt=[[UIButton alloc] initWithFrame:CGRectMake(10, malelab.frame.size.height+malelab.frame.origin.y+30, userNmVwRegistr.frame.size.width-20, 40)];
    [Dobbutt addTarget:self action:@selector(DobButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    Dobbutt.backgroundColor=[UIColor clearColor];
    [registerView addSubview:Dobbutt];
    

    
    
    
    
    
    
    
    
    
    
    
    
    UIView * emailViewTfVW=[[UIView alloc]initWithFrame:CGRectMake(10,  DobViewTfVW.frame.size.height+DobViewTfVW.frame.origin.y+30, registerView.frame.size.width-20, 40)];
    emailViewTfVW.backgroundColor = [UIColor clearColor];
    [[emailViewTfVW layer] setBorderWidth:2.0f];
    [[emailViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    emailViewTfVW.clipsToBounds=YES;
    [registerView addSubview:emailViewTfVW];
    
    
    UIImageView* emailimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
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
    emailTFRegister.enabled=NO;
    [emailViewTfVW addSubview:emailTFRegister];
    
    emailLblReg=[[UILabel alloc]initWithFrame:CGRectMake(emailViewTfVW.frame.origin.x, emailViewTfVW.frame.origin.y-24, 140, 20)];
    emailLblReg.text=@"Email Address";
    emailLblReg.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    emailLblReg.backgroundColor = [UIColor clearColor];
    emailLblReg.textColor = [UIColor darkGrayColor];
    emailLblReg.textAlignment = NSTextAlignmentLeft;
    [registerView addSubview:emailLblReg];
    
    
    phoneViewTfVW=[[UIView alloc]initWithFrame:CGRectMake(10, emailViewTfVW.frame.origin.y+70, registerView.frame.size.width-20, 40)];
    phoneViewTfVW.backgroundColor = [UIColor clearColor];
    [[phoneViewTfVW layer] setBorderWidth:2.0f];
    [[phoneViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    phoneViewTfVW.clipsToBounds=YES;
    [registerView addSubview:phoneViewTfVW];
    
    
    phnNumImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10,20,20)];
    phnNumImage.image=[UIImage imageNamed:@"call-2.png"];
    [phoneViewTfVW addSubview: phnNumImage];
    
    phoneNumTFReg=[[UITextField alloc]initWithFrame:CGRectMake(30, 1, phoneViewTfVW.frame.size.width-35, 38)];
    phoneNumTFReg.textColor=[UIColor darkGrayColor];
    phoneNumTFReg.borderStyle = UITextBorderStyleNone;
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
    
    
    acceptCondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptCondBtn.frame = CGRectMake(10, phoneViewTfVW.frame.origin.y+50, 30, 30);
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
        
        //NSLog(@"Conditon Button Selected %@",termsCondString);
        
    } else {
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        
        termsCondString=@"0";
        //NSLog(@"Conditon Button Not Selected %@",termsCondString);
        
    }

}



-(void)registartionBtnAction:(UIButton*)sender
{
    
    [firstNameTFReg resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    
    NSString *message;
    
    if (firstNameTFReg.text.length<=0)
    {
        message = @"Please enter First name.";
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
    else if ([termsCondString isEqualToString:@"0"])
    {
        message = @"Please accept all the terms and conditiond";
    }
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        

        [self socialRegistarationMethod];
        
    }

}





-(void)socialRegistarationMethod
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@register/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"name=%@&gender=%@&dob=%@&email=%@&mobile=%@&is_social=%@",firstNameTFReg.text,strgender,strage,emailTFRegister.text,phoneNumTFReg.text,@"1"]];
    
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
                
                //NSLog(@"responce %@",jsonResponce);
                
                NSString * messageStr=[jsonResponce valueForKey:@"message"];
                
                if ([messageStr isEqualToString:@"register success"])
                {
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    
                     NSString * userID=[NSString stringWithFormat:@"%@",[dataArray valueForKey:@"user_id"]];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:userID forKey:@"saveUserID"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                   // UITabBarController * mapvc=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
                   // [self.navigationController pushViewController:mapvc animated:YES];
                    
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


#pragma mark  TextField delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateTextField:textField up:YES];
    if (textField==phoneNumTFReg)
    {
        phnLblReg.textColor = [UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f];
        [[phoneViewTfVW layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
        phnNumImage.image=[UIImage imageNamed:@"call_red.png"];
    }
    
    //[(ACFloatingTextField *)textField textFieldDidBeginEditing];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     [self animateTextField:textField up:NO];
    if (textField==phoneNumTFReg)
    {
        phnLblReg.textColor = [UIColor darkGrayColor];
        [[phoneViewTfVW layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
        phnNumImage.image=[UIImage imageNamed:@"call-2.png"];
    }

    
    //[(ACFloatingTextField *)textField textFieldDidEndEditing];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (textField==phoneNumTFReg)
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
    }
}


- (void)dismissKeyboard
{
    
    [firstNameTFReg resignFirstResponder];
    [emailTFRegister resignFirstResponder];
    [phoneNumTFReg resignFirstResponder];
    
    
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
