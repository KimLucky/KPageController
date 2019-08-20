//
//  KPageContentView.h
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KPageBaseView.h"

@protocol KPageContentViewDelegate <NSObject>

- (void)pageContentViewScrollToIndex:(NSInteger)index;

@end

@interface KPageContentView : UIView

@property (nonatomic, strong) UIView *currentView;

@property (nonatomic, assign) NSInteger currentPageAtIndex;
@property (nonatomic, copy) NSArray<KPageBaseView *> *dataViews;

@property (nonatomic, weak) id<KPageContentViewDelegate> delegate;

@end
