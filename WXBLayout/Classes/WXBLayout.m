//
//  WXBLayout.m
//  WXBLayout
//
//  Created by WeiXinbing on 2021/9/28.
//

#import "WXBLayout.h"

typedef NS_ENUM(NSUInteger, WXBEqualToType) {
    WXBEqualToTypeDefault,
    WXBEqualToTypeGreater,
    WXBEqualToTypeLess,
};

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

#pragma mark - Public
- (WXBLayoutEqualTo)equalTo {
    
    return ^WXBLayoutConstraint *(id value) {
        self.layoutConstraint = [self getLayoutWithObject:value equalType:WXBEqualToTypeDefault];
        return self;
    };
}
- (WXBLayoutEqualTo)greaterThanOrEqualTo {
    
    return ^WXBLayoutConstraint *(id value) {
        self.layoutConstraint = [self getLayoutWithObject:value equalType:WXBEqualToTypeGreater];
        return self;
    };
}
- (WXBLayoutEqualTo)lessThanOrEqualTo {
    
    return ^WXBLayoutConstraint *(id value) {
        self.layoutConstraint = [self getLayoutWithObject:value equalType:WXBEqualToTypeLess];
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

#pragma mark - Priority
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

#pragma mark - Private

- (NSLayoutConstraint *)getLayoutWithAnchor:(NSLayoutAnchor *)anchor
                                equalType:(WXBEqualToType)equalType {
    
    NSLayoutAnchor *currentAnchor = [self anchorForView:_view type:_type];
    switch (equalType) {
        case WXBEqualToTypeDefault:
            return [currentAnchor constraintEqualToAnchor:anchor];
        case WXBEqualToTypeGreater:
            return [currentAnchor constraintGreaterThanOrEqualToAnchor:anchor];
        case WXBEqualToTypeLess:
            return [currentAnchor constraintLessThanOrEqualToAnchor:anchor];
    }
}

- (NSLayoutConstraint *)getLayoutWithConstant:(CGFloat)constant
                                    equalType:(WXBEqualToType)equalType {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    switch (equalType) {
        case WXBEqualToTypeDefault:
            return [(NSLayoutDimension *)anchor constraintEqualToConstant:constant];
        case WXBEqualToTypeGreater:
            return [(NSLayoutDimension *)anchor constraintGreaterThanOrEqualToConstant:constant];
        case WXBEqualToTypeLess:
            return [(NSLayoutDimension *)anchor constraintLessThanOrEqualToConstant:constant];
    }
}

- (NSLayoutConstraint *)getLayoutWithObject:(id)value
                                  equalType:(WXBEqualToType)equalType {
    
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutConstraint *layout;
    
    if ([value isKindOfClass:NSLayoutAnchor.class]) {
        layout = [self getLayoutWithAnchor:value equalType:equalType];
    }
    else if ([value isKindOfClass:UIView.class]) {
        NSLayoutAnchor *viewAnchor = [self anchorForView:value type:self.type];
        layout = [self getLayoutWithAnchor:viewAnchor equalType:equalType];
    }
    else if ([value isKindOfClass:NSNumber.class]) {
        NSNumber *number = value;
        CGFloat constant = number.floatValue;
        
        if ([anchor isKindOfClass:NSLayoutDimension.class]) {
            layout = [self getLayoutWithConstant:constant equalType:equalType];
        } else {
            NSLayoutAnchor *superAnchor = [self anchorForView:self.view.superview type:self.type];
            layout = [self getLayoutWithAnchor:superAnchor equalType:equalType];
            layout.constant = constant;
        }
    }
    return layout;
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
            
        case NSLayoutAttributeFirstBaseline: return view.firstBaselineAnchor;
        case NSLayoutAttributeLastBaseline: return view.lastBaselineAnchor;
            
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

- (WXBLayoutConstraint *)firstBaseline {
    return [self getLayoutType:NSLayoutAttributeFirstBaseline];
}
- (WXBLayoutConstraint *)lastBaseline {
    return [self getLayoutType:NSLayoutAttributeLastBaseline];
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
