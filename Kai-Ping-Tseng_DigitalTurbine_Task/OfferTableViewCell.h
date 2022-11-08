//
//  OfferTableViewCell.h
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import <UIKit/UIKit.h>


@interface OfferTableViewCell : UITableViewCell {
    
@private UILabel *titleLabel;
    
@private UIImageView *imageView;
    
}

- (void)updateContentsWithTitle:(NSString *)title andImageURL:(NSURL *)url;

@end


