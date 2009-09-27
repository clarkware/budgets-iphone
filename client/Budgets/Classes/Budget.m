#import "Budget.h"

#import "Expense.h"
#import "CurrencyHelpers.h"

@implementation Budget

@synthesize budgetId;
@synthesize name;
@synthesize amount;
@synthesize updatedAt;
@synthesize createdAt;

- (NSArray *)findAllExpenses {
	return [Expense findRemote:[NSString stringWithFormat:@"%@/%@", 
                                budgetId, @"expenses"]];
}

- (NSString *)amountAsCurrency {
    return [CurrencyHelpers numberToCurrency:self.amount];
}

- (void) dealloc {
    [budgetId release];
    [name release];
    [amount release];
    [updatedAt release];
    [createdAt release];
	[super dealloc];
}

@end
