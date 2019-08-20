//
//  KPageBaseView.h
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPageBaseView : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^didAddScrollViewBlock)(UIScrollView *scrollView, NSInteger tag);

- (void)didAppeared;

@end
