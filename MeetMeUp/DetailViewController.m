//
//  DetailViewController.m
//  MeetMeUp
//
//  Created by Vik Denic on 5/27/14.
//  Copyright (c) 2014 Vik Denic. All rights reserved.
//

#import "DetailViewController.h"
#import "SiteViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *hgiLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpLabel;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedString = [self.passedDictionary objectForKey:@"event_url"];

    self.title = [[self.passedDictionary objectForKey:@"group"]objectForKey:@"who"];
    self.rsvpLabel.text = [NSString stringWithFormat:@"Attending: %@",[self.passedDictionary objectForKey:@"yes_rsvp_count"]];

    [self.descriptionWebView loadHTMLString:[self.passedDictionary objectForKey:@"description"] baseURL:nil];

    //loadhtmlstring

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SiteViewController *siteVC = segue.destinationViewController;
    siteVC.passedString = self.selectedString;
}

@end
