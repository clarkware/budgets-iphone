#import "DateHelpers.h"

@implementation DateHelpers

+ (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *result = [formatter stringFromDate:date];
    [formatter release];
    return result;
}

+ (NSDate *)parseDateTime:(NSString *)dateTimeString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *result = [formatter dateFromString:dateTimeString];
    [formatter release];
    return result;
}

@end
