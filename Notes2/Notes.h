//
//  Notes.h
//  Notes2
//
//  Created by Vivek Pandya on 31/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * imX;
@property (nonatomic, retain) NSNumber * imY;
@property (nonatomic, retain) NSDate * lmDate;
@property (nonatomic, retain) NSString * noteID;
@property (nonatomic, retain) NSString * reminderID;

@end
