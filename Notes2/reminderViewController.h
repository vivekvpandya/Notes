//
//  reminderViewController.h
//  Notes2
//
//  Created by Vivek Pandya on 22/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import "AppDelegate.h" //for managedObj
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import  "Notes.h"

@interface reminderViewController : UIViewController

- (IBAction)canceled:(id)sender;

- (IBAction)hideKeyBoard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *additionalMessage;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong,nonatomic) EKEventStore * eventStore;
@property (strong,nonatomic) Notes *currentNote;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) EKReminder *reminder;

- (IBAction)okPressed:(id)sender;

@end
