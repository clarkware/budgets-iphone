#import <UIKit/UIKit.h>

@class Expense;

@interface ExpenseDetailViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Expense     *expense;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;
@property (nonatomic, retain) Expense *expense;

- (id)initWithExpense:(Expense *)expense;

- (IBAction)save;
- (IBAction)cancel;

@end
