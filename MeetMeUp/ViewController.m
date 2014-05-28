//
//  ViewController.m
//  MeetMeUp
//
//  Created by Vik Denic on 5/27/14.
//  Copyright (c) 2014 Vik Denic. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property NSDictionary *meetupDictionary;
@property NSArray *resultsArray;
@property NSArray *resultsArray2;
@property (weak, nonatomic) IBOutlet UITableView *meetupTableView;
@property NSDictionary *selectedDictionary;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property UIImage *thumbImage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;

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

    // Run custom search method on term "mobile"
    [self searchMethod];
}

#pragma mark - Custom methods

-(void)searchMethod
{
    // Creates string of url with searched term in placeholder

    // Added " &fields=group_photo " to URL in order to access photos
    NSString *userEntered = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=7036607661154773506d1d386155a3f&fields=group_photo", self.searchBar.text];

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
    [self.searchBar resignFirstResponder];
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

    // Accesses group_photo dictionary followed by group thumbnail photo
    NSDictionary *groupPhotoDictionary = [[[self.resultsArray objectAtIndex:indexPath.row] objectForKey:@"group"]objectForKey:@"group_photo"];
    NSURL *thumbURL = [NSURL URLWithString:[groupPhotoDictionary objectForKey:@"thumb_link"]];
    self.thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbURL]];
    // Sets cell's image
    cell.imageView.image = self.thumbImage;

    return cell;
}

#pragma mark - Search Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Call custom method that accesses API of searched term
    [self searchMethod];
}

#pragma mark - PrepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = segue.destinationViewController;
    detailVC.passedDictionary = self.selectedDictionary;
}

@end
