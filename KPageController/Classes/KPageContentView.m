//
//  KPageContentView.m
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import "KPageContentView.h"

@interface KPageContentView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation KPageContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self dealWithScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self dealWithScroll];
}

- (void)dealWithScroll {
    _currentPageAtIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;

    KPageBaseView *view = [self.dataViews objectAtIndex:_currentPageAtIndex];
    [view didAppeared];

    if ([self.delegate respondsToSelector:@selector(pageContentViewScrollToIndex:)]) {
        [self.delegate pageContentViewScrollToIndex:_currentPageAtIndex];
    }
}

#pragma mark - set
- (void)setCurrentPageAtIndex:(NSInteger)currentPageAtIndex {
    if (_currentPageAtIndex == currentPageAtIndex) {
        return;
    }
    _currentPageAtIndex = currentPageAtIndex;

    [self.scrollView setContentOffset:CGPointMake(currentPageAtIndex * self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:true];
}

- (void)setDataViews:(NSArray<KPageBaseView *> *)dataViews {
    _dataViews = dataViews;

    for (int i = 0; i < dataViews.count; i++) {
        KPageBaseView *view = dataViews[i];
        view.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:view];
        view.index = i;

        if (i == 0) {
            [view didAppeared];
        }
    }
    self.scrollView.contentSize = CGSizeMake(dataViews.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

#pragma mark - get
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = true;
        _scrollView.directionalLockEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
