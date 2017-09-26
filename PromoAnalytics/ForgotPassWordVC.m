//
//  ForgotPassWordVC.m
//  PromoAnalytics
//
//  Created by amit on 3/31/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "ForgotPassWordVC.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import "OTPViewController.h"

@interface ForgotPassWordVC ()<UITextFieldDelegate,MyProtocolDelegate,NSURLSessionDelegate>
{
    MyProtocol*AlertController;
    Validation*textFieldValidation;
    
    
    
}
@end

@implementation ForgotPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    textFieldValidation=[[Validation alloc]init];
    
    _emailMobTE.delegate=self;
    
    _continueBtn.layer.cornerRadius=22;
    _continueBtn.clipsToBounds=YES;
    
    [[_emailTFview layer] setBorderWidth:1.5f];
    [[_emailTFview layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    _emailTFview.clipsToBounds=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (IBAction)continueBtnAction:(id)sender {
    
    [_emailMobTE resignFirstResponder];
    
    NSString *message;
    
    if (_emailMobTE.text.length<=0)
    {
        message = @"Please enter valid Email/Mobile number.";
    }
    
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }
   else{
    
     [self forgotPassWordMethod];
    
}

}


-(void)forgotPassWordMethod
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@forget_password/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"mobile=%@",_emailMobTE.text]];
    
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
                    
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    
                    NSString * userIdStrOTP=[dataArray valueForKey:@"user_id"];
                    
                    OTPViewController * vc=[self.storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    vc.userIDStr=userIdStrOTP;
                    [AlertController showMessage:@"OTP send Successfully." withTitle:@"Promo Analytics"];
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                     [AlertController showMessage:@"User not Register with PromoAnalytics Please Register." withTitle:@"Promo Analytics"];
                }
                
                
                
            }
        }];
        
    }];
    
    [dataTask resume];
    
}



- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark  TextField delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_emailMobTE)
    {
        _emailLbl.textColor = [UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f];
        [[_emailTFview layer] setBorderColor:[UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f].CGColor];
        _emailImg.image=[UIImage imageNamed:@"mailBlue"];
    }
    
    //[(ACFloatingTextField *)textField textFieldDidBeginEditing];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_emailMobTE)
    {
        _emailLbl.textColor = [UIColor darkGrayColor];
        [[_emailTFview layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        _emailImg.image=[UIImage imageNamed:@"email"];
    }
    
    
    //[(ACFloatingTextField *)textField textFieldDidEndEditing];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)dismissKeyboard
{
    
    [_emailMobTE resignFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
