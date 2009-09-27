#import "BudgetDetailViewController.h"

#import "Budget.h"
#import "Expense.h"
#import "Helpers.h"
#import "ConnectionManager.h"
#import "ExpenseDetailViewController.h"

@interface BudgetDetailViewController ()
- (void)fetchRemoteExpenses;
- (void)updateRemoteBudget;
- (void)deleteRowsAtIndexPaths:(NSArray *)array;
- (void)destroyRemoteExpenseAtIndexPath:(NSIndexPath *)indexPath;
- (void)showExpense:(Expense *)expense;
- (UITableViewCell *)makeExpenseCell:(UITableView *)tableView forRow:(NSUInteger)row;
- (UITableViewCell *)makeAddExpenseCell:(UITableView *)tableView forRow:(NSUInteger)row;
- (UITableViewCell *)makeBudgetCell:(UITableView *)tableView forRow:(NSUInteger)row;
- (UITextField *)newNameField;
- (UITextField *)newAmountField;
@end

@implementation BudgetDetailViewController

@synthesize nameField;
@synthesize amountField;
@synthesize budget;
@synthesize expenses;

enum BudgetDetailTableSections {
	kBudgetSection = 0,
    kExpensesSection
};

- (id)initWithBudget:(Budget *)aBudget {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.budget = aBudget;
    }
    
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.831 alpha:1.0];

    self.title = budget.name;
    
    nameField = [self newNameField];
    amountField = [self newAmountField];
    
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(fetchRemoteExpenses) 
                                      onTarget:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [nameField release];
    [amountField release];
    [budget release];
    [expenses release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.navigationItem setHidesBackButton:editing animated:YES];

	nameField.enabled = editing;
	amountField.enabled = editing;
    
	[self.tableView beginUpdates];
	
    NSUInteger expensesCount = [expenses count];
    
    NSArray *expensesInsertIndexPath = 
        [NSArray arrayWithObject:[NSIndexPath indexPathForRow:expensesCount 
                                                    inSection:kExpensesSection]];
    
    if (editing) {
        amountField.text = [CurrencyHelpers dollarsToPence:budget.amount];           

        [self.tableView insertRowsAtIndexPaths:expensesInsertIndexPath 
                              withRowAnimation:UITableViewRowAnimationTop];
	} else {
        amountField.text = [budget amountAsCurrency];         

        [self.tableView deleteRowsAtIndexPaths:expensesInsertIndexPath 
                              withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(updateRemoteBudget) 
                                      onTarget:self];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (textField == nameField) {
		budget.name = nameField.text;
		self.title = budget.name;
	} else if (textField == amountField) {
        budget.amount = [CurrencyHelpers penceToDollars:amountField.text];
	}
	return YES;
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case kBudgetSection:
            rows = 2;
            break;
        case kExpensesSection:
            rows = [expenses count];
            if (self.editing) {
                rows++; // "Add Expense" cell
            }
            break;
        default:
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case kBudgetSection:
			title = @"Budget";
            break;
        case kExpensesSection:
			title = @"Expenses";
            break;
	}
  	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = nil;

    NSUInteger row = indexPath.row;

    // For the Expenses section, create a cell for each expense.
    if (indexPath.section == kExpensesSection) {
		NSUInteger expensesCount = [expenses count];
        if (row < expensesCount) {
            cell = [self makeExpenseCell:tableView forRow:row];
        } 
        // If the row is outside the range of the expenses, it's
        // the row that was added to allow insertion.
        else {
            cell = [self makeAddExpenseCell:tableView forRow:row];
        }
    }
    // For the Budget section, create a cell for each text field.
    else {
        cell = [self makeBudgetCell:tableView forRow:row];
    }
    
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing && (indexPath.section == kExpensesSection)) {
        return indexPath;
    }
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kExpensesSection) {
        Expense *expense = nil;
        if (indexPath.row < [expenses count]) {
            expense = [expenses objectAtIndex:indexPath.row];
        } else {
            expense = [[[Expense alloc] init] autorelease];
            expense.budgetId = budget.budgetId;
        }
        [self showExpense:expense];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // Only allow editing in the Expenses section.  The last row
    // was added automatically for adding a new expense.  All
    // other rows are eligible for deletion.
    if (indexPath.section == kExpensesSection) {
        if (indexPath.row == [expenses count]) {
            style = UITableViewCellEditingStyleInsert;
        } else {
            style = UITableViewCellEditingStyleDelete;
        }
    }    
    return style;
}

 - (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow deletion in the Expenses section.
    if ((editingStyle == UITableViewCellEditingStyleDelete) && 
        (indexPath.section == kExpensesSection)) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[ConnectionManager sharedInstance] runJob:@selector(destroyRemoteExpenseAtIndexPath:) 
                                          onTarget:self
                                      withArgument:indexPath];
    }
}

- (void)destroyRemoteExpenseAtIndexPath:(NSIndexPath *)indexPath {
    Expense *expense = [expenses objectAtIndex:indexPath.row];
    NSError *error = nil;
    BOOL destroyed = [expense destroyRemoteWithResponse:&error];
    if (destroyed == YES) {
        [expenses removeObjectAtIndex:indexPath.row];
        [self performSelectorOnMainThread:@selector(deleteRowsAtIndexPaths:) 
                               withObject:[NSArray arrayWithObject:indexPath]  
                            waitUntilDone:NO];
    } else {    
        [UIHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)array {
    [self.tableView deleteRowsAtIndexPaths:array
                          withRowAnimation:UITableViewRowAnimationTop]; 
}

#pragma mark -
#pragma mark Private methods

- (void)fetchRemoteExpenses {
    self.expenses = [NSMutableArray arrayWithArray:[budget findAllExpenses]];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                     withObject:nil 
                                  waitUntilDone:NO]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)updateRemoteBudget {
    NSError *error = nil;
    BOOL updated = [budget updateRemoteWithResponse:&error];
    if (updated == NO) {
        [UIHelpers handleRemoteError:error];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showExpense:(Expense *)expense {
    ExpenseDetailViewController *controller = 
    [[ExpenseDetailViewController alloc] initWithExpense:expense];
    controller.expense = expense;
    [self.navigationController pushViewController:controller animated:YES];	
    [controller release];
}

- (UITableViewCell *)makeExpenseCell:(UITableView *)tableView forRow:(NSUInteger)row {
    static NSString *ExpensesCellId = @"ExpensesCellId";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:ExpensesCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier:ExpensesCellId] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Expense *expense = [expenses objectAtIndex:row];
    cell.textLabel.text = expense.name;
    cell.detailTextLabel.text = [expense amountAsCurrency];
    return cell;
}

- (UITableViewCell *)makeAddExpenseCell:(UITableView *)tableView forRow:(NSUInteger)row {
    static NSString *AddExpenseCellId = @"AddExpenseCellId";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:AddExpenseCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:AddExpenseCellId] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"Add Expense";   
    return cell;
}

- (UITableViewCell *)makeBudgetCell:(UITableView *)tableView forRow:(NSUInteger)row {
    static NSString *BudgetCellId = @"BudgetCellId";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:BudgetCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:BudgetCellId] autorelease];
    }
    
    if (row == 0)  {
        [cell.contentView addSubview:nameField];	
    } else { 
        [cell.contentView addSubview:amountField];	
    }
    
    return cell;
}

- (UITextField *)newNameField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.text = budget.name;
    field.returnKeyType = UIReturnKeyDone;
    field.enabled = NO;
    return field;
}

- (UITextField *)newAmountField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.text = [budget amountAsCurrency]; 
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.enabled = NO;
    return field;
}

@end
