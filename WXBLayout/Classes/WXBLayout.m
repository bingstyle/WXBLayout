//
//  WXBLayout.m
//  WXBLayout
//
//  Created by WeiXinbing on 2021/9/28.
//

#import "WXBLayout.h"

@interface WXBLayoutConstraint ()
@property (nonatomic, weak) UIView *view;
@end
@implementation WXBLayoutConstraint

- (void)dealloc {
    self.layoutConstraint.active = YES;
}

+ (instancetype)newWithView:(UIView *)view {
    WXBLayoutConstraint *obj = WXBLayoutConstraint.new;
    obj.view = view;
    return obj;
}

- (WXBLayoutPriorityConst)priorityLow {
    return ^WXBLayoutConstraint *() {
        self.layoutConstraint.priority = UILayoutPriorityDefaultLow;
        self.layoutConstraint.active = YES;
        return self;
    };
}
- (WXBLayoutPriorityConst)priorityMedium {
    return ^WXBLayoutConstraint *() {
        self.layoutConstraint.priority = UILayoutPriorityDefaultLow;
        return self;
    };
}
- (WXBLayoutPriorityConst)priorityHigh {
    return ^WXBLayoutConstraint *() {
        self.layoutConstraint.priority = UILayoutPriorityDefaultLow;
        return self;
    };
}
- (WXBLayoutPriority)priorityValue {
    return ^WXBLayoutConstraint *(UILayoutPriority priority) {
        self.layoutConstraint.priority = priority;
        return self;
    };
}

- (WXBLayoutEqualTo)equalTo {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    __block NSLayoutConstraint *layout;
    
    return ^WXBLayoutConstraint *(id value) {
        if ([value isKindOfClass:NSLayoutAnchor.class]) {
            layout = [anchor constraintEqualToAnchor:value];
        }
        else if ([value isKindOfClass:UIView.class]) {
            NSLayoutAnchor *viewAnchor = [self anchorForView:value type:self.type];
            layout = [anchor constraintEqualToAnchor:viewAnchor];
        }
        else if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *number = value;
            CGFloat constant = number.floatValue;
            
            if ([anchor isKindOfClass:NSLayoutDimension.class]) {
                layout = [(NSLayoutDimension *)anchor constraintEqualToConstant:constant];
            } else {
                NSLayoutAnchor *superAnchor = [self anchorForView:self.view.superview type:self.type];
                layout = [anchor constraintEqualToAnchor:superAnchor];
                layout.constant = constant;
            }
        }
        self.layoutConstraint = layout;
        return self;
    };

}

- (WXBLayoutEqualSuper)equalSuperView {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutAnchor *otherAnchor = [self anchorForView:_view.superview type:_type];
    NSLayoutConstraint *layout = [anchor constraintEqualToAnchor:otherAnchor];
    
    return ^WXBLayoutConstraint *() {
        self.layoutConstraint = layout;
        return self;
    };
}

- (WXBLayoutConstant)constant {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutAnchor *superAnchor = [self anchorForView:_view.superview type:_type];
    
    return ^WXBLayoutConstraint *(CGFloat constant) {
        if (self.layoutConstraint == nil) {
            self.layoutConstraint = [anchor constraintEqualToAnchor:superAnchor];
        }
        self.layoutConstraint.constant = constant;
        return self;
    };
}
- (WXBLayoutConstant)offset {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutAnchor *superAnchor = [self anchorForView:_view.superview type:_type];
    
    return ^WXBLayoutConstraint *(CGFloat constant) {
        if (self.layoutConstraint == nil) {
            self.layoutConstraint = [anchor constraintEqualToAnchor:superAnchor];
        }
        self.layoutConstraint.constant = constant;
        return self;
    };
}

- (NSLayoutAnchor *)anchorForView:(UIView *)view type:(NSLayoutAttribute)type {
    switch (type) {
        case NSLayoutAttributeLeading: return view.leadingAnchor;
        case NSLayoutAttributeTrailing: return view.trailingAnchor;
        case NSLayoutAttributeLeft: return view.leftAnchor;
        case NSLayoutAttributeRight: return view.rightAnchor;
            
        case NSLayoutAttributeTop: return view.topAnchor;
        case NSLayoutAttributeBottom: return view.bottomAnchor;
            
        case NSLayoutAttributeWidth: return view.widthAnchor;
        case NSLayoutAttributeHeight: return view.heightAnchor;
        case NSLayoutAttributeCenterX: return view.centerXAnchor;
        case NSLayoutAttributeCenterY: return view.centerYAnchor;
            
        case NSLayoutAttributeLastBaseline: return view.lastBaselineAnchor;
        case NSLayoutAttributeFirstBaseline: return view.firstBaselineAnchor;
            
        default: return nil;
    }
}

@end

@interface WXBConstraintMaker ()
@property (nonatomic, weak) UIView *view;
@end

@implementation WXBConstraintMaker

+ (instancetype)newWithView:(UIView *)view {
    WXBConstraintMaker *maker = WXBConstraintMaker.new;
    maker.view = view;
    return maker;
}

- (WXBLayoutConstraint *)getLayoutType:(NSLayoutAttribute)type {
    WXBLayoutConstraint *lc = [WXBLayoutConstraint newWithView:_view];
    lc.type = type;
    return lc;
}

- (WXBLayoutConstraint *)leading {
    return [self getLayoutType:NSLayoutAttributeLeading];
}
- (WXBLayoutConstraint *)trailing {
    return [self getLayoutType:NSLayoutAttributeTrailing];
}
- (WXBLayoutConstraint *)left {
    return [self getLayoutType:NSLayoutAttributeLeft];
}
- (WXBLayoutConstraint *)right {
    return [self getLayoutType:NSLayoutAttributeRight];
}

- (WXBLayoutConstraint *)top {
    return [self getLayoutType:NSLayoutAttributeTop];
}
- (WXBLayoutConstraint *)bottom {
    return [self getLayoutType:NSLayoutAttributeBottom];
}

- (WXBLayoutConstraint *)width {
    return [self getLayoutType:NSLayoutAttributeWidth];
}
- (WXBLayoutConstraint *)height {
    return [self getLayoutType:NSLayoutAttributeHeight];
}

- (WXBLayoutConstraint *)centerX {
    return [self getLayoutType:NSLayoutAttributeCenterX];
}
- (WXBLayoutConstraint *)centerY {
    return [self getLayoutType:NSLayoutAttributeCenterY];
}

@end

@implementation UIView (Layout_wxb)

- (void)wxb_layoutConstraints:(void (NS_NOESCAPE ^)(WXBConstraintMaker *))handle {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    WXBConstraintMaker *maker = [WXBConstraintMaker newWithView:self];
    if (handle) {
        handle(maker);
    }
}

@end
