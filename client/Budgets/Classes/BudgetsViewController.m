#import "BudgetsViewController.h"

#import "Budget.h"
#import "Helpers.h"
#import "ConnectionManager.h"
#import "BudgetAddViewController.h"
#import "BudgetDetailViewController.h"

@interface BudgetsViewController ()
- (void)fetchRemoteBudgets;
- (UIBarButtonItem *)newAddButton;
- (void)showBudget:(Budget *)budget;
- (void)deleteRowsAtIndexPaths:(NSArray *)array;
- (void)destroyRemoteBudgetAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BudgetsViewController

@synthesize budgets;
@synthesize tableView;

#pragma mark -
#pragma mark Actions

- (IBAction)add {
    Budget *budget = [[Budget alloc] init];
    BudgetAddViewController *controller = 
        [[BudgetAddViewController alloc] initWithBudget:budget];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [budget release];
}

- (IBAction)refresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(fetchRemoteBudgets) 
                                      onTarget:self];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Budgets";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [self newAddButton];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [budgets release];
    [tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [budgets count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *BudgetCellId = @"BudgetCellId";
    
    UITableViewCell *cell = 
        [aTableView dequeueReusableCellWithIdentifier:BudgetCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:BudgetCellId] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Budget *budget = [budgets objectAtIndex:indexPath.row];
    cell.textLabel.text = budget.name;
    cell.detailTextLabel.text = [budget amountAsCurrency];
    
    return cell;
}

-  (void)tableView:(UITableView *)aTableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView beginUpdates]; 
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[ConnectionManager sharedInstance] runJob:@selector(destroyRemoteBudgetAtIndexPath:) 
                                          onTarget:self
                                      withArgument:indexPath];
    }
    [aTableView endUpdates]; 
} 

- (void)destroyRemoteBudgetAtIndexPath:(NSIndexPath *)indexPath {
    Budget *budget = [budgets objectAtIndex:indexPath.row];
    NSError *error = nil;
    BOOL destroyed = [budget destroyRemoteWithResponse:&error];
    if (destroyed == YES) {
        [budgets removeObjectAtIndex:indexPath.row];
        [self performSelectorOnMainThread:@selector(deleteRowsAtIndexPaths:) 
                               withObject:[NSArray arrayWithObject:indexPath]  
                            waitUntilDone:NO];
    } else {    
        [UIHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)array {
    [tableView deleteRowsAtIndexPaths:array
                     withRowAnimation:UITableViewRowAnimationFade]; 
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Budget *budget = [budgets objectAtIndex:indexPath.row];
    [self showBudget:budget];
}

#pragma mark -
#pragma mark Private methods

- (void)fetchRemoteBudgets {
    NSError *error = nil;
    self.budgets = [Budget findAllRemoteWithResponse:&error];
    if (self.budgets == nil && error != nil) {
        [UIHelpers handleRemoteError:error];
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                     withObject:nil 
                                  waitUntilDone:NO]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showBudget:(Budget *)budget {
	BudgetDetailViewController *controller = 
        [[BudgetDetailViewController alloc] initWithBudget:budget];
	[self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (UIBarButtonItem *)newAddButton {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                 target:self 
                                 action:@selector(add)];
}

@end
