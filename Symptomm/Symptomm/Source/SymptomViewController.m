//
//  SymptomViewController.m
//  Symptomm
//
//  Created by Harrison Sweeney on 1/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import "SymptomViewController.h"

@interface SymptomViewController ()

@end

@implementation SymptomViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Enable editing of the current symptom list.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"Cypher: Requesting Symptom List");
    
    NSString *query = @"START n=node(*) RETURN n.name";
    NSDictionary *requestPayload = [[NSDictionary alloc] initWithObjectsAndKeys:query, @"query", nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:7474"]];
    client.parameterEncoding = AFJSONParameterEncoding;
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client postPath:@"/db/data/cypher/" parameters:requestPayload success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *resultArray = [jsonFromData objectForKey:@"data"];
        
        NSLog(@"Success: %d results", [resultArray count]);
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSArray *symptom in resultArray) {
            //NSLog(@"%@", symptom[0]);
            [array addObject:symptom[0]];
        }
        [DataController sharedClient].mainArray = array;
        NSLog(@"%@", [DataController sharedClient].mainArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataController sharedClient].symptomArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SymptomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[DataController sharedClient].symptomArray objectAtIndex:[indexPath row]];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[DataController sharedClient].symptomArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }     
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
