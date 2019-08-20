//
//  KPageViewController.m
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import "KPageViewController.h"

@interface KPageViewController () <KPageViewDelegate, KPageViewDataSource>

@property (nonatomic, strong) KPageContainerView *pageView;

@end

@implementation KPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.delegate = self;
    self.dataSource = self;

    [self.view addSubview:self.pageView];
}

#pragma mark - setupUI
- (void)reloadData {
}

#pragma mark - delegate
- (void)pageContainerViewDidSelectedAt:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pageControllerDidSelectedAt:)]) {
        [self.delegate pageControllerDidSelectedAt:index];
    }
}

#pragma mark - datasource
- (CGFloat)kPageControllerTop {
    if ([self.dataSource respondsToSelector:@selector(pageControllerTop)]) {
        return [self.dataSource pageControllerTop];
    }
    return 0;
}
- (CGFloat)kPageControllerHeight {
    if ([self.dataSource respondsToSelector:@selector(pageViewControllerHeight)]) {
        return [self.dataSource pageViewControllerHeight];
    }
    return 0;
}

- (NSArray<KPageBaseView *> *)kPageControllers {
    if ([self.dataSource respondsToSelector:@selector(pageViewControllers)]) {
        return [self.dataSource pageViewControllers];
    }
    return nil;
}

- (CGFloat)kPageViewHeaderHeight {
    if ([self.dataSource respondsToSelector:@selector(pageViewControllerHeaderHeight)]) {
        return [self.dataSource pageViewControllerHeaderHeight];
    }
    return 0;
}

- (UIView *)kPageViewHeader {
    if ([self.dataSource respondsToSelector:@selector(pageViewControllerHeader)]) {
        return [self.dataSource pageViewControllerHeader];
    }
    return nil;
}

- (KSegmentControl *)kPageSegmentControl {
    if ([self.dataSource respondsToSelector:@selector(pageSegmentControl)]) {
        return [self.dataSource pageSegmentControl];
    }
    return nil;
}

- (CGFloat)kPageSegmentControlHeight {
    if ([self.dataSource respondsToSelector:@selector(pageSegmentControlHeight)]) {
        return [self.dataSource pageSegmentControlHeight];
    }
    return 0;
}

#pragma mark - get
- (KPageContainerView *)pageView {
    if (!_pageView) {
        _pageView = [[KPageContainerView alloc] initWithFrame:CGRectMake(0, self.kPageControllerTop, [UIScreen mainScreen].bounds.size.width, self.kPageControllerHeight) delegate:self dataSource:self];
    }
    return _pageView;
}

@end
