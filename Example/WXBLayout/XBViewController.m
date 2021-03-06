//
//  XBViewController.m
//  WXBLayout
//
//  Created by bingstyle on 09/28/2021.
//  Copyright (c) 2021 bingstyle. All rights reserved.
//

#import "XBViewController.h"
#import <WXBLayout/WXBLayout.h>

@interface XBViewController ()
@property (nonatomic, strong) UIView *v1;
@property (nonatomic, strong) UIView *v2;
@property (nonatomic, strong) UIButton *v3;
@end

@implementation XBViewController
{
    NSLayoutConstraint *_v2LeftConstraint;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - Setup
- (void)setupUI {
    [self.view addSubview:self.v1];
    [self.view addSubview:self.v2];
    [self.view addSubview:self.v3];
    
    [_v1 wxb_layoutConstraints:^(WXBConstraintMaker *m) {
        m.centerY.equalSuperView();
        m.left.equalSuperView().offset(15);
        m.width.equalTo(@50);
        m.height.equalTo(@50);
    }];
    [_v2 wxb_layoutConstraints:^(WXBConstraintMaker *m) {
        m.centerY.equalSuperView();
        _v2LeftConstraint = m.left.equalTo(_v1.rightAnchor).constant(12).constraint;
        m.left.equalTo(@12).priorityLow();
        m.width.equalTo(@50);
        m.height.equalTo(@50);
    }];
    [_v3 wxb_layoutConstraints:^(WXBConstraintMaker *m) {
        m.centerY.equalSuperView();
        m.left.equalTo(_v2.rightAnchor).constant(12);
        m.left.equalTo(_v1.rightAnchor).offset(12).priorityValue(999);
        m.right.lessThanOrEqualTo(@-20);
        m.height.lessThanOrEqualTo(@30);
    }];
}

#pragma mark - Action

- (IBAction)redAction:(id)sender {
    _v1.hidden = !_v1.hidden;
    if (_v1.hidden) {
        [_v1 removeFromSuperview];
    } else {
        [self.view addSubview:_v1];
    }
}
- (IBAction)greenAction:(id)sender {
    _v2.hidden = !_v2.hidden;
    _v2LeftConstraint.active = !_v2.hidden;
}

- (IBAction)blueAciton:(UIButton *)sender {
//    _v3.hidden = !_v3.hidden;
    NSString *title = [_v3 titleForState:UIControlStateNormal];
    title = [title stringByAppendingString:@"V3"];
    [_v3 setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Private


#pragma mark - Getters and setters

- (UIView *)v1 {
    if (_v1 == nil) {
        _v1 = [UIView new];
        _v1.backgroundColor = UIColor.redColor;
    }
    return _v1;
}

- (UIView *)v2 {
    if (_v2 == nil) {
        _v2 = [UIView new];
        _v2.backgroundColor = UIColor.greenColor;
    }
    return _v2;
}

- (UIButton *)v3 {
    if (_v3 == nil) {
        _v3 = [UIButton buttonWithType:UIButtonTypeSystem];
        _v3.backgroundColor = UIColor.blueColor;
        [_v3 setTitle:@"v3" forState:UIControlStateNormal];
    }
    return _v3;
}



@end
