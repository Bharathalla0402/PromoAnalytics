//
//  MyProtocol.h
//  ProjectBay
//
//  Created by amit on 8/29/16.
//  Copyright © 2016 Think360Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyProtocolDelegate;



@protocol MyProtocolDelegate <NSObject>



@optional

@end


@interface MyProtocol : NSObject

@property (nonatomic, assign)id <MyProtocolDelegate> delegate;


@property BOOL isInternetConnectionAvailable;

-(void)checkNetworkStatus;
-(void)showMessage:(NSString*)message withTitle:(NSString *)title;



@end
