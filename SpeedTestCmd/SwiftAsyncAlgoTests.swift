
import AsyncAlgorithms

class SwiftAsyncAlgoTests {
    func measureA(_ function: String = #function) -> () -> Void {
        Tally.instance.measureA(.asyncAlgo, function)
    }

//
//    func testPublishSubjectPumping() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        let subject = PublishSubject<Int>()
//
//        let subscription = await subject
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//        for _ in 0 ..< iterations * 100 {
//            await subject.on(.next(1))
//        }
//
//        await subscription.dispose()
//
//        assertEqual(sum, iterations * 100)
//        s()
//    }
//
//    func testPublishSubjectPumpingTwoSubscriptions() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        let subject = PublishSubject<Int>()
//
//        let subscription1 = await subject
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//        let subscription2 = await subject
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//        for _ in 0 ..< iterations * 100 {
//            await subject.on(.next(1))
//        }
//
//        await subscription1.dispose()
//        await subscription2.dispose()
//
//        assertEqual(sum, iterations * 100 * 2)
//        s()
//    }
//
//    func testPublishSubjectCreating() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//
//        for _ in 0 ..< iterations * 10 {
//            let subject = PublishSubject<Int>()
//
//            let subscription = await subject
//                .subscribe(onNext: { x in
//                    sum += x
//                })
//
//            for _ in 0 ..< 1 {
//                await subject.on(.next(1))
//            }
//
//            await subscription.dispose()
//        }
//
//        assertEqual(sum, iterations * 10)
//        s()
//    }

    func testMapFilterPumping() async {
        let s = measureA()
        var sum = 0

        let source = (0 ..< iterations * 10).async

        let target = source
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }

        for await x in target {
            sum += x
        }

        assertEqual(sum, iterations * 10)
        s()
    }
//
//    func testMapFilterCreating() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//
//        for _ in 0 ..< iterations {
//            let subscription = await Observable<Int>
//                .create { observer in
//                    for _ in 0 ..< 1 {
//                        await observer.on(.next(1))
//                    }
//                    return Disposables.create()
//                }
//                .map { $0 }.filter { _ in true }
//                .map { $0 }.filter { _ in true }
//                .map { $0 }.filter { _ in true }
//                .map { $0 }.filter { _ in true }
//                .map { $0 }.filter { _ in true }
//                .map { $0 }.filter { _ in true }
//                .subscribe(onNext: { x in
//                    sum += x
//                })
//
//            await subscription.dispose()
//        }
//
//        assertEqual(sum, iterations)
//        s()
//    }
//
//    func testFlatMapsPumping() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        let subscription = await Observable<Int>
//            .create { observer in
//                for _ in 0 ..< iterations * 10 {
//                    await observer.on(.next(1))
//                }
//                return Disposables.create()
//            }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//        await subscription.dispose()
//
//        assertEqual(sum, iterations * 10)
//        s()
//    }
//
//    func testFlatMapsCreating() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        for _ in 0 ..< iterations {
//            let subscription = await Observable<Int>.create { observer in
//                for _ in 0 ..< 1 {
//                    await observer.on(.next(1))
//                }
//                return Disposables.create()
//            }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .flatMap { x in Observable.just(x) }
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//            await subscription.dispose()
//        }
//
//        assertEqual(sum, iterations)
//        s()
//    }
//
//    func testFlatMapLatestPumping() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        let subscription = await Observable<Int>.create { observer in
//            for _ in 0 ..< iterations * 10 {
//                await observer.on(.next(1))
//            }
//            return Disposables.create()
//        }
//        .flatMapLatest { x in Observable.just(x) }
//        .flatMapLatest { x in Observable.just(x) }
//        .flatMapLatest { x in Observable.just(x) }
//        .flatMapLatest { x in Observable.just(x) }
//        .flatMapLatest { x in Observable.just(x) }
//        .subscribe(onNext: { x in
//            sum += x
//        })
//
//        await subscription.dispose()
//
//        assertEqual(sum, iterations * 10)
//        s()
//    }
//
//    func testFlatMapLatestCreating() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        for _ in 0 ..< iterations {
//            let subscription = await Observable<Int>.create { observer in
//                for _ in 0 ..< 1 {
//                    await observer.on(.next(1))
//                }
//                return Disposables.create()
//            }
//            .flatMapLatest { x in Observable.just(x) }
//            .flatMapLatest { x in Observable.just(x) }
//            .flatMapLatest { x in Observable.just(x) }
//            .flatMapLatest { x in Observable.just(x) }
//            .flatMapLatest { x in Observable.just(x) }
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//            await subscription.dispose()
//        }
//
//        assertEqual(sum, iterations)
//        s()
//    }
//
//    func testCombineLatestPumping() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        var last = Observable.combineLatest(
//            Observable.just(1), Observable.just(1), Observable.just(1),
//            Observable<Int>.create { observer in
//                for _ in 0 ..< iterations * 10 {
//                    await observer.on(.next(1))
//                }
//                return Disposables.create()
//            }
//        ) { x, _, _, _ in x }
//
//        for _ in 0 ..< 6 {
//            last = Observable
//                .combineLatest(Observable.just(1), Observable.just(1), Observable.just(1), last) { x, _, _, _ in x }
//        }
//
//        let subscription = await last
//            .subscribe(onNext: { x in
//                sum += x
//            })
//
//        await subscription.dispose()
//
//        assertEqual(sum, iterations * 10)
//
//        s()
//    }
//
//    func testCombineLatestCreating() async {
//        let s = measureA()
//        nonisolated(unsafe) var sum = 0
//        for _ in 0 ..< iterations {
//            var last = Observable.combineLatest(
//                Observable<Int>.create { observer in
//                    for _ in 0 ..< 1 {
//                        await observer.on(.next(1))
//                    }
//                    return Disposables.create()
//                }, Observable.just(1), Observable.just(1), Observable.just(1)
//            ) { x, _, _, _ in x }
//
//            for _ in 0 ..< 6 {
//                last = Observable
//                    .combineLatest(last, Observable.just(1), Observable.just(1), Observable.just(1)) { x, _, _, _ in
//                        x
//                    }
//            }
//
//            let subscription = await last
//                .subscribe(onNext: { x in
//                    sum += x
//                })
//
//            await subscription.dispose()
//        }
//
//        assertEqual(sum, iterations)
//        s()
//    }
}
