//
//  KPageBaseView.m
//  VT
//
//  Created by YTX-Kim on 2019/7/29.
//  Copyright © 2019 YTX-Kim. All rights reserved.
//

#import "KPageBaseView.h"

@interface KPageBaseView ()

@end

@implementation KPageBaseView

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    if ([subview isKindOfClass:[UIScrollView class]]) {
        if (self.didAddScrollViewBlock) {
            self.didAddScrollViewBlock((UIScrollView *)subview, self.index);
        }
    } else {
        for (UIView *sview in [subview subviews]) {
            if ([sview isKindOfClass:[UIScrollView class]]) {
                if (self.didAddScrollViewBlock) {
                    self.didAddScrollViewBlock((UIScrollView *)sview, self.index);
                }
            }
        }
    }
}

- (void)didAppeared {
}

@end
