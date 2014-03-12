//
//  newNoteViewController.m
//  Notes2
//
//  Created by Vivek Pandya on 17/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//
#import "AppDelegate.h"
#import "newNoteViewController.h"
#import "Notes+Create.h"

@interface newNoteViewController ()

@end

@implementation newNoteViewController

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
    
    self.currentNoteID = nil;
   
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = delegate.managedObjectContext;

    
 //   [self getUIManagedObj];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.noteTextView];
    
    
    
    CGRect accessFrame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    compButton.frame = CGRectMake(0,0, 40, 30);
    [compButton setBackgroundColor:[UIColor blackColor]];
    [compButton setTitle: @"Done" forState:UIControlStateNormal];
    [compButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [compButton addTarget:self action:@selector(dismissKey) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:compButton];
    
    self.noteTextView.inputAccessoryView = inputAccessoryView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender {
    [self.noteTextView resignFirstResponder];
    
    NSUInteger len = self.noteTextView.text.length ;
    int lenInt = (int)len;
    //  NSLog(@"len-->%d\n",lenInt);
    
    if (lenInt != 0) {
        
        if (lenInt < 15) {
            self.noteTitle.title = self.noteTextView.text;
            
        }
        else{
            NSString *noteTitle = [self.noteTextView.text substringToIndex:15];
            self.noteTitle.title = noteTitle;
            
        }
        
        if (self.currentNoteID != nil) {
            NSLog(self.currentNoteID);
        }
        else{
            NSLog(@"else");
            Notes *note =   [Notes noteWithContent:self.noteTextView.text inManagedObjectContext:self.managedObjectContext];
            self.currentNoteID = note.noteID;
        }
        
    }
    
    
    else {
        NSLog(@"No Problem here\n");
    }
    
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


-(void)dismissKey{

    [self.noteTextView resignFirstResponder];

}


/*-(void)getUIManagedObj
{
    
    NSURL *url  = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    
    UIManagedDocument *mdocument = [[UIManagedDocument alloc]initWithFileURL:url];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path]]) {
        [mdocument saveToURL:url
            forSaveOperation:UIDocumentSaveForCreating
           completionHandler:^(BOOL success) {
               if (success) {
                   
               }
           }];
        
        self.managedObjectContext = mdocument.managedObjectContext;
    }
    else if (mdocument.documentState == UIDocumentStateClosed)
    {
        [mdocument openWithCompletionHandler:^(BOOL success) {
            if(success)
            {
                
            }
        }];
    
        self.managedObjectContext = mdocument.managedObjectContext;
        
    }
    
    else{
        self.managedObjectContext = mdocument.managedObjectContext;
    }
}*/

@end
