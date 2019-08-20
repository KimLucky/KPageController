//
//  KPageContainerView.h
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KPageContentView.h"

#import <KSegmentControl/KSegmentControl.h>

@protocol KPageViewDelegate <NSObject>

- (void)pageContainerViewDidSelectedAt:(NSInteger)index;

@end

@protocol KPageViewDataSource <NSObject>

- (UIView *)kPageViewHeader;
- (CGFloat)kPageViewHeaderHeight;

@required
- (KSegmentControl *)kPageSegmentControl;
- (CGFloat)kPageSegmentControlHeight;

- (NSArray<KPageBaseView *> *)kPageControllers;
- (CGFloat)kPageControllerHeight;

@end

@interface KPageContainerView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<KPageViewDelegate>)delegate dataSource:(id<KPageViewDataSource>)dataSource;

@end

@interface kScrollView : UIScrollView

@property (nonatomic, weak) NSArray *viewArray;

@end
