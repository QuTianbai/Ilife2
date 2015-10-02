//
// MSFGroupTableViewCell.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GroupedTableViewCellPositionTop = 0,
    GroupedTableViewCellPositionMiddle,
    GroupedTableViewCellPositionBottom,
    GroupedTableViewCellPositionTopAndBottom
} GroupedTableViewCellPosition;

@interface MSFGroupTableViewCell : UITableViewCell

@property (nonatomic, assign) GroupedTableViewCellPosition position;
- (void)prepareForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
