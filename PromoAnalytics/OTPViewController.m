//
//  OTPViewController.m
//  PromoAnalytics
//
//  Created by amit on 4/1/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "OTPViewController.h"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import "PromoUrl.pch"

#import "ConformPWVC.h"
@interface OTPViewController ()<UITextFieldDelegate,NSURLSessionDelegate,MyProtocolDelegate,CAAnimationDelegate>


{
    
    MyProtocol*AlertController;
    Validation*textFieldValidation;
    
    NSString * otpStr;
}
@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AlertController=[[MyProtocol alloc]init];
    textFieldValidation=[[Validation alloc]init];
    
    self.otp1.delegate=self;
    self.otp2.delegate=self;
    self.otp3.delegate=self;
    self.otp4.delegate=self;
    
    [self.otp1 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
    [self.otp2 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.otp3 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
    [self.otp4 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_otp1 becomeFirstResponder];
    
    _labelOne.backgroundColor=[UIColor colorWithRed:100/255.0f green:25/255.0f blue:51/255.0f alpha:1.0f];

    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    

    
    
    // Do any additional setup after loading the view.
}
#pragma mark  UITextfield Delegates


- (void)dismissKeyboard
{
   // [_otpTextFielf resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length==4) {
        
        [textField resignFirstResponder];
    }
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.otp1)
    {
        if ([textField.text isEqualToString:@" "])
        {
            self.otp1.text=@"";
        }
    }
    else if (textField==self.otp2)
    {
        
        if ([textField.text isEqualToString:@" "])
        {
            self.otp2.text=@"";
        }
    }
    else if (textField==self.otp3)
    {
        
        if ([textField.text isEqualToString:@" "])
        {
            self.otp3.text=@"";
        }
    }
    else if (textField==self.otp4)
    {
        if ([textField.text isEqualToString:@" "])
        {
            self.otp4.text=@"";
        }
    }
}

-(void)productNameTFChange:(UITextField *)sender
{
    
    if (sender==self.otp1)
    {
        
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
            [self.otp2 becomeFirstResponder];
            
            _labelOne.backgroundColor=[UIColor colorWithRed:100/255.0f green:25/255.0f blue:51/255.0f alpha:1.0f];
        }
    }
    else if (sender==self.otp2)
    {
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
            [self.otp3 becomeFirstResponder];
            
            _labelTwo.backgroundColor=[UIColor colorWithRed:100/255.0f green:25/255.0f blue:51/255.0f alpha:1.0f];
        }
    }
    
    else if (sender==self.otp3)
        
    {
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
            [self.otp4 becomeFirstResponder];
            _labelThree.backgroundColor=[UIColor colorWithRed:100/255.0f green:25/255.0f blue:51/255.0f alpha:1.0f];
            
        }
    }
    else if (sender==self.otp4)
    {
        
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
            [self.otp4 resignFirstResponder];
            
            _labelFour.backgroundColor=[UIColor colorWithRed:100/255.0f green:25/255.0f blue:51/255.0f alpha:1.0f];
            
            
            otpStr=[NSString stringWithFormat:@"%@%@%@%@",_otp1.text,_otp2.text,_otp3.text,_otp4.text];
            
            [self verifyOTPmethod];
        }
        
    }
    
}
-(void)verifyOTPmethod
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@verify_otp/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&otp=%@",_userIDStr,otpStr]];
    
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
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    ConformPWVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ConformPWVC"];
                [self.navigationController pushViewController:vc animated:YES];
                    
                    vc.userIDStr=[[jsonResponce valueForKey:@"data"]valueForKey:@"user_id"];
                    
                    
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    [AlertController showMessage:@"OTP not verify Please try again." withTitle:@"Promo Analytics"];
                }
            }
        }];
        
    }];
    
    [dataTask resume];
}







- (IBAction)resendOTPbtnAction:(id)sender {
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@resend_otp/",BaseUrl]]];
    request.HTTPMethod = @"POST";
    NSMutableString* profile = [NSMutableString string];
    [profile appendString:[NSString stringWithFormat:@"user_id=%@",_userIDStr]];
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
                
                if ([msgStr isEqualToString:@"1"]) {
                    [AlertController showMessage:@"OTP send Successfully." withTitle:@"Promo Analytics"];
                    NSArray * dataArray=[jsonResponce valueForKey:@"data"];
                    
                    _userIDStr=[dataArray valueForKey:@"user_id"];
                    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
