#import "ObjectiveResource.h"

@interface Budget : NSObject {
    NSString *budgetId;
    NSString *name;
    NSString *amount;
    NSDate   *updatedAt;
    NSDate   *createdAt;
}

@property (nonatomic, copy) NSString *budgetId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSDate *createdAt;

- (NSArray *)findAllExpenses;
- (NSString *)amountAsCurrency;

@end