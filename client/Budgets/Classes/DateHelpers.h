#import <Foundation/Foundation.h>

@interface DateHelpers : NSObject {
}

+ (NSString *)formatDate:(NSDate *)date;
+ (NSDate *)parseDateTime:(NSString *)dateTimeString;

@end
