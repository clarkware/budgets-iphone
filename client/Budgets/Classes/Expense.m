#import "Expense.h"

#import "CurrencyHelpers.h"

@implementation Expense

@synthesize expenseId;
@synthesize budgetId;
@synthesize name;
@synthesize amount;
@synthesize createdAt;
@synthesize updatedAt;

- (NSString *)amountAsCurrency {
    return [CurrencyHelpers numberToCurrency:self.amount];
}

#pragma mark ObjectiveResource overrides to handle nested resources

+ (NSString *)getRemoteCollectionName {
	return @"budgets";
}

- (NSString *)nestedPath {
	NSString *path = [NSString stringWithFormat:@"%@/expenses", budgetId];
	if (expenseId) {
		path = [path stringByAppendingFormat:@"/%@", expenseId];
	}
	return path;
}

- (BOOL)createRemoteWithResponse:(NSError **)aError {
    return [self createRemoteAtPath:[[self class] getRemoteElementPath:[self nestedPath]] 
                       withResponse:aError];
}

- (BOOL)updateRemoteWithResponse:(NSError **)aError {
    return [self updateRemoteAtPath:[[self class] getRemoteElementPath:[self nestedPath]] 
                       withResponse:aError];
}

- (BOOL)destroyRemoteWithResponse:(NSError **)aError {
    return [self destroyRemoteAtPath:[[self class] getRemoteElementPath:[self nestedPath]] 
                        withResponse:aError];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [expenseId release];
    [budgetId release];
    [name release];
    [amount release];
    [createdAt release];
    [updatedAt release];
	[super dealloc];
}

@end
