#import <Foundation/Foundation.h>

@interface CurrencyHelpers : NSObject

+ (NSString *)numberToCurrency:(NSString *)number;
+ (NSString *)penceToDollars:(NSString *)pence;
+ (NSString *)dollarsToPence:(NSString *)dollars;

@end
