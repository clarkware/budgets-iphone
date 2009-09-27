#import <Foundation/Foundation.h>

@interface UIHelpers : NSObject

+ (UIBarButtonItem *)newCancelButton:(id)target;
+ (UIBarButtonItem *)newSaveButton:(id)target;
+ (UITextField *)newTableCellTextField:(id)delegate;

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message;
+ (void)showAlertWithError:(NSError *)error;
+ (void)handleRemoteError:(NSError *)error;

@end
