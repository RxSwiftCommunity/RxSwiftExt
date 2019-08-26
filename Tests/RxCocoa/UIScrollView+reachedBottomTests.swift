//
//  UIScrollView+reachedBottomTests.swift
//  RxSwiftExt
//
//  Created by Anton Nazarov on 09/05/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

#if canImport(UIKit)
import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxSwiftExt

final class UIScrollViewReachedBottomTests: XCTestCase {
    private var tableView: UITableView!
    private var dataSource: StubDataSource!
    private var scheduler: TestScheduler!
    private var observer: TestableObserver<Void>!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        dataSource = StubDataSource()
        tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.rowHeight = 44
        tableView.reloadData()
        scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(Void.self)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        dataSource = nil
        tableView = nil
        scheduler = nil
        observer = nil
        super.tearDown()
    }

    func testReachedBottomNotEmitsIfNotScrolledToBottom() {
        // Given
        let almostBottomY = CGFloat(dataSource.cellsCount) * tableView.rowHeight - 1
        tableView.rx.reachedBottom().bind(to: observer).disposed(by: disposeBag)
        // When
        tableView.contentOffset = CGPoint(x: 0, y: almostBottomY)
        // Then
        XCTAssertTrue(observer.events.isEmpty)
    }

    func testReachedBottomNotEmitsIfNotScrolledToBottomWithNonZeroOffset() {
        // Given
        let offset: CGFloat = 40.0
        let almostBottomY = CGFloat(dataSource.cellsCount) * tableView.rowHeight - offset - 1
        tableView.rx.reachedBottom(offset: offset).bind(to: observer).disposed(by: disposeBag)
        // When
        tableView.contentOffset = CGPoint(x: 0, y: almostBottomY)
        // Then
        XCTAssertTrue(observer.events.isEmpty)
    }

    func testReachedBottomEmitsIfScrolledToBottom() {
        // Given
        let actual: [Recorded<Event<Void>>] = [.next(0, ())]
        let bottomY = CGFloat(dataSource.cellsCount) * tableView.rowHeight
        tableView.rx.reachedBottom().bind(to: observer).disposed(by: disposeBag)
        // When
        tableView.contentOffset = CGPoint(x: 0, y: bottomY)
        // Then
        XCTAssertEqual(actual.count, observer.events.count)
    }
}

private extension UIScrollViewReachedBottomTests {
    final class StubDataSource: NSObject, UITableViewDataSource {
        let cellsCount = 28

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cellsCount
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
#endif
