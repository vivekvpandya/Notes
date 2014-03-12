//
//  Notes+Create.m
//  Notes2
//
//  Created by Vivek Pandya on 17/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import "Notes+Create.h"

@implementation Notes (Create)


+(Notes *)noteWithContent:(NSString *)content
   inManagedObjectContext:(NSManagedObjectContext *)context{

    Notes *note = nil;
    

    
    
    note = [NSEntityDescription insertNewObjectForEntityForName:@"Notes"
                                         inManagedObjectContext:context];
    
    note.content = content;
    note.lmDate = [NSDate date];
    note.imageURL = nil;
    note.imX = nil;
    note.imY = nil;
    note.reminderID = nil;
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
   
    
    note.noteID =  (__bridge NSString *)uuidStringRef;
    
    
    
    return  note;


}

@end
