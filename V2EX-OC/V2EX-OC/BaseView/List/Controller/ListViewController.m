//
//  ListViewController.m
//  V2EX-OC
//
//  Created by 张毅成 on 2020/11/25.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@end

@implementation ListViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self.arrayData addObject:@"c"];
    [self.arrayData addObject:@"cc"];
    [self.arrayData addObject:@"ccc"];
    [self.arrayData addObject:@"cccc"];
    [self.arrayData addObject:@"ccccc"];
    [self.arrayData addObject:@"cccc"];
    [self.arrayData addObject:@"ccc"];
    [self.arrayData addObject:@"cc"];
    [self.arrayData addObject:@"c"];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
//    self.tableView.separatorStyle = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [ListTableViewCell cellWithTableView:tableView];
    NSString *string = self.arrayData[indexPath.row];
    cell.labelTitle.text = string;
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
