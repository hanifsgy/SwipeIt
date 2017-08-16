# RxLegacy

[![Version](https://img.shields.io/cocoapods/v/RxLegacy.svg?style=flat)](http://cocoapods.org/pods/RxLegacy)
[![License](https://img.shields.io/cocoapods/l/RxLegacy.svg?style=flat)](http://cocoapods.org/pods/RxLegacy)
[![Platform](https://img.shields.io/cocoapods/p/RxLegacy.svg?style=flat)](http://cocoapods.org/pods/RxLegacy)

RxLegacy is a bunch of legacy functions from RxSwift for easier block completion.
Includes doOnNext, doOnCompleted, doOnSubscribe, doOnError, doOnDispose,
subscribeNext, subscribeError, subscribeCompleted, subscribeDispose and mapVoid.
Also include a sub-dependency for Result related calls such as, subscribeSucccess,
subscribeFailure, doOnFailure and doOnSucccess.

## Example

```swift
let observable = Observable.just("hello")

observable
  .doOnNext { print($0) }
  .doOnError { print("error: \($0)") }
  .addDisposableTo(disposeBag)
```

## Installation

RxLegacy is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RxLegacy"
```

or

```ruby
pod "RxLegacy/RxResult"
```

## Author

ivanbruel, ivan.bruel@gmail.com

## License

RxLegacy is available under the MIT license. See the LICENSE file for more info.
