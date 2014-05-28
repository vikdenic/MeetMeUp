//
//  ViewController.m
//  MeetMeUp
//
//  Created by Yeah Right on 5/27/14.
//  Copyright (c) 2014 Naomi Himley. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property NSDictionary *meetupDictionary;
@property NSArray *resultsArray;
@property (weak, nonatomic) IBOutlet UITableView *meetupTableView;
@property NSDictionary *selectedDictionary;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Capture API via url
    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=7036607661154773506d1d386155a3f"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
            {
                //Setting local dictionary property to deserialization of the json data
            self.meetupDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&connectionError];
                //Fill local array property with api's array of dictionaries (named results)
                self.resultsArray = [self.meetupDictionary objectForKey:@"results"];

                [self.meetupTableView reloadData];
            }
     ];
}

#pragma mark - Custom methods

-(void)searchMethod
{
    // Creates string of url with searched term in placeholder
    NSString *userEntered = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=7036607661154773506d1d386155a3f", self.searchTextField.text];

    // Capture new API from searched term
    NSURL *url = [NSURL URLWithString:userEntered];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // Sets local dictionary property to the dictionary deserialized from the json data
         self.meetupDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&connectionError];
         // Fills local array property with the API's array of dictionaries (named results)
         self.resultsArray = [self.meetupDictionary objectForKey:@"results"];
         [self.meetupTableView reloadData];
     }];
    // Hides keyboard upon search
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)onSearchButtonPressed:(id)sender
{
    // Call custom method that accesses API of searched term
    [self searchMethod];
}

#pragma mark - Datasource Delegates
// Sets number of filled cells to amount of items in API's @"results"
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
}

// Sets text of cells to appropriate values (via API keys)
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDictionary = [self.resultsArray objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meetupCell"];
    cell.detailTextLabel.text = [[[self.resultsArray objectAtIndex:indexPath.row] objectForKey:@"venue"]objectForKey:@"address_1"];
    cell.textLabel.text = [[[self.resultsArray objectAtIndex:indexPath.row] objectForKey:@"group"]objectForKey:@"name"];
    return cell;
}

#pragma mark - PrepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = segue.destinationViewController;
    detailVC.passedDictionary = self.selectedDictionary;
}


@end
