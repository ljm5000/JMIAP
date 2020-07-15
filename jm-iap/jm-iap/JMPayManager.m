//
//  JMPayManager.m
//  jm-iap
//
//  Created by jimmy on 2020/7/14.
//  Copyright © 2020 com.jimmy.test. All rights reserved.
//

#import "JMPayManager.h"
#import <StoreKit/StoreKit.h>

@interface JMPayManager()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,strong) NSString * productId;
@property (nonatomic,assign) NSInteger count;
@end

@implementation JMPayManager

+(JMPayManager *)shareInstance{
    static JMPayManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JMPayManager alloc] init];
    });
    return instance;
}

-(BOOL)activate{
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        return YES;
    }
    NSLog(@"JMPayManager can't activate");
    return NO;
}

-(void)beginBuyProduct:(NSString * )productId andCount:(NSInteger)count{
    self.productId = productId;
    self.count = count;
    //根据商品ID查找商品信息
    NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    
    //创建SKProductsRequest对象，用想要出售的商品的标识来初始化,然后附加上对应的委托对象。
    //该请求的响应包含了可用商品的本地化信息。
    SKProductsRequest *request = [[SKProductsRequest alloc]  initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
    if (self.resultBlock) {
        self.resultBlock(PAYMENT_BEGIN);
    }
}
#pragma mark - lazy load

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *product = response.products;
         //invalidProductIdentifiers是不被App Store所识别的产品id字符串数组，通常为空
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    
    if(product == nil) {
        if (self.resultBlock) {
            self.resultBlock(PAYMENT_GET_PRODUCT_INFO_ERROR);
        }
        return;
    }
    //数组的count代表回调的产品ID数组的长度
    if (product.count == 0) {
       NSLog(@"无法获得产品信息，购买失败");
        if (self.resultBlock) {
            self.resultBlock(PAYMENT_GET_PRODUCT_INFO_ERROR);
        }
        
       return;
     }
    //SKProduct对象包含了在App Store上注册的商品的本地化信息。
    SKProduct *storeProduct = nil;
    for (SKProduct *pro in product) {
      if ([pro.productIdentifier isEqualToString:self.productId]) {
         storeProduct = pro;
     }
    }
    if(storeProduct == nil) {
        if (self.resultBlock) {
            self.resultBlock(PAYMENT_GET_PRODUCT_INFO_ERROR);
        }
        
         return;
    }
    
    if (self.resultBlock) {
        self.resultBlock(PAYMENT_GET_PRODUCT_INFO);
    }
    
        //创建一个支付对象，并放到队列中
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:storeProduct];
         //设置购买的数量
    payment.quantity = self.count;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
  
    
         
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:  //交易完成
                NSLog(@"transactionIdentifier = %@",transaction.transactionIdentifier);
              
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:   {  //交易失败
                
                if (self.resultBlock) {
                    self.resultBlock(PAYMENT_FAILD);
                }
                
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:  {//已经购买过该商品
                
                if (self.resultBlock) {
                    self.resultBlock(PAYMENT_HAS_BUY);
                }
                
                [self restoreTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStatePurchasing:{ //商品添加进列表
                NSLog(@"商品添加进列表");
                if (self.resultBlock) {
                    self.resultBlock(PAYMENT_PURCHASING);
                }
                
            }break;
            default:
                break;
        }
    }
}


//交易完成后的操作
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSData *transactionReceiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receipt = [transactionReceiptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    if ([productIdentifier length]>0) {
        NSLog(@"已经购买过该商品");
        //向自己的服务器验证购买凭证
        NSString * dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingFormat:@"/receipt"];
        NSLog(@"%@",dir);
        if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        NSString* fileName = [dir stringByAppendingFormat:@"/rsp%.2f",[[NSDate date] timeIntervalSince1970]];
        NSError * error;
        [receipt writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"%@",error.localizedDescription);
            if (self.resultBlock) {
                self.resultBlock(PAYMENT_PURCHASING_FAILD);
            }
        }else{
            NSLog(@"write file success");
            if (self.resultBlock) {
                self.resultBlock(PAYMENT_COMPLETE);
            }
        }
        
       // NSLog(@"%@",receipt);
    }
    
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//交易失败后的操作
-(void)failedTransaction:(SKPaymentTransaction *)transaction{
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    }else{
        NSLog(@"用户取消交易");
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//已经购买过该商品
-(void)restoreTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"已经购买过该商品");
    //对于已购买商品，处理恢复购买的逻辑
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}




@end
