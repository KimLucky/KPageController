//
//  KPageContainerView.m
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import "KPageContainerView.h"

#import <MJRefresh/UIScrollView+MJRefresh.h>
#import <MJRefresh/MJRefreshNormalHeader.h>

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface KPageContainerView () <UIScrollViewDelegate, KPageContentViewDelegate>

@property (nonatomic, strong) kScrollView *scrollView;

@property (nonatomic, assign) CGFloat stayHeight;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) KSegmentControl *segmentControl;
@property (nonatomic, assign) CGFloat segmentControlHeight;

@property (nonatomic, strong) KPageContentView *pageContentView;
@property (nonatomic, assign) CGFloat pageContentHeight;

@property (nonatomic, retain) NSMutableArray<UIScrollView *> *scrollArray;
@property (nonatomic, assign) BOOL scrollTag;
@property (nonatomic, assign) CGFloat lastDy;
@property (nonatomic, assign) BOOL nextReturn;

@property (nonatomic, weak) id<KPageViewDelegate> delegate;
@property (nonatomic, weak) id<KPageViewDataSource> dataSource;

@end

@implementation KPageContainerView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<KPageViewDelegate>)delegate dataSource:(id<KPageViewDataSource>)dataSource {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.dataSource = dataSource;

        [self setupUI];
    }
    return self;
}

#pragma mark -
- (void)setupUI {
    if (self.headerView) {
        self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerHeight);
    }

    self.segmentControl.frame = CGRectMake(0, self.headerHeight, self.bounds.size.width, self.segmentControlHeight);
    self.stayHeight = self.headerHeight;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.segmentControl];
    [self.scrollView addSubview:self.pageContentView];

    @weakify(self);
    self.segmentControl.didSelectedBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.pageContentView.currentPageAtIndex == index) {
            return;
        }
        self.pageContentView.currentPageAtIndex = index;
        if ([self.delegate respondsToSelector:@selector(pageContainerViewDidSelectedAt:)]) {
            [self.delegate pageContainerViewDidSelectedAt:index];
        }
    };
}

#pragma mark - ContentViewDelegate
- (void)pageContentViewScrollToIndex:(NSInteger)index {
    if (self.segmentControl.selectedIndex == index) {
        return;
    }
    self.segmentControl.selectedIndex = index;

    if ([self.delegate respondsToSelector:@selector(pageContainerViewDidSelectedAt:)]) {
        [self.delegate pageContainerViewDidSelectedAt:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL show = false;
    CGFloat dh = scrollView.contentOffset.y;
    if (dh >= self.stayHeight) {
        scrollView.contentOffset = CGPointMake(0, self.stayHeight);
        self.lastDy = scrollView.contentOffset.y;
        show = true;
    }
    UIScrollView *currenSubScrollView = nil;
    for (UIScrollView *sc in self.scrollArray) {
        if (sc.tag == self.pageContentView.currentPageAtIndex) {
            currenSubScrollView = sc; break;
        }
    }
    if (currenSubScrollView == nil) {
        return;
    }
    if (currenSubScrollView.contentOffset.y > 0 && (self.scrollView.contentOffset.y < self.stayHeight) && !self.scrollTag) {
        scrollView.contentOffset = CGPointMake(0, self.lastDy);
        show = true;
    }
    self.lastDy = scrollView.contentOffset.y;
    currenSubScrollView.showsVerticalScrollIndicator = show;
//    if (self.didScrollBlock) {
//        self.didScrollBlock(scrollView.contentOffset.y);
//    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        for (UIScrollView *sc in self.scrollArray) {
            [sc removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.nextReturn) {
            self.nextReturn = false;
            return;
        }
        CGFloat new = [change[@"new"] CGPointValue].y;
        CGFloat old = [change[@"old"] CGPointValue].y;
        if (new == old) {
            return;
        }
        CGFloat dh = new - old;
        if (dh < 0) {
            //向下
            if (((UIScrollView *)object).contentOffset.y < 0) {
                self.nextReturn = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, 0);
            }
            self.scrollTag = false;
        } else {
            //向上
            if (self.scrollView.contentOffset.y < self.stayHeight) {
                self.nextReturn = true;
                self.scrollTag = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
            } else {
                self.scrollTag = false;
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - set
#pragma mark - get
- (UIView *)headerView {
    if ([self.dataSource respondsToSelector:@selector(kPageViewHeader)]) {
        return [self.dataSource kPageViewHeader];
    }
    return nil;
}

- (CGFloat)headerHeight {
    if ([self.dataSource respondsToSelector:@selector(kPageViewHeaderHeight)]) {
        return [self.dataSource kPageViewHeaderHeight];
    }
    return 0;
}

- (KSegmentControl *)segmentControl {
    if ([self.dataSource respondsToSelector:@selector(kPageSegmentControl)]) {
        return [self.dataSource kPageSegmentControl];
    }
    return nil;
}

- (CGFloat)segmentControlHeight {
    if ([self.dataSource respondsToSelector:@selector(kPageSegmentControlHeight)]) {
        return [self.dataSource kPageSegmentControlHeight];
    }
    return 0;
}

- (CGFloat)pageContentHeight {
    if ([self.dataSource respondsToSelector:@selector(kPageControllerHeight)]) {
        return [self.dataSource kPageControllerHeight];
    }
    return 0;
}

- (kScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[kScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(0, self.frame.size.height + self.stayHeight);
        _scrollView.viewArray = self.scrollArray;

        _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSLog(@"xxxxxxx");
        }];
    }
    return _scrollView;
}

- (NSMutableArray<UIScrollView *> *)scrollArray {
    if (!_scrollArray) {
        _scrollArray = [NSMutableArray array];
    }
    return _scrollArray;
}

- (KPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSArray *dataViews = [self.dataSource kPageControllers];
        @weakify(self);
        id block = ^(UIScrollView *scrollView, NSInteger tag) {
            scrollView.tag = tag;
            @strongify(self);
            if (![self.scrollArray containsObject:scrollView]) {
                [self.scrollArray addObject:scrollView];
                [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            }
        };
        for (KPageBaseView *sv in dataViews) {
            sv.didAddScrollViewBlock = block;
        }
        _pageContentView = [[KPageContentView alloc] initWithFrame:CGRectMake(0, self.headerHeight + self.segmentControlHeight, self.bounds.size.width, self.pageContentHeight - self.segmentControlHeight)];
        _pageContentView.delegate = self;
        _pageContentView.dataViews = dataViews;
    }
    return _pageContentView;
}

@end

#pragma mark - kScrollView
@implementation kScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.viewArray containsObject:otherGestureRecognizer.view]) {
        return true;
    }
    return false;
}

@end
