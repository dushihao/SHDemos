//
//  SHConst.h
//  SHDemoTest
//
//  Created by hsadmin on 2018/9/10.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#ifndef SHConst_h
#define SHConst_h


#define MAIN_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define MAIN_SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)

#define HsColorWithHexStr(hexstr)   [HsConfigration uiColorFromString:hexstr]
#define FONT(size)          [HsConfigration systemFontOfSize:size]
#endif /* SHConst_h */
