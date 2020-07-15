# JMIAP
App Store, In-App Purchase

# Usage:

### Step 1

```
#import "JMPayManager.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    ...
    
    [[JMPayManager shareInstance] activate];
    
    ...
}
```
### Step 2
```
#import "JMPayManager.h"
[[JMPayManager shareInstance] setResultBlock:^(JMPAYMENT_STATUS status) {
   
    NSLog(@"%ld",status);
}];

```

### Step 3

```
 [[JMPayManager shareInstance] beginBuyProduct:@"com.jimmy.tes1.pay1" andCount:10];
```
