//
//  TimelineController.m
//  intro app
//
//  Created by Michael Timbrook on 4/14/14.
//  Copyright (c) 2014 Michael Timbrook. All rights reserved.
//

@import Social;
@import Accounts;

#import "TimelineController.h"
#import "TweetCell.h"

@interface TimelineController () <UICollectionViewDataSource>

@end

@implementation TimelineController
{
    @private
    NSArray *tweets;
    ACAccount *account;
    NSOperationQueue *imageLoading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;

    imageLoading = [NSOperationQueue new];

    // Get Twitter Account
    ACAccountStore *store = [ACAccountStore new];
    ACAccountType *typeTwitter = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:typeTwitter options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [store accountsWithAccountType:typeTwitter];
            if (accounts.count > 0){
                account = accounts[0];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                SLRequest *timeline = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                         requestMethod:SLRequestMethodGET
                                                                   URL:url
                                                            parameters:nil];
                [timeline setAccount:account];
                [timeline performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    tweets = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }];

            }
        } else {
            // Fail Case
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadImage:(NSURL *)url toImageView:(UIImageView *)imageView
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url.absoluteURL];
    [NSURLConnection sendAsynchronousRequest:request queue:imageLoading completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData:data];
        });
    }];
}

#pragma mark actions

- (IBAction)tweet:(id)sender
{
    UIViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self presentViewController:tweetViewController animated:YES completion:nil];
}

#pragma mark - Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweet" forIndexPath:indexPath];
    NSDictionary *attr = tweets[indexPath.row];

    NSURL *profileURL = [NSURL URLWithString:attr[@"user"][@"profile_image_url"]];
    NSLog(@"%@", profileURL);

    cell.tweet.text = attr[@"text"];
    [self loadImage:profileURL toImageView:cell.profileImage];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tweets.count;
}

@end
