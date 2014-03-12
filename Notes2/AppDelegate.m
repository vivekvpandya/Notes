

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "newNoteViewController.h"


@implementation AppDelegate

@synthesize managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    //MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    //controller.managedObjectContext = self.managedObjectContext;
    // [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:92.0/256.0 green:23.0/256.0 blue:235.0/256.0 alpha:1.0]];
    
    [self getUIManagedObj];
    
    UILocalNotification *loc = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (loc == nil) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
   
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}




#pragma mark - Core Data stack

// Returns the managed object context for the application.

-(void)getUIManagedObj
{
    
    NSURL *url  = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    
    UIManagedDocument *mdocument = [[UIManagedDocument alloc]initWithFileURL:url];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path]]) {
        [mdocument saveToURL:url
            forSaveOperation:UIDocumentSaveForCreating
           completionHandler:^(BOOL success) {
               if (success == YES) {
                   NSLog(@"success1");
                   
               }
           }];
        
        self.managedObjectContext = mdocument.managedObjectContext;
    }
    else if (mdocument.documentState == UIDocumentStateClosed)
    {
        [mdocument openWithCompletionHandler:^(BOOL success) {
            if(success == YES)
            {
                NSLog(@"success");
            }
        }];
        
        self.managedObjectContext = mdocument.managedObjectContext;
        
    }
    
    else{
        self.managedObjectContext = mdocument.managedObjectContext;
        }


}




@end