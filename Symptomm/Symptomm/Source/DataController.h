//
//  DataController.h
//  Symptomm
//
//  Created by Harrison Sweeney on 2/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

@interface DataController : NSObject {
    //An array of City objects representing all pins on the map
    NSMutableArray *symptomArray;
}

@property (nonatomic, retain) NSMutableArray *symptomArray;

+(DataController *)sharedClient;

@end
