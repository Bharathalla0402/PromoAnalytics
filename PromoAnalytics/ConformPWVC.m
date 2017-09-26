//
//  ConformPWVC.m
//  PromoAnalytics
//
//  Created by amit on 4/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "ConformPWVC.h"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import "PromoUrl.pch"
#import "ViewController.h"

@interface ConformPWVC ()<UITextFieldDelegate,NSURLSessionDelegate,MyProtocolDelegate,CAAnimationDelegate>

{
    
    MyProtocol*AlertController;
    Validation*textFieldValidation;
}


@end

@implementation ConformPWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _enterPwTF.delegate=self;
    _conformPwTE.delegate=self;
    
    AlertController=[[MyProtocol alloc]init];
    textFieldValidation=[[Validation alloc]init];
    
    _continueBtn.layer.cornerRadius=22;
    _continueBtn.clipsToBounds=YES;
    
    
    [[_passwordView layer] setBorderWidth:1.5f];
    [[_passwordView layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    _passwordView.clipsToBounds=YES;
    
    [[_conformView layer] setBorderWidth:1.5f];
    [[_conformView layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    _conformView.clipsToBounds=YES;
    
    
   
}


- (IBAction)continueButtonAction:(id)sender {
    
    
    NSString *message;
    
    if (_enterPwTF.text.length<=0)
    {
        message = @"Please enter New Password.";
    }
    
    if (![_enterPwTF.text isEqualToString: _conformPwTE.text])
    {
        message = @"Conform Password Doesnot match Please try again.";
    }
    if ([message length]>1)
    {
        [AlertController showMessage:message withTitle:@"Promo Analytics"];
        
    }else{
        
        // fullNameStr=[NSString stringWithFormat:@"%@ %@",_nameTF.text,_lastName.text];
        
        [self updateUserProfileMethod];
        
        [self.view endEditing:YES];
        
    }

    
}
-(void)updateUserProfileMethod
{
    
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@edit_profile/",BaseUrl]]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString* profile = [NSMutableString string];
    
    [profile appendString:[NSString stringWithFormat:@"user_id=%@&name=%@&image=%@&password=%@",_userIDStr,@"",@"",_enterPwTF.text]];
    
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
                
                if ([msgStr isEqualToString:@"1"]) {
                    
                    
                    ViewController * lvc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                    
                    
                     [AlertController showMessage:@"Your password changed successfully done." withTitle:@"Promo Analytics"];
                }
                
                if ([msgStr isEqualToString:@"0"]) {
                    
                    [AlertController showMessage:@"Please try again." withTitle:@"Promo Analytics"];
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
    if (textField==_enterPwTF)
    {
        _passWrdLbl.textColor = [UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f];
        [[_passwordView layer] setBorderColor:[UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f].CGColor];
        _passWrdImg.image=[UIImage imageNamed:@"passwordBlue"];
    }
   else if (textField==_conformPwTE)
    {
        _conformPwlabl.textColor = [UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f];
        [[_conformView layer] setBorderColor:[UIColor colorWithRed:24/255.0f green:125/255.0f blue:203/255.0f alpha:1.0f].CGColor];
        _confornPwImg.image=[UIImage imageNamed:@"passwordBlue"];
    }
    
    //[(ACFloatingTextField *)textField textFieldDidBeginEditing];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_enterPwTF)
    {
        _passWrdLbl.textColor = [UIColor darkGrayColor];
        [[_passwordView layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        _passWrdImg.image=[UIImage imageNamed:@"password"];
    }
    
    
  else  if (textField==_conformPwTE)
    {
        _conformPwlabl.textColor = [UIColor darkGrayColor];
        [[_conformView layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        _confornPwImg.image=[UIImage imageNamed:@"password"];
    }
    
    
    //[(ACFloatingTextField *)textField textFieldDidEndEditing];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
