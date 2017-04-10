Changelog
=========

2.3.0
-----
- removed `materialize` and `dematerialize` operators as they now are part of RxSwift 3.4.0 and later

2.2.1
-----
- fixed compilation warning with Swift 3.1

2.2.0
-----
- new operator: `apply`
- added `not`, `mapTo` and `distinct` support for RxCocoa units (`Driver` et al.)

2.1.0
-----
- new operators: `materialize` / `dematerialize`
- extract Playground to use Carthage instead of CocoaPods

2.0.0
-----
- Support Swift 3.0 / RxSwift 3.0

1.2
-----
- new operator: `pausable`
- Tweaked `Podfile` to fix an issue with running the demo playground

1.1
-----
- new operator: `retry` with four different behaviors
- new operator: `catchErrorJustComplete`
- new operator: `ignoreErrors`

1.0.1
-----
- new operator: `distinct` with predicate
- updated to CocoaPods 1.0

1.0
-----
- Initial release.
