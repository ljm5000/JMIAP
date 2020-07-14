# JMIAP
App Store, In-App Purchase

# Usage:

### Step 1

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    ...
    
    [[JMPayManager shareInstance] activate];
    
    ...
}
```
### Step 2

### Step 3

```
 [[JMPayManager shareInstance] beginBuyProduct:@"com.jimmy.tes1.pay1" andCount:10];
```
