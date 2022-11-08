//
//  ListViewController.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "ListViewController.h"
#import "OfferTableViewCell.h"
#import "Offer.h"

@interface ListViewController ()

@property NSArray *offers;

@end

@implementation ListViewController

static NSString *cellIdentifier = @"cell";

- (instancetype) initWithOffers: (NSArray *)offers {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.offers = offers;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:OfferTableViewCell.class forCellReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:tableView];
    
    tableView.translatesAutoresizingMaskIntoConstraints = false;
    [tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Offer *offer = _offers[indexPath.row];
    [cell updateContentsWithTitle:offer.title
                      andImageURL:offer.imageURL];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _offers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"hihi";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


@end
