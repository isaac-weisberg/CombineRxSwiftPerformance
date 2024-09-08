//
//  RxSwiftTests.swift
//  SpeedTestTests
//
//  Created by Stefan Kofler on 02.08.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import RxSwiftAwait
import XCTest

class RxSwiftAwaitTests: XCTestCase {
    func testPublishSubjectPumping() async {
        await measureA {
            var sum = 0
            let subject = PublishSubject<Int>()

            let subscription = await subject
                .subscribe(onNext: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                await subject.on(.next(1))
            }

            await subscription.dispose()

            XCTAssertEqual(sum, iterations * 100)
        }
    }

    func testPublishSubjectPumpingTwoSubscriptions() async {
        await measureA {
            var sum = 0
            let subject = PublishSubject<Int>()

            let subscription1 = await subject
                .subscribe(onNext: { x in
                    sum += x
                })

            let subscription2 = await subject
                .subscribe(onNext: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                await subject.on(.next(1))
            }

            await subscription1.dispose()
            await subscription2.dispose()

            XCTAssertEqual(sum, iterations * 100 * 2)
        }
    }

    func testPublishSubjectCreating() async {
        await measureA {
            var sum = 0

            for _ in 0 ..< iterations * 10 {
                let subject = PublishSubject<Int>()

                let subscription = await subject
                    .subscribe(onNext: { x in
                        sum += x
                    })

                for _ in 0 ..< 1 {
                    await subject.on(.next(1))
                }

                await subscription.dispose()
            }

            XCTAssertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterPumping() async {
        await measureA {
            var sum = 0

            let subscription = await Observable<Int>
                .create { observer in
                    for _ in 0 ..< iterations * 10 {
                        await observer.on(.next(1))
                    }
                    return Disposables.create()
                }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .subscribe(onNext: { x in
                    sum += x
                })

            await subscription.dispose()

            XCTAssertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterCreating() async {
        await measureA {
            var sum = 0

            for _ in 0 ..< iterations {
                let subscription = await Observable<Int>
                    .create { observer in
                        for _ in 0 ..< 1 {
                            await observer.on(.next(1))
                        }
                        return Disposables.create()
                    }
                    .map { $0 }.filter { _ in true }
                    .map { $0 }.filter { _ in true }
                    .map { $0 }.filter { _ in true }
                    .map { $0 }.filter { _ in true }
                    .map { $0 }.filter { _ in true }
                    .map { $0 }.filter { _ in true }
                    .subscribe(onNext: { x in
                        sum += x
                    })

                await subscription.dispose()
            }

            XCTAssertEqual(sum, iterations)
        }
    }

    func testFlatMapsPumping() async {
        await measureA {
            var sum = 0
            let subscription = await Observable<Int>
                .create { observer in
                    for _ in 0 ..< iterations * 10 {
                        await observer.on(.next(1))
                    }
                    return Disposables.create()
                }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .subscribe(onNext: { x in
                    sum += x
                })

            await subscription.dispose()

            XCTAssertEqual(sum, iterations * 10)
        }
    }

    func testFlatMapsCreating() async {
        await measureA {
            var sum = 0
            for _ in 0 ..< iterations {
                let subscription = await Observable<Int>.create { observer in
                    for _ in 0 ..< 1 {
                        await observer.on(.next(1))
                    }
                    return Disposables.create()
                }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .flatMap { x in Observable.just(x) }
                .subscribe(onNext: { x in
                    sum += x
                })

                await subscription.dispose()
            }

            XCTAssertEqual(sum, iterations)
        }
    }

    func testFlatMapLatestPumping() async {
        await measureA {
            var sum = 0
            let subscription = await Observable<Int>.create { observer in
                for _ in 0 ..< iterations * 10 {
                    await observer.on(.next(1))
                }
                return Disposables.create()
            }
            .flatMapLatest { x in Observable.just(x) }
            .flatMapLatest { x in Observable.just(x) }
            .flatMapLatest { x in Observable.just(x) }
            .flatMapLatest { x in Observable.just(x) }
            .flatMapLatest { x in Observable.just(x) }
            .subscribe(onNext: { x in
                sum += x
            })

            await subscription.dispose()

            XCTAssertEqual(sum, iterations * 10)
        }
    }

    func testFlatMapLatestCreating() async {
        await measureA {
            var sum = 0
            for _ in 0 ..< iterations {
                let subscription = await Observable<Int>.create { observer in
                    for _ in 0 ..< 1 {
                        await observer.on(.next(1))
                    }
                    return Disposables.create()
                }
                .flatMapLatest { x in Observable.just(x) }
                .flatMapLatest { x in Observable.just(x) }
                .flatMapLatest { x in Observable.just(x) }
                .flatMapLatest { x in Observable.just(x) }
                .flatMapLatest { x in Observable.just(x) }
                .subscribe(onNext: { x in
                    sum += x
                })

                await subscription.dispose()
            }

            XCTAssertEqual(sum, iterations)
        }
    }

    func testCombineLatestPumping() async {
        await measureA {
            var sum = 0
            var last = Observable.combineLatest(
                Observable.just(1), Observable.just(1), Observable.just(1),
                Observable<Int>.create { observer in
                    for _ in 0 ..< iterations * 10 {
                        await observer.on(.next(1))
                    }
                    return Disposables.create()
                }) { x, _, _, _ in x }

            for _ in 0 ..< 6 {
                last = Observable.combineLatest(Observable.just(1), Observable.just(1), Observable.just(1), last) { x, _, _, _ in x }
            }

            let subscription = await last
                .subscribe(onNext: { x in
                    sum += x
                })

            await subscription.dispose()

            XCTAssertEqual(sum, iterations * 10)
        }
    }

    func testCombineLatestCreating() async {
        await measureA {
            var sum = 0
            for _ in 0 ..< iterations {
                var last = Observable.combineLatest(
                    Observable<Int>.create { observer in
                        for _ in 0 ..< 1 {
                            await observer.on(.next(1))
                        }
                        return Disposables.create()
                    }, Observable.just(1), Observable.just(1), Observable.just(1)) { x, _, _, _ in x }

                for _ in 0 ..< 6 {
                    last = Observable.combineLatest(last, Observable.just(1), Observable.just(1), Observable.just(1)) { x, _, _, _ in x }
                }

                let subscription = await last
                    .subscribe(onNext: { x in
                        sum += x
                    })

                await subscription.dispose()
            }

            XCTAssertEqual(sum, iterations)
        }
    }
}

private extension XCTestCase {
    func measureA(_ work: @escaping () async -> Void) async {
//        await work()
        measure { [self] in
            let expectation = expectation(description: "")
            Task {
                await work()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 3)
        }
    }
}

//
// class UnsafeTask<T> {
//    let semaphore = DispatchSemaphore(value: 0)
//    private var result: T?
//    init(block: @escaping () async -> T) {
//        Task {
//            result = await block()
//            semaphore.signal()
//        }
//    }
//
//    func get() -> T {
//        if let result = result { return result }
//        semaphore.wait()
//        return result!
//    }
// }
