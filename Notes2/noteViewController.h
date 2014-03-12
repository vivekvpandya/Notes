//
//  noteViewController.h
//  Notes2
//
//  Created by Vivek Pandya on 18/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
#import "Notes.h"
#import <MessageUI/MessageUI.h>

@interface noteViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (strong,nonatomic)UIActionSheet *imageChoose;
@property (strong,nonatomic)UIActionSheet *reminder1;
@property (strong,nonatomic)UIActionSheet *reminder2;
@property (strong,nonatomic)EKEventStore *store;
@property (strong,nonatomic) EKReminder *fetchedReminder;


@property(strong,nonatomic)UIDatePicker *datePicker;
- (IBAction)addReminder:(id)sender;

//@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
- (IBAction)saveNote:(id)sender;

@property (nonatomic,weak) Notes *currentNote;
- (IBAction)deleteNote:(id)sender;

- (IBAction)addImage:(id)sender;

- (IBAction)postToFacebook:(id)sender;
- (IBAction)postToTwitter:(id)sender;


- (IBAction)emailNote:(id)sender;
- (IBAction)messageNote:(id)sender;


@end
