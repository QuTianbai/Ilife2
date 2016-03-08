//
//  MSFInfinityScroll.h
//  Finance
//
//  Created by 赵勇 on 12/14/15.
//  Copyright © 2015 MaShang Consumer Finance Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

__attribute__((deprecated("This class is unavailable")))

@interface MSFInfinityScroll : UIView

//传入页数
@property (nonatomic, copy) NSInteger (^numberOfPages)();

//传入展示网络图片的地址
@property (nonatomic, copy) NSURL* (^imageUrlAtIndex)(NSInteger index);

//传入展示本地图片的名称（与上面一种方法二选一）
@property (nonatomic, copy) NSString *(^imageNameAtIndex)(NSInteger index);

//点击banner的响应
@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);

//是否显示pageControl
@property (nonatomic, assign) BOOL openPageControl;

//自动滚动时间间隔，设置为0时不滚动，默认为0
@property (nonatomic, assign) NSTimeInterval interval;

// 当前展示的图片
@property (nonatomic, copy) void (^visiableImageChanged)(UIImage *visiableImage);

//重新加载数据
- (void)reloadData;

@end
