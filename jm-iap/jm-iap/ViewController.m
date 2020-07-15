//
//  ViewController.m
//  jm-iap
//
//  Created by jimmy on 2020/7/14.
//  Copyright © 2020 com.jimmy.test. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "JMPayManager.h"
@interface ViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    NSString * productId;
    SKMutablePayment *g_payment;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    productId = @"com.jimmy.tes1.pay2";
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"pay" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100.0f, 100.0f);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [[JMPayManager shareInstance] activate];
    
    [[JMPayManager shareInstance] setResultBlock:^(JMPAYMENT_STATUS status) {
       
        NSLog(@"%ld",status);
    }];
      
    
}

- (IBAction)payAction:(id)sender {
    
    [[JMPayManager shareInstance] beginBuyProduct:@"com.jimmy.tes1.pay1" andCount:10];
}





@end
