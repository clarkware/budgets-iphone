#import <UIKit/UIKit.h>

@class Budget;

@interface BudgetAddViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Budget *budget;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;
@property (nonatomic, retain) Budget *budget;

- (id)initWithBudget:(Budget *)budget;

- (IBAction)save;
- (IBAction)cancel;

@end
