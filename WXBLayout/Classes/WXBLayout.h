//
//  WXBLayout.h
//  WXBLayout
//
//  Created by WeiXinbing on 2021/9/28.
//

#import <UIKit/UIKit.h>

@class WXBConstraintMaker, WXBLayoutConstraint;

typedef WXBLayoutConstraint *(^WXBLayoutXAxisAnchor)(NSLayoutXAxisAnchor *anchor);
typedef WXBLayoutConstraint *(^WXBLayoutYAxisAnchor)(NSLayoutYAxisAnchor *anchor);
typedef WXBLayoutConstraint *(^WXBLayoutDimension)(NSLayoutDimension *anchor);

typedef WXBLayoutConstraint *(^WXBLayoutEqualTo)(id);
typedef WXBLayoutConstraint *(^WXBLayoutEqualSuper)(void);
typedef WXBLayoutConstraint *(^WXBLayoutConstant)(CGFloat);

typedef WXBLayoutConstraint *(^WXBLayoutPriority)(UILayoutPriority);
typedef WXBLayoutConstraint *(^WXBLayoutPriorityConst)(void);


@interface WXBLayoutConstraint : NSObject

+ (instancetype)newWithView:(UIView *)view;

@property (nonatomic, assign) NSLayoutAttribute type;
@property (nonatomic, strong) NSLayoutConstraint *layoutConstraint;

@property (nonatomic, copy, readonly) WXBLayoutEqualTo equalTo;
@property (nonatomic, copy, readonly) WXBLayoutEqualTo greaterThanOrEqualTo;
@property (nonatomic, copy, readonly) WXBLayoutEqualTo lessThanOrEqualTo;
@property (nonatomic, copy, readonly) WXBLayoutEqualSuper equalSuperView;

@property (nonatomic, copy, readonly) WXBLayoutConstant constant;
@property (nonatomic, copy, readonly) WXBLayoutConstant offset;

@property (nonatomic, copy, readonly) WXBLayoutPriorityConst priorityLow;
@property (nonatomic, copy, readonly) WXBLayoutPriorityConst priorityMedium;
@property (nonatomic, copy, readonly) WXBLayoutPriorityConst priorityHigh;
@property (nonatomic, copy, readonly) WXBLayoutPriority priorityValue;


@end

@interface WXBConstraintMaker : NSObject

+ (instancetype)newWithView:(UIView *)view;

@property (nonatomic, copy, readonly) WXBLayoutConstraint *leading;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *trailing;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *left;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *right;

@property (nonatomic, copy, readonly) WXBLayoutConstraint *top;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *bottom;

@property (nonatomic, copy, readonly) WXBLayoutConstraint *width;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *height;

@property (nonatomic, copy, readonly) WXBLayoutConstraint *centerX;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *centerY;

@property (nonatomic, copy, readonly) WXBLayoutConstraint *firstBaseline;
@property (nonatomic, copy, readonly) WXBLayoutConstraint *lastBaseline;

@end

@interface UIView (Layout_wxb)

- (void)wxb_layoutConstraints:(void(NS_NOESCAPE ^)(WXBConstraintMaker *m))handle;

@end


