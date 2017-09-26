//
//  ProfileViewController.m
//  PromoAnalytics
//
//  Created by amit on 3/17/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "ProfileViewController.h"
#import "PromoUrl.pch"
#import "DejalActivityView.h"
#import "MyProtocol.h"
#import "Validation.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "ViewController.h"


@interface ProfileViewController ()<UITextFieldDelegate,MyProtocolDelegate,NSURLSessionDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>
{
    MyProtocol*AlertController;
    Validation*textFieldValidation;
    
    NSString * userID;
    NSString * imageUrlStr;
    
    UIImagePickerController *imgPicker;
    UIImage *currentSelectedImage;
   NSString * fullNameStr;
    
    UIActivityIndicatorView *indicator;
    
    SWRevealViewController *revelview;
    UIButton *barbutt;
    UIView *frontView;
    UIView *popview;
    
    UIDatePicker *datePicker;
    UIBarButtonItem *rightBtn;
    UIButton *DoneButton,*DoneButton2;
    
    NSString *strage;
}
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataArray;
@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"image"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    indicator= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2-25,self.view.frame.size.height/2-25,  50, 50)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //[self.view addSubview: indicator];
    //[indicator startAnimating];
    
    
    userID=[[NSUserDefaults standardUserDefaults]valueForKey:@"saveUserID"];
    
    
    AlertController=[[MyProtocol alloc]init];
    AlertController.delegate=self;
    
    textFieldValidation=[[Validation alloc]init];
    
    _nameTF.delegate=self;
    _emailTF.delegate=self;
    _phoneNumTF.delegate=self;
    _passWordTF.delegate=self;
    
    _reEnterPwTF.delegate=self;
    
    
    
    
    _profileImage.layer.cornerRadius=60;
    [[_profileImage layer] setBorderWidth:6.0f];
    [[_profileImage layer] setBorderColor:[UIColor colorWithRed:242/255.0f green:153/255.0f blue:125/255.0f alpha:1.0f].CGColor];
    _profileImage.clipsToBounds = YES;
    
    _saveProfileButton.layer.cornerRadius=22;
    _saveProfileButton.clipsToBounds=YES;
    
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    
    

    [[_usrNmTFview layer] setBorderWidth:2.0f];
    [[_usrNmTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    _usrNmTFview.clipsToBounds=YES;
    
    [[_DobView layer] setBorderWidth:2.0f];
    [[_DobView layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    _DobView.clipsToBounds=YES;
    
    
    [[_emailTFview layer] setBorderWidth:2.0f];
    [[_emailTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    _emailTFview.clipsToBounds=YES;
    
    [[_phnNumTFview layer] setBorderWidth:2.0f];
    [[_phnNumTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    _phnNumTFview.clipsToBounds=YES;
    
    [[_pwTFview layer] setBorderWidth:2.0f];
    [[_pwTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    _pwTFview.clipsToBounds=YES;
    
    [[_reEntrPWTFview layer] setBorderWidth:2.0f];
    [[_reEntrPWTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    _reEntrPWTFview.clipsToBounds=YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    
  //  [self getUserProfileDetails];
    
    
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
    
   
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"image"];
    if(object != nil)
    {
        
    }
    else
    {
       [self getUserProfileDetails];
    }
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
                    
                    NSString * nameStr=[_dataArray valueForKey:@"name"];
//                    NSArray * nameArray=[nameStr componentsSeparatedByString:@" "];
//                    _nameTF.text=[nameArray objectAtIndex:0];
//                    _lastName.text =[nameArray objectAtIndex:1];
                    
                    _nameTF.text=nameStr;
                    _profileName.text=nameStr;
                    _emailTF.text=[_dataArray valueForKey:@"email"];
                    _phoneNumTF.text=[_dataArray valueForKey:@"phone"];
                    
                    NSString *strDob=[NSString stringWithFormat:@"%@",[_dataArray valueForKey:@"dob"]];
                    
                    if ([strDob isEqualToString:@"01/01/1970"])
                    {
                        
                    }
                    else if ([strDob isEqualToString:@""])
                    {
                        
                    }
                    else
                    {
                        _DobTF.text=[_dataArray valueForKey:@"dob"];
                    }
                    
                    
                    
                    imageUrlStr=[_dataArray valueForKey:@"pic"];
//            [_profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"profilePlcHolderImage"]];
                    [_profileImage setShowActivityIndicatorView:YES];
                    [_profileImage setIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    _profileImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_dataArray valueForKey:@"pic"]]]]];
                    
                    [_profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                                  placeholderImage:[UIImage imageNamed:@"profilepic.png"]];
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:nameStr forKey:@"name"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
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


#pragma mark - Upload Image button Action -

- (IBAction)upLoadImageButtonAction:(id)sender {
    
    
    
    UIAlertController * uiViewActionSheet=   [UIAlertController
                                              alertControllerWithTitle:@"Action"
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                                actionWithTitle:@"Take Photo"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Do some thing here
                                    
                                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                        
                                        
                                        UIAlertView *alertView = [[UIAlertView alloc]
                                                                  initWithTitle:@"Message"
                                                                  message:@"Device has no camera"
                                                                  delegate:self
                                                                  cancelButtonTitle:@"Cancel"
                                                                  otherButtonTitles:nil];
                                        
                                        [alertView show];
                                    }else{
                                        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        
                                        [self presentViewController:imgPicker animated:YES completion:NULL];
                                        
                                    }
                                    [uiViewActionSheet dismissViewControllerAnimated:YES completion:nil];
                                }];
    
    UIAlertAction* chooseExisting = [UIAlertAction
                                     actionWithTitle:@"Choose From Library"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here
                                         imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                         
                                         [self presentViewController:imgPicker animated:YES completion:NULL];
                                         
                                         [uiViewActionSheet dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [uiViewActionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [uiViewActionSheet addAction:chooseExisting];
    [uiViewActionSheet addAction:takePhoto];
    [uiViewActionSheet addAction:cancel];
    
    // [uiViewActionSheet setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [uiViewActionSheet
                                                     popoverPresentationController];
    popPresenter.sourceView = self.uploadImageButton;
    popPresenter.sourceRect = self.uploadImageButton.bounds;
    [self presentViewController:uiViewActionSheet animated:YES completion:nil];

}



#pragma mark - Image Picker Controller delegate methods



-(UIImage*)imageWithReduceImage: (UIImage*)imageName scaleToSize: (CGSize)newsize
{
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 12.0);
    [imageName drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"image" forKey:@"image"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.5);
    currentSelectedImage = [[UIImage alloc] initWithData:dataImage];
    
    
   // currentSelectedImage = [self imageWithReduceImage:currentSelectedImage
   //                                       scaleToSize:CGSizeMake(40, 40)];
    
   // NSData* pictureData = UIImagePNGRepresentation(currentSelectedImage);
    
    self.profileImage.clipsToBounds = YES;
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.profileImage setImage:currentSelectedImage];
    
    //[self imageUploaedMethod];
    
    //    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //    self.editProfileImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



#pragma mark - Update Profile method -

- (IBAction)saveProfileBtnAction:(id)sender
{
    NSString *message;
    
    if (_nameTF.text.length<=0)
    {
        message = @"Please enter User name.";
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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //Populate a dictionary with all the regular values you would like to send.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:userID forKey:@"user_id"];
    [parameters setValue:_nameTF.text forKey:@"name"];
    [parameters setValue:_passWordTF.text forKey:@"password"];
    if (strage == (id)[NSNull null] || strage.length == 0 )
    {
        
    }
    else
    {
        [parameters setValue:strage forKey:@"dob"];
    }
    
    // add params (all params are strings)
    for (NSString *param in parameters)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *FileParamConstant = @"image";

    NSData *imageData = UIImageJPEGRepresentation(currentSelectedImage, 1);
    
    
    //Assuming data is not nil we add this to the multipart form
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    NSString *strRegurl=[NSString stringWithFormat:@"%@%@",BaseUrl,@"edit_profile/"];
    
    // set URL
    [request setURL:[NSURL URLWithString:strRegurl]];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async (dispatch_get_main_queue(), ^{
            
            if (error)
            {
                
            } else
            {
                if(data != nil) {
                    
                    [DejalBezelActivityView removeView];
                    
                    [self parseJSONResponse:data];
                }
            }
        });
    }] resume];
}




-(void)parseJSONResponse:(NSData*)responseData
{
    NSError *err;
    
    NSMutableDictionary *jsonResponce = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    
    NSLog(@"%@",jsonResponce);
    
    NSString * msgStr=[NSString stringWithFormat:@"%@",[jsonResponce valueForKey:@"status"]];
    
    if ([msgStr isEqualToString:@"1"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Promo Analytics" message:@"User profile Successfully Updated." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 // [self getUserProfileDetails];
                                 _passWordTF.text=@"";
                                 _reEnterPwTF.text=@"";
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
       [self getUserProfileDetails];
       // [AlertController showMessage:@"User profile Successfully Updated" withTitle:@"Promo Analytics"];
        
    }
    else
    {
        [AlertController showMessage:@"User profile not Updated Please try again" withTitle:@"Promo Analytics"];
    }
}






#pragma mark  UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_nameTF)
    {
        _userImage.image=[UIImage imageNamed:@"user-red.png"];
         [[_usrNmTFview layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
    }
    else if (textField==_passWordTF)
    {
         _passwordImage.image=[UIImage imageNamed:@"password-red.png"];
         [[_pwTFview layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
    }
   
  //  [self animateTextField:textField up:YES];
    
    //[(ACFloatingTextField *)textField textFieldDidBeginEditing];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_nameTF)
    {
        _userImage.image=[UIImage imageNamed:@"user-grey.png"];
        [[_usrNmTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    }
    else if (textField==_passWordTF)
    {
        _passwordImage.image=[UIImage imageNamed:@"password.png"];
        [[_pwTFview layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    }
    //    [self animateTextField:textField up:NO];
   // [(ACFloatingTextField *)textField textFieldDidEndEditing];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//-(void)animateTextField:(UITextField*)textField up:(BOOL)up
//{
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        if (textField==_passWordTF)
//        {
//            const int movementDistance = -120; // tweak as needed
//            const float movementDuration = 0.3f; // tweak as needed
//            int movement = (up ? movementDistance : -movementDistance);
//            
//            [UIView beginAnimations: @"animateTextField" context: nil];
//            [UIView setAnimationBeginsFromCurrentState: YES];
//            [UIView setAnimationDuration: movementDuration];
//            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//            [UIView commitAnimations];
//        }
//        else if (textField==_reEnterPwTF)
//        {
//            const int movementDistance = -150; // tweak as needed
//            const float movementDuration = 0.3f; // tweak as needed
//            int movement = (up ? movementDistance : -movementDistance);
//            
//            [UIView beginAnimations: @"animateTextField" context: nil];
//            [UIView setAnimationBeginsFromCurrentState: YES];
//            [UIView setAnimationDuration: movementDuration];
//            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//            [UIView commitAnimations];
//        }
//    }
//    
//}


- (void)dismissKeyboard
{
    [_emailTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    [_reEnterPwTF resignFirstResponder];
    [_nameTF resignFirstResponder];
    [_phoneNumTF resignFirstResponder];
}

- (IBAction)DobButtClicked:(id)sender
{
    [_nameTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    [[_DobView layer] setBorderColor:[UIColor colorWithRed:245/255.0f green:73/255.0f blue:63/255.0f alpha:1.0f].CGColor];
    
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
    
    _DobTF.text=strDateofbirth;
}

-(void)save:(id)sender
{
    [[_DobView layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    self.navigationItem.rightBarButtonItem=nil;
    [datePicker removeFromSuperview];
    [popview removeFromSuperview];
}

-(void)save2:(id)sender
{
    [[_DobView layer] setBorderColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f].CGColor];
    self.navigationItem.rightBarButtonItem=nil;
    [datePicker removeFromSuperview];
    [popview removeFromSuperview];
}

- (IBAction)logoutButtClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveUserID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    ViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:edit animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
