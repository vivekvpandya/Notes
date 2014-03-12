//
//  reminderViewController.m
//  Notes2
//
//  Created by Vivek Pandya on 22/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import "reminderViewController.h"

@interface reminderViewController ()

@end

@implementation reminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self uiDemoDocument];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = delegate.managedObjectContext;
    
    [self.datePicker setMinimumDate:[NSDate date]];
    
    if (self.eventStore == nil) {
        self.eventStore = [[EKEventStore alloc]init];

    }
      [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            NSLog(@"Granted\n");
            
        }
        else
        {
        
            NSLog(@"access not granted\n");
       
        }
    }];
    
    self.additionalMessage.text = self.currentNote.content;
    
  /*  NSArray *calender = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
  
    for (EKCalendar *cal in calender ) {
        
        NSLog(@"title ---> %@",cal.title);
        
    }
    */
    
    
    	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)canceled:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)hideKeyBoard:(id)sender {
    
    [self.additionalMessage resignFirstResponder];
    
}
- (IBAction)okPressed:(id)sender {
    NSLog(@"IN");
    NSDate *pickerDate = [self.datePicker date];
    
    if (self.reminder == nil) {
        EKReminder *reminder = [EKReminder
                         reminderWithEventStore:self.eventStore];
        
        reminder.title = self.additionalMessage.text;
       reminder.calendar = [self.eventStore defaultCalendarForNewReminders];
        
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:pickerDate];
        [reminder addAlarm:alarm];
        NSError *error = nil;
        [self.eventStore saveReminder:reminder commit:YES
                                error:&error];
        self.currentNote.reminderID = reminder.calendarItemIdentifier;
        
        
        NSLog(@"error = %@", error);
        NSLog(@"%@",self.currentNote.reminderID);
        
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    }
    
    else{
    
        
        self.reminder.title = self.additionalMessage.text;
        self.reminder.calendar = [self.eventStore defaultCalendarForNewReminders];
        
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:pickerDate];
        [self.reminder addAlarm:alarm];
        NSError *error = nil;
        [self.eventStore saveReminder:self.reminder commit:YES
                                error:&error];
        self.currentNote.reminderID = self.reminder.calendarItemIdentifier;
        
        
        NSLog(@"error ---->>>> = %@", error);
        NSLog(@"%@",self.currentNote.reminderID);
        
        [self dismissViewControllerAnimated:YES completion:NULL];
        
        self.reminder = nil;
    }
   

}




/*-(void)uiDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc]initWithFileURL:url];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path]])
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            
            if (success) {
                //load
            }
        } ];
        
        self.managedObjectContext = document.managedObjectContext;
        
    }
    else if (document.documentState == UIDocumentStateClosed)
        
    {
        
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                
            }
        }];
        
        self.managedObjectContext  = document.managedObjectContext;
    }
    
    else{
        
        self.managedObjectContext = document.managedObjectContext;
        
    }
}*/


@end
