#import "BudgetAppDelegate.h"

#import "User.h"
#import "AuthenticationViewController.h"
#import "ObjectiveResourceConfig.h"
#import "Helpers.h"

@interface BudgetAppDelegate ()
- (void)configureObjectiveResource;
- (void)authenticate;
- (void)showAuthentication:(User *)user;
- (void)addUserObservers:(User *)user;
- (void)removeUserObservers:(User *)user;
@end

@implementation BudgetAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize user;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
    
    [self configureObjectiveResource];
    [self authenticate];
}

- (void)configureObjectiveResource {    
#if TARGET_IPHONE_SIMULATOR
    [ObjectiveResourceConfig setSite:@"http://localhost:3000/"];
#else
    [ObjectiveResourceConfig setSite:@"https://your-server.com/"];
#endif
    [ObjectiveResourceConfig setResponseType:XmlResponse];
    [ObjectiveResourceConfig setUser:self.user.login];
    [ObjectiveResourceConfig setPassword:self.user.password];
}

- (User *)user {
    if (user == nil) {
        NSURL *url = [NSURL URLWithString:[ObjectiveResourceConfig getSite]];
        self.user = [User currentUserForSite:url];
        [self addUserObservers:user];
    }
    return user;
}

- (void)showAuthentication:(User *)aUser {
    AuthenticationViewController *controller = 
        [[AuthenticationViewController alloc] initWithCurrentUser:aUser];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)authenticate {
    if ([user hasCredentials]) {
        NSError *error = nil;
        BOOL authenticated = [self.user authenticate:&error];
        if (authenticated == NO) {
            [UIHelpers handleRemoteError:error];
            [self showAuthentication:self.user];
        }
    } else {
        [self showAuthentication:self.user];
    }
}

- (void)addUserObservers:(User *)aUser {
    [aUser addObserver:self forKeyPath:kUserLoginKey options:NSKeyValueObservingOptionNew context:nil];
    [aUser addObserver:self forKeyPath:kUserPasswordKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeUserObservers:(User *)aUser {
    [aUser removeObserver:self forKeyPath:kUserLoginKey];
    [aUser removeObserver:self forKeyPath:kUserPasswordKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object change:(NSDictionary *)change 
                       context:(void *)context {
    if ([keyPath isEqualToString:kUserLoginKey]) { 
        [ObjectiveResourceConfig setUser:[object valueForKeyPath:keyPath]];
    } else if ([keyPath isEqualToString:kUserPasswordKey]){
        [ObjectiveResourceConfig setPassword:[object valueForKeyPath:keyPath]];
    }
}

- (void)dealloc {
	[navigationController release];
	[window release];
    [self removeUserObservers:user];
    [user release];
	[super dealloc];
}

@end