#import "CurrencyHelpers.h"

@implementation CurrencyHelpers

+ (NSString *)numberToCurrency:(NSString *)number {
    if (number == nil) {
        return @"$0.00";
    }
    
    NSDecimalNumber *decimalNumber = 
        [NSDecimalNumber decimalNumberWithString:number];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMinimumFractionDigits:2];
    
    NSString *result = [formatter stringFromNumber:decimalNumber];
    
    [formatter release];
    return result;
}

+ (NSString *)penceToDollars:(NSString *)pence {
    if (pence == nil) {
        return @"$0.00";
    }
    
    NSDecimalNumber *penceNumber =
        [NSDecimalNumber decimalNumberWithString:pence];
    
    NSDecimalNumber *dollars = 
        [penceNumber decimalNumberByDividingBy:
         [NSDecimalNumber decimalNumberWithString:@"100"]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:2];
    
    NSString *result = [formatter stringFromNumber:dollars];
    
    [formatter release];
    return result;
}

+ (NSString *)dollarsToPence:(NSString *)dollars {
    if (dollars == nil) {
        return @"$0.00";
    }
    
    NSDecimalNumber *dollarsNumber =
        [NSDecimalNumber decimalNumberWithString:dollars];
    
    NSDecimalNumber *pence = 
        [dollarsNumber decimalNumberByMultiplyingBy:
            [NSDecimalNumber decimalNumberWithString:@"100"]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSString *result = [formatter stringFromNumber:pence];
    
    [formatter release];
    return result;
}

@end
