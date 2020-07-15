//
//  JMPayManager.h
//  jm-iap
//
//  Created by jimmy on 2020/7/14.
//  Copyright © 2020 com.jimmy.test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PAYMENT_BEGIN,
    PAYMENT_GET_PRODUCT_INFO,
    PAYMENT_UPDATE_TRANSACTIONS,
    PAYMENT_PURCHASING,
    PAYMENT_COMPLETE,
    
    PAYMENT_HAS_BUY,
    PAYMENT_FAILD,
    PAYMENT_GET_PRODUCT_INFO_ERROR,
    PAYMENT_PURCHASING_FAILD
    
} JMPAYMENT_STATUS;


typedef void(^PaymentResult)(JMPAYMENT_STATUS status);

@interface JMPayManager : NSObject

@property (nonatomic,copy) PaymentResult resultBlock;

+(JMPayManager *)shareInstance;

-(BOOL)activate;

-(void)beginBuyProduct:(NSString * )productId andCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
