//
//  flatScan.swift
//  RxSwiftExt
//
//  Created by Jérôme Alves (Datadog) on 09/10/2020.
//  Copyright © 2020 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where Element == Void {

    /// Projects each element of an observable sequence to an accumulating observable sequence and merges the resulting observable sequences into one observable sequence.
    /// The specified seed value is used as the initial accumulator value.
    public func flatScan<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping (Source.Element) throws -> Source
    ) -> Observable<Source.Element> {
        flatScan(seed) { seed, _ in try accumulator(seed) }
    }

    /// Projects each element of an observable sequence to an accumulating observable sequence and merges the resulting observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// The specified seed value is used as the initial accumulator value.
    public func flatScanFirst<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping (Source.Element) throws -> Source
    ) -> Observable<Source.Element> {
        flatScanFirst(seed) { seed, _ in try accumulator(seed) }
    }

    /// Projects each element of an observable sequence to an accumulating observable sequence and merges the resulting observable sequences into one observable sequence.
    /// If there is some projected observable sequence being merged when element is received it will be cancelled in favor of the new observable sequence.
    /// The specified seed value is used as the initial accumulator value.
    public func flatScanLatest<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping (Source.Element) throws -> Source
    ) -> Observable<Source.Element> {
        flatScanLatest(seed) { seed, _ in try accumulator(seed) }
    }
}

extension ObservableType {
    public typealias FlatScanAccumulator<Source: ObservableConvertibleType> = (
        Source.Element, Element
    ) throws -> Source

    public typealias AnyFlatMap<Source: ObservableConvertibleType> = (
        _ source: Observable<(Element, Source.Element)>,
        _ selector: @escaping (Element, Source.Element) throws -> Source
    ) -> Observable<Source.Element>

    /// Projects each element of an observable sequence to an accumulating observable sequence and merges the resulting observable sequences into one observable sequence.
    /// The specified seed value is used as the initial accumulator value.
    public func flatScan<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping FlatScanAccumulator<Source>
    ) -> Observable<Source.Element> {
        _flatScan(seed, accumulator: accumulator, using: { $0.flatMap($1) })
    }

    /// Projects each element of an observable sequence to an accumulating observable sequence and merges the resulting observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// The specified seed value is used as the initial accumulator value.
    public func flatScanFirst<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping FlatScanAccumulator<Source>
    ) -> Observable<Source.Element> {
        _flatScan(seed, accumulator: accumulator, using: { $0.flatMapFirst($1) })
    }

    /// Projects each element of an observable sequence to an accumulating observable sequence and merges the resulting observable sequences into one observable sequence.
    /// If there is some projected observable sequence being merged when element is received it will be cancelled in favor of the new observable sequence.
    /// The specified seed value is used as the initial accumulator value.
    public func flatScanLatest<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping FlatScanAccumulator<Source>
    ) -> Observable<Source.Element> {
        _flatScan(seed, accumulator: accumulator, using: { $0.flatMapLatest($1) })
    }

    private func _flatScan<Source: ObservableConvertibleType>(
        _ seed: Source.Element,
        accumulator: @escaping FlatScanAccumulator<Source>,
        using flatMap: @escaping AnyFlatMap<Source>
    ) -> Observable<Source.Element> {
        Observable<Source.Element>.using({ FlatScanResource(seed: seed) }, observableFactory: { resource -> Observable<Source.Element> in
                let latest = self.withLatestFrom(resource.asObservable(), resultSelector: { ($0, $1) })
                return flatMap(latest) { element, resource in
                    try accumulator(resource, element)
                }.do(onNext: resource.accept)
            }
        )
    }
}

private final class FlatScanResource<A>: Disposable, ObservableConvertibleType {
    private let subject: BehaviorSubject<A>

    init(seed: A) {
        self.subject = BehaviorSubject(value: seed)
    }

    func accept(_ value: A) {
        subject.onNext(value)
    }

    func asObservable() -> Observable<A> {
        subject.asObservable()
    }

    func dispose() {
        subject.onCompleted()
    }

    deinit {
        dispose()
    }
}
