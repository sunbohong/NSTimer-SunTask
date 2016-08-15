# NSTimer-SunTask

[![CI Status](http://img.shields.io/travis/sunbohong/NSTimer-SunTask.svg?style=flat)](https://travis-ci.org/sunbohong/NSTimer-SunTask)
[![Version](https://img.shields.io/cocoapods/v/NSTimer-SunTask.svg?style=flat)](http://cocoapods.org/pods/NSTimer-SunTask)
[![License](https://img.shields.io/cocoapods/l/NSTimer-SunTask.svg?style=flat)](http://cocoapods.org/pods/NSTimer-SunTask)
[![Platform](https://img.shields.io/cocoapods/p/NSTimer-SunTask.svg?style=flat)](http://cocoapods.org/pods/NSTimer-SunTask)

## Demo说明
为了说明，本扩展没有导致内存泄漏，特地添加了`FBMemoryProfiler`进行展示。

运行 Demo 后，通过双指单击视图，可以初始化`NSTimer`并显示相关的视图，您可以在此基础上进行相关的操作。

通过点击展示内存占用的视图，您可以查看是否有循环引用产生。

> 请注意：
     在 ARC 下面，因为 UITouch 实例会强引用 UIView。导致 UIView 延迟释放。本 demo 已经修改为MRR 环境进行展示。
     您可以通过反注释源文件中与 subview 的代码，并修改为 ARC 环境来展示与该问题。


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NSTimer-SunTask is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NSTimer-SunTask"
```

## Author

sunbohong, sunbohong@gmail.com

## License

NSTimer-SunTask is available under the MIT license. See the LICENSE file for more info.
