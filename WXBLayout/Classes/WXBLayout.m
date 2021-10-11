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
    self.constraint.active = YES;
}

+ (instancetype)newWithView:(UIView *)view {
    WXBLayoutConstraint *obj = WXBLayoutConstraint.new;
    obj.view = view;
    return obj;
}

#pragma mark - Public
- (WXBLayoutEqualTo)equalTo {
    
    return ^WXBLayoutConstraint *(id value) {
        self.constraint = [self getLayoutWithObject:value relation:NSLayoutRelationEqual];
        return self;
    };
}
- (WXBLayoutEqualTo)greaterThanOrEqualTo {
    
    return ^WXBLayoutConstraint *(id value) {
        self.constraint = [self getLayoutWithObject:value relation:NSLayoutRelationGreaterThanOrEqual];
        return self;
    };
}
- (WXBLayoutEqualTo)lessThanOrEqualTo {
    
    return ^WXBLayoutConstraint *(id value) {
        self.constraint = [self getLayoutWithObject:value relation:NSLayoutRelationLessThanOrEqual];
        return self;
    };
}

- (WXBLayoutEqualSuper)equalSuperView {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutAnchor *otherAnchor = [self anchorForView:_view.superview type:_type];
    NSLayoutConstraint *constraint = [anchor constraintEqualToAnchor:otherAnchor];
    
    return ^WXBLayoutConstraint *() {
        self.constraint = constraint;
        return self;
    };
}

- (WXBLayoutConstant)constant {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutAnchor *superAnchor = [self anchorForView:_view.superview type:_type];
    
    return ^WXBLayoutConstraint *(CGFloat constant) {
        if (self.constraint == nil) {
            self.constraint = [anchor constraintEqualToAnchor:superAnchor];
        }
        self.constraint.constant = constant;
        return self;
    };
}
- (WXBLayoutConstant)offset {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutAnchor *superAnchor = [self anchorForView:_view.superview type:_type];
    
    return ^WXBLayoutConstraint *(CGFloat constant) {
        if (self.constraint == nil) {
            self.constraint = [anchor constraintEqualToAnchor:superAnchor];
        }
        self.constraint.constant = constant;
        return self;
    };
}

#pragma mark - Priority
- (WXBLayoutPriorityConst)priorityLow {
    return ^WXBLayoutConstraint *() {
        self.constraint.priority = UILayoutPriorityDefaultLow;
        return self;
    };
}
- (WXBLayoutPriorityConst)priorityMedium {
    return ^WXBLayoutConstraint *() {
        self.constraint.priority = UILayoutPriorityDefaultLow;
        return self;
    };
}
- (WXBLayoutPriorityConst)priorityHigh {
    return ^WXBLayoutConstraint *() {
        self.constraint.priority = UILayoutPriorityDefaultLow;
        return self;
    };
}
- (WXBLayoutPriority)priorityValue {
    return ^WXBLayoutConstraint *(UILayoutPriority priority) {
        self.constraint.priority = priority;
        return self;
    };
}

#pragma mark - Private

- (NSLayoutConstraint *)getLayoutWithAnchor:(NSLayoutAnchor *)anchor
                                   relation:(NSLayoutRelation)relation {
    
    NSLayoutAnchor *currentAnchor = [self anchorForView:_view type:_type];
    switch (relation) {
        case NSLayoutRelationEqual:
            return [currentAnchor constraintEqualToAnchor:anchor];
        case NSLayoutRelationGreaterThanOrEqual:
            return [currentAnchor constraintGreaterThanOrEqualToAnchor:anchor];
        case NSLayoutRelationLessThanOrEqual:
            return [currentAnchor constraintLessThanOrEqualToAnchor:anchor];
    }
}

- (NSLayoutConstraint *)getLayoutWithConstant:(CGFloat)constant
                                     relation:(NSLayoutRelation)relation {
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    switch (relation) {
        case NSLayoutRelationEqual:
            return [(NSLayoutDimension *)anchor constraintEqualToConstant:constant];
        case NSLayoutRelationGreaterThanOrEqual:
            return [(NSLayoutDimension *)anchor constraintGreaterThanOrEqualToConstant:constant];
        case NSLayoutRelationLessThanOrEqual:
            return [(NSLayoutDimension *)anchor constraintLessThanOrEqualToConstant:constant];
    }
}

- (NSLayoutConstraint *)getLayoutWithObject:(id)value
                                  relation:(NSLayoutRelation)relation {
    
    NSLayoutAnchor *anchor = [self anchorForView:_view type:_type];
    NSLayoutConstraint *layout;
    
    if ([value isKindOfClass:NSLayoutAnchor.class]) {
        layout = [self getLayoutWithAnchor:value relation:relation];
    }
    else if ([value isKindOfClass:UIView.class]) {
        NSLayoutAnchor *viewAnchor = [self anchorForView:value type:self.type];
        layout = [self getLayoutWithAnchor:viewAnchor relation:relation];
    }
    else if ([value isKindOfClass:NSNumber.class]) {
        NSNumber *number = value;
        CGFloat constant = number.floatValue;
        
        if ([anchor isKindOfClass:NSLayoutDimension.class]) {
            layout = [self getLayoutWithConstant:constant relation:relation];
        } else {
            NSLayoutAnchor *superAnchor = [self anchorForView:self.view.superview type:self.type];
            layout = [self getLayoutWithAnchor:superAnchor relation:relation];
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
