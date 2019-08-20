//
//  KPageViewController.h
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KPageContainerView.h"

@protocol KPageViewControllerDelegate <NSObject>

@optional
- (void)pageControllerDidSelectedAt:(NSInteger)index;

@end

@protocol KPageViewControllerDataSource <NSObject>

@optional
//header
- (UIView *)pageViewControllerHeader;
- (CGFloat)pageViewControllerHeaderHeight;

//segment
- (KSegmentControl *)pageSegmentControl;
- (CGFloat)pageSegmentControlHeight;

//page
- (CGFloat)pageControllerTop;
- (NSArray<KPageBaseView *> *)pageViewControllers;
- (CGFloat)pageViewControllerHeight;
@end

@interface KPageViewController : UIViewController <KPageViewControllerDelegate, KPageViewControllerDataSource>

@property (nonatomic, weak) id<KPageViewControllerDelegate> delegate;
@property (nonatomic, weak) id<KPageViewControllerDataSource> dataSource;

- (void)reloadData;
@end
