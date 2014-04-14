//
//  TweetCell.h
//  intro app
//
//  Created by Michael Timbrook on 4/14/14.
//  Copyright (c) 2014 Michael Timbrook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *tweet;

@end
