#import "BudgetAddViewController.h"

#import "Budget.h"
#import "Helpers.h"
#import "ConnectionManager.h"

@interface BudgetAddViewController ()
- (void)createRemoteBudget;
- (UITextField *)newNameField;
- (UITextField *)newAmountField;
@end

@implementation BudgetAddViewController

@synthesize nameField;
@synthesize amountField;
@synthesize budget;

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
    
    self.title = @"Add Budget";

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [nameField release];
    [amountField release];
    [budget release];
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)save {
    if (([nameField.text length] == 0) || ([amountField.text length] == 0)) {
        [UIHelpers showAlert:@"Whoops!" withMessage:@"Please enter a name and an amount."];
        return;
    }
    
    budget.name = nameField.text;
    budget.amount = [CurrencyHelpers penceToDollars:amountField.text];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(createRemoteBudget) 
                                      onTarget:self];
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark Editing

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

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
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
#pragma mark Private methods

- (void)createRemoteBudget {
    NSError *error = nil;
    BOOL created = [budget createRemoteWithResponse:&error];
    if (created == YES) {
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
    field.returnKeyType = UIReturnKeyNext;
    field.placeholder = @"Name";
    return field;
}

- (UITextField *)newAmountField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.placeholder = @"Amount";
    field.keyboardType = UIKeyboardTypeNumberPad;
    return field;
}

@end
