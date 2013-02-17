//
//  DataService.h
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataService : NSObject {
    
}
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DataService *) sharedDataService;

- (void) saveContext: (NSManagedObjectContext *) context;
- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;

@end
