/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxSwiftExt

/*:
## flatScan()

 Sometimes you need s kind of flatMap that reuse its previous element and accumulate it with the new element. For example a common pattern is to reuse the previous API response to prepare next request with current offset.
 */

struct ChunckedResource {
    let elements: [Int]
    let start: Int
    let totalCount: Int
    
    init(elements: [Int] = [], start: Int = 0, totalCount: Int = 0) {
        self.elements = elements
        self.start = start
        self.totalCount = totalCount
    }
    
    func merging(with other: ChunckedResource) -> ChunckedResource {
        guard other.start <= elements.count else {
            return self
        }
        return ChunckedResource(
            elements: elements[0..<other.start] + other.elements,
            start: start,
            totalCount: other.totalCount
        )
    }
}

example("flatScan") {
    func getContent(start: Int, count: Int) -> Single<ChunckedResource> {
        Single.just(
            ChunckedResource(
                elements: Array(start ..< min(20, start + count)),
                start: start,
                totalCount: 20
            )
        )
    }
    
    Observable.from(0...10)
        .flatScan(ChunckedResource()) { previous, _ in
            getContent(
                start: previous.elements.count,
                count: .random(in: 1...3)
            )
            .do(onSuccess: { print("+", $0)})
            .map(previous.merging)
        }
        .takeUntil(.inclusive) { $0.elements.count >= $0.totalCount }
        .subscribe(onNext: { print("=", $0, "\n") })
}

//: [Next](@next)
