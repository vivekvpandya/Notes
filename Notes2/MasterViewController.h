//
//  MasterViewController.h
//  Notes2
//
//  Created by Vivek Pandya on 17/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "noteViewController.h"

@interface MasterViewController : CoreDataTableViewController <UISearchDisplayDelegate>


@property (nonatomic,weak) NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic)NSArray *notes;


@end
