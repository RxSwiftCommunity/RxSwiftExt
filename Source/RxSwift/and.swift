//
//  and.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 26/11/17
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//
import Foundation
import RxSwift

extension ObservableType where E == Bool {
	/**
	Emits a single Bool value indicating whether or not a Bool sequence emits only `true` values.

	If a `false` value is emitted, the resulting sequence immediately completes with a `false` result.
	If only `true` values are emitted, the resulting sequence completes with a `true` result once the
	source sequence completes.
	If no value is emitted, the resulting sequence completes with no value once the source sequence completes.

	Use `asSingle()` or `asObservable()` to convert to your requirements.
	*/
	public func and() -> Maybe<E> {
		return Maybe.create { observer in
			var gotValue = false
			return self.subscribe { event in
				switch event {
				case .next(let value):
					if !value {
						// first `false` value emits false & completes
						observer(.success(false))
					} else {
						gotValue = true
					}
				case .error(let error):
					observer(.error(error))
				case .completed:
					observer(gotValue ? .success(true) : .completed)
				}
			}
		}
	}

	/**
	Emits a single Bool value indicating whether or not a each Bool sequence in the collection emits only `true` values.

	Each sequence of the collection is expected to emit at least one `true` value.
	If any sequence does not emit anything, the produced `Maybe` will just complete.
	If any sequence emits a `false` value, the produiced `Maybe` will emit a `false` result.
	If all sequences emit at least one `true` value, the produced `Maybe` will emit a `true` result.

	Use `asSingle()` or `asObservable()` to convert to your requirements.
	*/
	public static func and<C: Collection>(_ collection: C) -> Maybe<E> where C.Element: ObservableType, C.Element.E == E {
		return Maybe.create { observer in
			var emitted = [Bool](repeating: false, count: Int(collection.count))
			var completed = 0
			let lock = NSRecursiveLock()
			lock.lock()
			defer { lock.unlock() }
			let subscriptions = collection.enumerated().map { item in
				item.element.subscribe { event in
					lock.lock()
					defer { lock.unlock() }
					switch event {
					case .next(let value):
						if !value {
							// first `false` value emits false & completes
							observer(.success(false))
						} else {
							emitted[item.offset] = true
						}
					case .error(let error):
						observer(.error(error))
					case .completed:
						completed += 1
						guard completed == collection.count else { return }
						// if all emitted at least one `true`, emit true otherwise just complete
						if emitted.reduce(true, { $0 && $1 }) {
							observer(.success(true))
						} else {
							observer(.completed)
						}
					}

				}
			}
			return CompositeDisposable(disposables: subscriptions)
		}
	}

	/**
	Emits a single Bool value indicating whether or not a each Bool sequence in the collection emits only `true` values.

	Each sequence of the collection is expected to emit at least one `true` value.
	If any sequence does not emit anything, the produced `Maybe` will just complete.
	If any sequence emits a `false` value, the produiced `Maybe` will emit a `false` result.
	If all sequences emit at least one `true` value, the produced `Maybe` will emit a `true` result.

	Use `asSingle()` or `asObservable()` to convert to your requirements.
	*/
	public static func and<O: ObservableType>(_ sources: O ...) -> Maybe<E> where O.E == E {
		return and(sources)
	}
}
