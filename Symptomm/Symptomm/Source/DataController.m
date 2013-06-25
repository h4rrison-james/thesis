//
//  DataController.m
//  Symptomm
//
//  Created by Harrison Sweeney on 2/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataController.h"

@implementation DataController

@synthesize symptomArray, resultsArray, mainArray;

static DataController *sharedClient;

+ (DataController *)sharedClient {
    @synchronized (self) {
        if (!sharedClient)
            sharedClient=[[DataController alloc] init];
    }
    return sharedClient;
}

+ (id)alloc {
    @synchronized(self) {
        NSAssert(sharedClient == nil, @"Cannot create second instance of DataController singleton");
        sharedClient = [super alloc];
    }
    return sharedClient;
}

@end
