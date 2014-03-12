//
//  MasterViewController.m
//  Notes2
//
//  Created by Vivek Pandya on 17/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Notes.h"
#import "Notes+Create.h"
#import "noteViewController.h"


@implementation MasterViewController
{

}

@synthesize notes;
@synthesize managedObjectContext;


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont  preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        Notes *noteForcell= [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //cell.textLabel.text = noteForcell.content;
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateStyle:NSDateFormatterFullStyle];
    
    
    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UIFont* font2 = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

    UIColor* textColor = [UIColor colorWithRed:0.99f green:0.21f blue:0.41f alpha:1.0f];
     UIColor* textColor2 = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.0f];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                                                                                                            NSFontAttributeName : font, NSTextEffectAttributeName :
                                                                                                                         NSTextEffectLetterpressStyle};
    NSDictionary *attrs2 = @{ NSForegroundColorAttributeName : textColor2,
                             NSFontAttributeName : font2, NSTextEffectAttributeName :
                                 NSTextEffectLetterpressStyle};
    

    NSAttributedString *attrStr = [[NSAttributedString alloc]
                                   initWithString:noteForcell.content attributes:attrs];
    cell.textLabel.attributedText = attrStr;
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc]initWithString:[dateFormater stringFromDate:noteForcell.lmDate] attributes:attrs2];
    
        cell.detailTextLabel.attributedText = attrStr2;
        
        return cell;
}




-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
   // [self uiDemoDocument];
    
  //[Notes noteWithContent:@"First Note" inManagedObjectContext:self.managedObjectContext];
   //[Notes noteWithContent:@"This is from data base" inManagedObjectContext:self.managedObjectContext];

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
 
/*- (IBAction)show:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notes"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lmDate" ascending:YES]];
    request.predicate = nil;
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                     cacheName:nil];

    
    
    [self.tableView reloadData];
   
} */

-(void)viewDidAppear:(BOOL)animated{

    [self justRefresh];
}

-(void)viewDidLoad{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = delegate.managedObjectContext;

    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}


-(IBAction)refresh{

    [self.refreshControl beginRefreshing];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notes"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lmDate" ascending:NO]];
    request.predicate = nil;
    request.fetchBatchSize  = 20;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                     cacheName:nil];
    
   self.notes = [self.fetchedResultsController fetchedObjects];
    
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void)justRefresh
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notes"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lmDate" ascending:NO]];
    request.predicate = nil;
    request.fetchBatchSize  = 20;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                     cacheName:nil];
    
self.notes = [self.fetchedResultsController fetchedObjects];
    
    [self.tableView reloadData];


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    noteViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"noteView"];
    Notes *passNote = [self.notes objectAtIndex:indexPath.row];
    detailViewController.currentNote = passNote;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)preferredContentSizeChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static UILabel* label; if (!label) {
        label = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, 0, FLT_MAX, FLT_MAX)];
        label.text = @"test"; }
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]; [label sizeToFit];
    return label.frame.size.height * 2;
}



@end