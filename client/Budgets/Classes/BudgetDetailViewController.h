#import <UIKit/UIKit.h>

@class Budget;

@interface BudgetDetailViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Budget *budget;
    NSMutableArray *expenses;
}

@property (nonatomic, retain) Budget *budget;
@property (nonatomic, retain) NSMutableArray *expenses;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;

- (id)initWithBudget:(Budget *)budget;

@end
