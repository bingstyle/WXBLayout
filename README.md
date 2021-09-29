# WXBLayout

[![Build](https://github.com/bingstyle/WXBLayout/actions/workflows/ci.yml/badge.svg)](https://github.com/bingstyle/WXBLayout/actions/workflows/ci.yml)
[![Version](https://img.shields.io/cocoapods/v/WXBLayout.svg?style=flat)](https://cocoapods.org/pods/WXBLayout)
[![License](https://img.shields.io/cocoapods/l/WXBLayout.svg?style=flat)](https://cocoapods.org/pods/WXBLayout)
[![Platform](https://img.shields.io/cocoapods/p/WXBLayout.svg?style=flat)](https://cocoapods.org/pods/WXBLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

`#import <WXBLayout/WXBLayout.h>`

```objc
[_v1 wxb_layoutConstraints:^(WXBConstraintMaker *m) {
    m.centerY.equalSuperView();
    m.left.equalSuperView().offset(15);
    m.width.equalTo(@50);
    m.height.equalTo(@50);
}];
[_v2 wxb_layoutConstraints:^(WXBConstraintMaker *m) {
    m.centerY.equalSuperView();
    _layoutLeft_v2 = m.left.equalTo(_v1.rightAnchor).constant(12).layoutConstraint;
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
```

## Requirements

- iOS 9.0+
- Xcode 9.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```ruby
$ gem install cocoapods
```

To install it, simply add the following line to your Podfile:

```ruby
pod 'WXBLayout'
```

### Manually

If you prefer not to use the aforementioned dependency managers, you can integrate WXBLayout into your project manually.

## Author

bingstyle, 183292352@qq.com

## License

WXBLayout is available under the MIT license. See the LICENSE file for more info.
