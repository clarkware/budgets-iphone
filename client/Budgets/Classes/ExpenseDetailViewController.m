#import "ExpenseDetailViewController.h"

#import "Expense.h"
#import "Helpers.h"
#import "ConnectionManager.h"

@interface ExpenseDetailViewController ()
- (void)saveRemoteExpense;
- (UITextField *)newNameField;
- (UITextField *)newAmountField;
@end

@implementation ExpenseDetailViewController

@synthesize expense;
@synthesize nameField;
@synthesize amountField;

- (id)initWithExpense:(Expense *)anExpense {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.expense = anExpense;
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.831 alpha:1.0];

    nameField = [self newNameField];
    [nameField becomeFirstResponder];
    amountField = [self newAmountField];
    
    UIBarButtonItem *cancelButton = [UIHelpers newCancelButton:self];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [UIHelpers newSaveButton:self];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];        
} 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (expense.expenseId) {
        self.title = @"Edit Expense";
        nameField.text = expense.name;
        amountField.text = [CurrencyHelpers dollarsToPence:expense.amount];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.title = @"Add Expense";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [nameField release];
    [amountField release];
    [expense release];
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)save {
    expense.name = nameField.text;
    expense.amount = [CurrencyHelpers penceToDollars:amountField.text];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(saveRemoteExpense) 
                                      onTarget:self];
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = 
        [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                reuseIdentifier:nil] autorelease];

    if (indexPath.row == 0)  {
        [cell.contentView addSubview:nameField];	
    } else { 
        [cell.contentView addSubview:amountField];	
    }
    
    return cell;
}

#pragma mark - 
#pragma mark Text Field Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField { 
    [textField resignFirstResponder];
	if (textField == nameField) {
        [amountField becomeFirstResponder];
    }
	if (textField == amountField) {
        [self save];
    }
	return YES;
}    

- (IBAction)textFieldChanged:(id)sender {
    BOOL enableSaveButton = 
        ([self.nameField.text length] > 0) && ([self.amountField.text length] > 0);
    [self.navigationItem.rightBarButtonItem setEnabled:enableSaveButton];
}

#pragma mark -
#pragma mark Private methods

- (void)saveRemoteExpense {
    // If the model is new, then create will be called.
    // Otherwise the model will be updated.
    NSError *error = nil;
    BOOL saved = [expense saveRemoteWithResponse:&error];
    if (saved == YES) {
        [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) 
                                                    withObject:[NSNumber numberWithBool:YES] 
                                                 waitUntilDone:NO]; 
    } else {
        [UIHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (UITextField *)newNameField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.placeholder = @"Name";
    field.keyboardType = UIKeyboardTypeASCIICapable;
    field.returnKeyType = UIReturnKeyNext;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

- (UITextField *)newAmountField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.placeholder = @"Amount";
    field.keyboardType = UIKeyboardTypeNumberPad;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

@end
