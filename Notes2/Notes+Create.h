//
//  Notes+Create.h
//  Notes2
//
//  Created by Vivek Pandya on 17/10/13.
//  Copyright (c) 2013 Vivek Pandya. All rights reserved.
//

#import "Notes.h"

@interface Notes (Create)



+(Notes *)noteWithContent:(NSString *)content inManagedObjectContext:(NSManagedObjectContext *)context;


@end
