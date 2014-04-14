//
//  TimelineController.m
//  intro app
//
//  Created by Michael Timbrook on 4/14/14.
//  Copyright (c) 2014 Michael Timbrook. All rights reserved.
//

#import "TimelineController.h"
#import "TweetCell.h"

@interface TimelineController () <UICollectionViewDataSource>

@end

@implementation TimelineController
{
    @private
    NSArray *tweets;
}

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
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweet" forIndexPath:indexPath];

    // Configure cell here

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tweets.count;
}

@end
