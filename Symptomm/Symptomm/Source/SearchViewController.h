//
//  SearchViewController.h
//  Symptomm
//
//  Created by Harrison Sweeney on 1/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "SymptomViewController.h"

@interface SearchViewController : UITableViewController {
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSArray *allItems;
    NSArray *searchResults;
}

- (IBAction)doneButtonPressed:(id)sender;
- (void)accessoryButtonTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *allItems;
@property (strong, nonatomic) NSArray *searchResults;

@end
