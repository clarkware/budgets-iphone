#import "ObjectiveResource.h"

@interface Expense : NSObject {
    NSString *expenseId;
    NSString *budgetId;
    NSString *name;
    NSString *amount;
    NSDate   *updatedAt;
    NSDate   *createdAt;
}

@property (nonatomic, copy) NSString *expenseId;
@property (nonatomic, copy) NSString *budgetId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSDate *createdAt;
    
- (NSString *)amountAsCurrency;

@end