//
//  DetailViewController.m
//  Symptomm
//
//  Created by Harrison Sweeney on 1/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize descriptionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    NSLog(@"Sending Cypher query");
    
    NSString *symptom = self.navigationItem.title;
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:symptom, @"symptom", nil];
    NSString *query = @"START n=node(*) MATCH n-[r]-m WHERE n.name = {symptom} RETURN n LIMIT 1";
    NSDictionary *requestPayload = [[NSDictionary alloc] initWithObjectsAndKeys:query, @"query", params, @"params", nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:7474"]];
    client.parameterEncoding = AFJSONParameterEncoding;
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client postPath:@"/db/data/cypher/" parameters:requestPayload success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *data = [[[[jsonFromData objectForKey:@"data"] objectAtIndex:0] objectAtIndex:0] objectForKey:@"data"];
        NSLog(@"Success: %@", data);
        
        descriptionView.text = [data objectForKey:@"description"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
