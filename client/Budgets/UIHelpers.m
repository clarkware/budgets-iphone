#import "UIHelpers.h"

@implementation UIHelpers

+ (UIBarButtonItem *)newCancelButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
            target:target 
            action:@selector(cancel)];    
}

+ (UIBarButtonItem *)newSaveButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
            target:target 
            action:@selector(save)];    
}

+ (UITextField *)newTableCellTextField:(id)delegate {
    UITextField *textField = 
        [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 250, 25)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = delegate;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearsOnBeginEditing = NO;
    return textField;
}   

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message {
	UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:title 
                                   message:message
                                  delegate:nil 
                         cancelButtonTitle:@"OK" 
                         otherButtonTitles:nil];
    [alert show];
	[alert release];
}

+ (void)showAlertWithError:(NSError *)error {
    NSString *message = 
        [NSString stringWithFormat:@"Sorry, %@", [error localizedDescription]];
    [self showAlert:@"Error" withMessage:message];
}


+ (void)handleRemoteError:(NSError *)error {
    if ([error code] == 401) {
        [self showAlert:@"Login Failed" 
            withMessage:@"Please check your username and password, and try again."];
    } else {
        [self showAlertWithError:error];
    }
}

@end
