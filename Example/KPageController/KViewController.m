//
//  KViewController.m
//  KPageViewController
//
//  Created by KimLucky on 08/20/2019.
//  Copyright (c) 2019 KimLucky. All rights reserved.
//

#import "KViewController.h"

#import <KSegmentControl/KSegmentControl.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kTopBarHeight 64

@interface KViewController ()

@property (nonatomic, strong) KSegmentControl *segmentControl;

@property (nonatomic, strong) NSArray *pageViews;

@end

@implementation KViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void)pageControllerDidSelectedAt:(NSInteger)index {
    NSLog(@"vc = %@", self.pageViews[index]);
}

#pragma mark - datasource
- (CGFloat)pageViewControllerHeaderHeight {
    return 300;
}

- (UIView *)pageViewControllerHeader {
    return [UIView new];
}

- (KSegmentControl *)pageSegmentControl {
    return self.segmentControl;
}

- (CGFloat)pageSegmentControlHeight {
    return 40;
}

- (NSArray<UIView *> *)pageViewControllers {
    return self.pageViews;
}

- (CGFloat)pageViewControllerHeight {
    return kHeight - kTopBarHeight;
}

#pragma mark - Constraints

#pragma mark - get

- (KSegmentControl *)segmentControl {
    if (!_segmentControl) {
        KControlParameters *parameters = [KControlParameters new];
        parameters.separatorDisplay = YES;
        _segmentControl = [KSegmentControl segmentControlWith:parameters titles:@[@"vc1", @"vc2"]];
        _segmentControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
        _segmentControl.backgroundColor = [UIColor whiteColor];
    }
    return _segmentControl;
}

- (NSArray *)pageViews {
    if (!_pageViews) {
        KPageBaseView *vc1 = [KPageBaseView new];
        vc1.backgroundColor = [UIColor redColor];
        
        KPageBaseView *vc2 = [KPageBaseView new];
        vc2.backgroundColor = [UIColor greenColor];
        
        _pageViews = @[vc1, vc2];
    }
    return _pageViews;
}

@end
