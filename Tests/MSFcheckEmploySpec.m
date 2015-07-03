//
//  MSFcheckEmploy.m
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "MSFCheckEmployee.h"

QuickSpecBegin(MSFcheckEmploySpec
               )
__block MSFCheckEmployee* adver1;
beforeEach(^{
  NSURL* URL=[[NSBundle bundleForClass:self.class] URLForResource:@"checkemployee" withExtension:@"json"];
  expect(URL).notTo(beNil());
  NSData* data=[NSData dataWithContentsOfURL:URL];
  NSDictionary* representation=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
  //adver=[MTLJSONAdapter modelOfClass:MSFAdver.class fromJSONDictionary:representation error:nil];
  adver1=[MTLJSONAdapter modelOfClass:MSFCheckEmployee.class fromJSONDictionary:representation error:nil];
 
});
it(@"should has adID",^{
  
});
QuickSpecEnd