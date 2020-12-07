//
//  ListTableViewCell.h
//  V2EX-OC
//
//  Created by 张毅成 on 2020/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
