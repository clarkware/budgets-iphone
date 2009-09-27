#import <UIKit/UIKit.h>

@class BudgetTableCell;

@interface BudgetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *budgets;
    UITableView *tableView;
}

@property (nonatomic, retain) NSArray *budgets;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)add;
- (IBAction)refresh;

@end
