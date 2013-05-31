//
//  ResultsViewController.m
//  Symptomm
//
//  Created by Harrison Sweeney on 1/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import "ResultsViewController.h"

@implementation ResultsViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Sending Cypher query");
    
    //Build the parameters dictionary
    NSArray *symptoms = [DataController sharedClient].symptomArray;
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:symptoms, @"array", nil];
    NSString *query = @"START n=node(*) MATCH n-[r]-m WHERE type(r) = 'related to' and n.type = 'symptom' WITH n, collect(distinct m.name) as groups WHERE ANY(x in groups where x in {array}) RETURN n.name, length(filter(j in groups : j in {array})) ORDER BY length(filter(j in groups : j in {array})) DESC";
    NSDictionary *requestPayload = [[NSDictionary alloc] initWithObjectsAndKeys:query, @"query", params, @"params", nil];
        
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:7474"]];
    client.parameterEncoding = AFJSONParameterEncoding;
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client postPath:@"/db/data/cypher/" parameters:requestPayload success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *resultArray = [jsonFromData objectForKey:@"data"];
        [DataController sharedClient].resultsArray = [resultArray mutableCopy];
        [self.tableView reloadData];
        
        NSLog(@"Success: %d results", [resultArray count]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
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
    // Return the number of rows in the section.
    return [[DataController sharedClient].resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *symptom = [[DataController sharedClient].resultsArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [symptom objectAtIndex:0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ symptoms matched", [symptom objectAtIndex:1]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Do Nothing
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    [segue.destinationViewController navigationItem].title = cell.textLabel.text;
}

@end
