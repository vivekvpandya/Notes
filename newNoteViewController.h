//
//  newNoteViewController.h
//  Notes2
//
//  Created by Vivek Pandya on 17/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newNoteViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSString *currentNoteID;
@property (weak, nonatomic) IBOutlet UINavigationItem *noteTitle;


- (IBAction)donePressed:(id)sender;

@end
