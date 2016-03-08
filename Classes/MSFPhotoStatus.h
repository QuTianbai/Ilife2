//
//	MSFPhotoStatus.h
//	Cash
//
//	Created by xbm on 15/6/3.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@class MSFPhoto;

__attribute__((deprecated("This class is unavailable.")))

@interface MSFPhotoStatus : MSFObject

@property (nonatomic, copy) MSFPhoto *id_photo;
@property (nonatomic, copy) MSFPhoto *owner_photo;

@end
