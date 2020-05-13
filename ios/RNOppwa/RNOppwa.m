#import "RNOppwa.h"

@implementation RNOppwa

OPPPaymentProvider *provider;

RCT_EXPORT_MODULE(RNOppwa);


-(instancetype)init
{
    self = [super init];
    if (self) {
        provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeLive];
    }

    return self;
}

/**
 * transaction
 */
RCT_EXPORT_METHOD(transactionPayment: (NSDictionary*)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {

    NSError * _Nullable error;

    NSMutableDictionary *result = [[NSMutableDictionary alloc]initWithCapacity:10];

//FIX: Removing the below code because of PROD Payment issue
    
//    if([options valueForKey:@"environment"] != nil) {
//        if([[options valueForKey:@"environment"] isEqualToString:@"LIVE"]) {
//            provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeLive];
//        } else {
//            provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeTest];
//        }
//    }

    OPPCardPaymentParams *params = [OPPCardPaymentParams cardPaymentParamsWithCheckoutID:[options valueForKey:@"checkoutID"]

                                                                            paymentBrand:[options valueForKey:@"paymentBrand"]
                                                                                  holder:[options valueForKey:@"holderName"]
                                                                                  number:[options valueForKey:@"cardNumber"]
                                                                             expiryMonth:[options valueForKey:@"expiryMonth"]
                                                                              expiryYear:[options valueForKey:@"expiryYear"]
                                                                                     CVV:[options valueForKey:@"cvv"]
                                                                                   error:&error];

    params.shopperResultURL = [options valueForKey:@"shopperResultURL"];

    if (error) {
        reject(@"oppwa/card-init",error.localizedDescription, error);
    } else {
        params.tokenizationEnabled = YES;
        OPPTransaction *transaction = [OPPTransaction transactionWithPaymentParams:params];

        [provider submitTransaction:transaction completionHandler:^(OPPTransaction * _Nonnull transaction, NSError * _Nullable error) {
            if (transaction.type == OPPTransactionTypeAsynchronous) {
                // Open transaction.redirectURL in Safari browser to complete the transaction
                [result setObject:[NSString stringWithFormat:@"transactionPending"] forKey:@"status"];
                [result setObject:[NSString stringWithFormat:@"asynchronous"] forKey:@"type"];
                [result setObject:[NSString stringWithFormat:@"%@",transaction.redirectURL] forKey:@"redirectURL"];
                resolve(result);
            }  else if (transaction.type == OPPTransactionTypeSynchronous) {
                [result setObject:[NSString stringWithFormat:@"transactionCompleted"] forKey:@"status"];
                [result setObject:[NSString stringWithFormat:@"synchronous"] forKey:@"type"];
                resolve(result);
            } else {
                reject(@"oppwa/transaction",error.localizedDescription, error);
                // Handle the error
            }
        }];
    }
}
/**
 * validate number
 * @return
 */
RCT_EXPORT_METHOD(isValidNumber:
                  (NSDictionary*)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {


    if ([OPPCardPaymentParams isNumberValid:[options valueForKey:@"cardNumber"] forPaymentBrand:[options valueForKey:@"paymentBrand"]]) {
        resolve([NSNull null]);
    }
    else {
        reject(@"oppwa/card-invalid", @"The card number is invalid.", nil);
    }
}

RCT_EXPORT_METHOD(isValidHolderName:
                  (NSDictionary*)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {


    if ([OPPCardPaymentParams isHolderValid:[options valueForKey:@"cardHolderName"]]) {
        resolve([NSNull null]);
    }
    else {
        reject(@"oppwa/card-invalid", @"The card holder name is invalid.", nil);
    }
}

RCT_EXPORT_METHOD(isValidCVV:
                  (NSDictionary*)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {


    if ([OPPCardPaymentParams isCvvValid:[options valueForKey:@"cvv"]]) {
        resolve([NSNull null]);
    }
    else {
        reject(@"oppwa/card-invalid", @"The card cvv is invalid.", nil);
    }
}

RCT_EXPORT_METHOD(isValidExpiryDate:
                  (NSDictionary*)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {


    if (![OPPCardPaymentParams isExpiredWithExpiryMonth:[options valueForKey:@"expiryMonth"] andYear:[options valueForKey:@"expiryYear"]]) {
        resolve([NSNull null]);
    }
    else {
        reject(@"oppwa/card-invalid", @"The card expiry date is invalid.", nil);
    }
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}


@end
