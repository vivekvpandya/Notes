//
//  noteViewController.m
//  Notes2
//
//  Created by Vivek Pandya on 18/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import "noteViewController.h"
#import <Social/Social.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "reminderViewController.h"
#import "AppDelegate.h"


@interface noteViewController ()

{

    NSArray *fetchedReminders;

    UIToolbar *inputaccessory;
    
    UIImage *largeImage;
}
@end

@implementation noteViewController

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
   // [self uiDemoDocument];
    [super viewDidLoad];
    
    
    self.contentView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = delegate.managedObjectContext;

    
    [self.imageView setUserInteractionEnabled:YES];
    
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    if (self.currentNote.imageURL == nil) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(85.0, 300.0, 150.0, 150.0)];

        
    }
    else
    {
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            if (iref) {
                largeImage = [UIImage imageWithCGImage:iref];
                
                NSLog(@"succsess\n");
               
                //self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.currentNote.imX.floatValue,self.currentNote.imY.floatValue , 200.0, 200.0)];
           
               // UIImageView *newView = [[UIImageView alloc]initWithFrame:CGRectMake(70.0, 300.0, 200.0, 200.0)];
              //  newView.image = largeImage;
                
              //  [self.view addSubview:newView];
                
               self.imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(85.0, 300.0, 150.0, 150.0)];
                self.imageView.image = largeImage;
                
                [self.view addSubview:self.imageView];
                
                //[self.imageView setExclusiveTouch:YES];
                
            }
                
        };
        
        //
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
        };
        
        
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init] ;
        [assetslibrary assetForURL:[NSURL URLWithString:self.currentNote.imageURL]
                       resultBlock:resultblock
                      failureBlock:failureblock];
       
        
        
    
    }
    
    
    self.contentView.text = self.currentNote.content;
    
    NSUInteger len = self.contentView.text.length ;
    int lenInt = (int)len;
    //  NSLog(@"len-->%d\n",lenInt);
    
    if (lenInt != 0) {
        
        if (lenInt < 15) {
            self.navigationItem.title = self.contentView.text;
            
        }
        else{
            NSString *noteTitle = [self.contentView.text substringToIndex:15];
            self.navigationItem.title = noteTitle;
            
        }
    
	// Do any additional setup after loading the view.
}
    
    self.store = [[EKEventStore alloc]init];
    
    [self.store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            NSLog(@"Granted\n");
            
        }
        else
        {
            
            NSLog(@"access not granted\n");
            
        }
    }];

   
    NSPredicate   *fetchPre = [self.store predicateForRemindersInCalendars:nil];
    if (self.currentNote.reminderID) {
        NSLog(@"here goes");
        [self.store fetchRemindersMatchingPredicate:fetchPre completion:^(NSArray *reminders) {
            
            for (EKReminder *reminder in reminders ) {
                
                if ([reminder.calendarItemIdentifier isEqualToString:self.currentNote.reminderID]) {
                    NSLog(@"ok thre");
                    
                    self.fetchedReminder =  reminder;
                }
                
            }
        }];
        

    }
    else{
        NSLog(@"here it goes");
        self.fetchedReminder = nil;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.contentView];
    
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateStyle:NSDateFormatterFullStyle];
    
    self.dateLable.text = [dateFormater stringFromDate:self.currentNote.lmDate];
  

    CGRect accessFrame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    compButton.frame = CGRectMake(0,0, 40, 30);
    [compButton setBackgroundColor:[UIColor blackColor]];
    [compButton setTitle: @"Done" forState:UIControlStateNormal];
    [compButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [compButton addTarget:self action:@selector(dismissKey) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:compButton];

    self.contentView.inputAccessoryView = inputAccessoryView;

}

-(void)textFieldChanged:(NSNotification*)notification
{
    UITextView *txt = (UITextView *)[notification object];

    NSLog(@"inside notification");
    
    if([txt.text length] == 0){
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
        self.navigationItem.title = txt.text;
    }
    
    if ([txt.text length] >0 ) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        NSString *title;
        if ([txt.text length]> 15) {
             title = [txt.text substringToIndex:15];
        }
        else
        {
            title = txt.text;
        }
      
        
        self.navigationItem.title = title;
    }
    
        }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

- (IBAction)saveNote:(id)sender {
    if([self.contentView.text length] > 0 ){
        
        NSLog(@"inside");
    [self.contentView resignFirstResponder];
    
        self.currentNote.content = self.contentView.text;
        self.currentNote.lmDate = [NSDate date];
    
    NSUInteger len = self.contentView.text.length ;
    int lenInt = (int)len;
    if (lenInt != 0) {
        
        if (lenInt < 15) {
            self.navigationItem.title = self.contentView.text;
            
        }
        else{
            NSString *noteTitle = [self.contentView.text substringToIndex:15];
            self.navigationItem.title = noteTitle;
            
        }

    }
    }
    
    
    
    
    
}

- (IBAction)deleteNote:(id)sender {
    
    if (self.managedObjectContext != nil) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Notes"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"noteID == %@",self.currentNote.noteID];
        
        NSError *error;
        NSArray *fetched =   [self.managedObjectContext executeFetchRequest:request error:&error];
        NSLog(@"%@ --> %@",error,[error description]);
        
        for(NSManagedObject  *fetchedNote in fetched)
            
        {
            [self.managedObjectContext deleteObject:fetchedNote];
        }
    
        
        [self.managedObjectContext save:&error];
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
                                   
    
}

- (IBAction)addImage:(id)sender {
    
    self.imageChoose = [[UIActionSheet alloc]initWithTitle:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take New Photo",@"Choose Exsiting", nil];
    self.imageChoose.tag = 1;
    [self.imageChoose showInView:self.view];
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex    {
    
    if (actionSheet == self.imageChoose) {
    
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"User pressed cancel button");
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:NULL];
            }
            else{
            
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notes Alert" message:@"Your device don't have camera " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            break;
            
            case 1:
            picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
       
    }
        
    }
    
    
    if (actionSheet == self.reminder1) {
        
        if (buttonIndex == 0) {
            NSLog(@"inside");
            //CGRect rect = CGRectMake(0.0, 300.0, 320.0, 200.0);
      reminderViewController* reminderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"reminder"];
            reminderViewController.currentNote = self.currentNote;
            reminderViewController.reminder = nil;
            reminderViewController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:reminderViewController animated:YES completion:NULL];

        }

        
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            NSLog(@"cancel reminder");
        }
        
        
    }
    
    if (actionSheet == self.reminder2) {
        
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            NSLog(@"cancel change reminder");
            
        }
        
        if (buttonIndex == 1) {
           
            NSLog(@"getting up to here");
            
            [self.store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                                    NSLog(@"%@",error.description);
                
            }];
            
           
             NSLog(@"%@",self.currentNote.reminderID);
            NSPredicate   *fetchPre = [self.store predicateForRemindersInCalendars:nil];
            
            [self.store fetchRemindersMatchingPredicate:fetchPre completion:^(NSArray *reminders) {
                for(EKReminder *reminder in reminders)
                {
                     NSLog(@"%@",reminder.calendarItemIdentifier);
                   
                    if ([reminder.calendarItemIdentifier isEqualToString:self.currentNote.reminderID]) {
                        reminder.completed = YES;
                        self.currentNote.reminderID = nil;
                        self.fetchedReminder = nil;
                        NSLog(@"got it");
                    }
                }
            }];
            
            
            
            
            
        }
        
        
        if (buttonIndex == 0) {
            
            reminderViewController* reminderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"reminder"];
            reminderViewController.currentNote = self.currentNote;
            reminderViewController.reminder = self.fetchedReminder;
            reminderViewController.eventStore = self.store;
            reminderViewController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:reminderViewController animated:YES completion:NULL];

            
        }
        
    }

}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        NSLog(@"camera exception handeled");
        return;
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    NSLog(@"User pressed cancel in image picker");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.currentNote.imageURL == nil) {
        self.currentNote.imageURL = [[info valueForKey:UIImagePickerControllerReferenceURL] absoluteString];
        self.currentNote.imX = [NSNumber numberWithFloat:self.imageView.center.x];
        self.currentNote.imY = [NSNumber numberWithFloat:self.imageView.center.y];
        self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self.view addSubview:self.imageView];
    }
        else
        {
        
            self.currentNote.imageURL = [[info valueForKey:UIImagePickerControllerReferenceURL] absoluteString];
            self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
           // [self.view addSubview:self.imageView];
       
           /* UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Currently Notes only supprots one image!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        */
            
            
        }
        
        
        
    
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}





//Facebook
- (IBAction)postToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:self.contentView.text];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

//Twitter
- (IBAction)postToTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:self.contentView.text];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}
//Email
- (IBAction)emailNote:(id)sender {
    // Email Subject
    //NSString *emailTitle = @"Subject";
    // Email Content
    NSString *messageBody = self.contentView.text;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    mc.mailComposeDelegate = self;
    mc.title = @"My Note";
    //[mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//Message

- (IBAction)messageNote:(id)sender {
    //NSURL *message = @"sms:";
    //[[UIApplication sharedApplication] openURL:message];
    NSString *message = self.contentView.text;
    [self showSMS:message];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSMS:(NSString*)note {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@""];
    NSString *message = self.contentView.text;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self saveNote:nil];
    
    [super viewWillDisappear:animated];
    
    
    
}
- (IBAction)addReminder:(id)sender {
    
    if (self.fetchedReminder == nil) {
        
        NSLog(@"still here");
        self.reminder1 = [[UIActionSheet alloc]initWithTitle:@"Reminder" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Reminder", nil];
        
        
        [self.reminder1 showInView:self.view];
    }
    else{
        
    
    if (self.fetchedReminder.completed == NO)
    {self.reminder2 = [[UIActionSheet alloc]initWithTitle:@"Reminder" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Change Reminder",@"Mark as Done" ,nil];
        
        
        [self.reminder2 showInView:self.view];
        

       
        
    }
    
    else
    {
        
     self.reminder1 = [[UIActionSheet alloc]initWithTitle:@"Reminder" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Reminder", nil];
   
        
        [self.reminder1 showInView:self.view];
    
    }
    }
    
    
}




/*-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"here goes to");
	UITouch *touch = [[event touchesForView:self.imageView] anyObject];
	CGPoint location = [touch locationInView:self.imageView];
	self.imageView.center = location;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesBegan:touches withEvent:event];
}
*/
-(void)preferredContentSizeChanged:(NSNotification *)notification
{

    self.contentView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
   
}

-(void)viewDidLayoutSubviews{
    
    
    
    
}

-(void)dismissKey{

    [self.contentView resignFirstResponder];
}






@end