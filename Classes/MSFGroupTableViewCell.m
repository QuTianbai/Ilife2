//
// MSFGroupTableViewCell.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFGroupTableViewCell.h"
#import "UIView+Sizes.h"

#define kGroupedTableViewCellSingleRowImageCapInset		UIEdgeInsetsMake(3.0, 20.0, 3.0, 20.0)
#define kGroupedTableViewCellTopRowImageCapInset			UIEdgeInsetsMake(3.0, 20.0, 1.0, 20.0)
#define kGroupedTableViewCellBottomRowImageCapInset		UIEdgeInsetsMake(1.0, 20.0, 5.0, 20.0)
#define kGroupedTableViewCellMiddleRowImageCapInset		UIEdgeInsetsMake(1.0, 20.0, 1.0, 20.0)

#define kCellLabelMargin	13.0

@implementation MSFGroupTableViewCell

+ (GroupedTableViewCellPosition)positionForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    if ([tableView.dataSource tableView:tableView
                  numberOfRowsInSection:[indexPath section]] == 1) {
        return GroupedTableViewCellPositionTopAndBottom;
    }
    if ([indexPath row] == 0) {
        return GroupedTableViewCellPositionTop;
    }
    if ([indexPath row] + 1 == [tableView.dataSource tableView:tableView
                                         numberOfRowsInSection:[indexPath section]]) {
        return GroupedTableViewCellPositionBottom;
    }
    return GroupedTableViewCellPositionMiddle;
}

- (void)prepareForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  _position = [MSFGroupTableViewCell positionForTableView:tableView indexPath:indexPath];
	
	self.backgroundView = [[UIImageView alloc] init];
	self.selectedBackgroundView = [[UIImageView alloc] init];
	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
	
	NSString *singleImageName = @"groupedTableViewCell_singleRow";
	NSString *topImageName = @"groupedTableViewCell_topRow";
	NSString *middleImageName = @"groupedTableViewCell_middleRow";
	NSString *bottomImageName = @"groupedTableViewCell_bottomRow";
		
	
	UIImage *rowBackground;
	
    switch (_position) {
        case GroupedTableViewCellPositionTopAndBottom:
            rowBackground = [[UIImage imageNamed:singleImageName]
                             resizableImageWithCapInsets:kGroupedTableViewCellSingleRowImageCapInset resizingMode:UIImageResizingModeStretch];
            break;
        case GroupedTableViewCellPositionTop:
            rowBackground = [[UIImage imageNamed:topImageName]
                             resizableImageWithCapInsets:kGroupedTableViewCellTopRowImageCapInset resizingMode:UIImageResizingModeStretch];
            break;
        case GroupedTableViewCellPositionMiddle:
            rowBackground = [[UIImage imageNamed:middleImageName]
                             resizableImageWithCapInsets:kGroupedTableViewCellMiddleRowImageCapInset resizingMode:UIImageResizingModeStretch];
            break;
        case GroupedTableViewCellPositionBottom:
            rowBackground = [[UIImage imageNamed:bottomImageName]
                             resizableImageWithCapInsets:kGroupedTableViewCellBottomRowImageCapInset resizingMode:UIImageResizingModeStretch];
            break;
        default:
            break;
    }
    
	[((UIImageView *)self.backgroundView) setImage:rowBackground];
}

@end
