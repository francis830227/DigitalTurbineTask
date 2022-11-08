//
//  OfferTableViewCell.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "OfferTableViewCell.h"

@implementation OfferTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)updateContentsWithTitle:(NSString *)title andImageURL:(NSURL *)url {
    titleLabel.text = title;
}

- (void)setupViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    titleLabel = [UILabel new];
    imageView = [UIImageView new];
    
    titleLabel.numberOfLines = 0;    
    
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:titleLabel];
    
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = true;
    [imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = true;
    [imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = true;
    [imageView.widthAnchor constraintEqualToAnchor:imageView.heightAnchor].active = true;
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = true;
    [titleLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:10].active = true;
    [titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = true;
    [titleLabel.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor].active = true;
}

@end
