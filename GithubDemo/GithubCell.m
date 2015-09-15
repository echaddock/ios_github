//
//  GithubCell.m
//  GithubDemo
//
//  Created by Liz Chaddock on 9/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "GithubCell.h"

@implementation GithubCell

- (void)awakeFromNib {
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
