import RxSwiftAwait

class RxSwiftAwaitTests {
    func measureA(_ function: String = #function) -> () -> Void {
        Tally.instance.measureA(.async, function)
    }

    func testPublishSubjectPumping() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
        let subject = PublishSubject<Int>()

        let subscription = await subject
            .subscribe(onNext: { x in
                sum += x
            })

        for _ in 0 ..< iterations * 100 {
            await subject.on(.next(1))
        }

        await subscription.dispose()

        assertEqual(sum, iterations * 100)
        s()
    }

    func testPublishSubjectPumpingTwoSubscriptions() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
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

        assertEqual(sum, iterations * 100 * 2)
        s()
    }

    func testPublishSubjectCreating() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0

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

        assertEqual(sum, iterations * 10)
        s()
    }

    func testMapFilterPumping() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0

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

        assertEqual(sum, iterations * 10)
        s()
    }

    func testMapFilterCreating() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0

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

        assertEqual(sum, iterations)
        s()
    }

    func testFlatMapsPumping() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
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

        assertEqual(sum, iterations * 10)
        s()
    }

    func testFlatMapsCreating() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
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

        assertEqual(sum, iterations)
        s()
    }

    func testFlatMapLatestPumping() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
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

        assertEqual(sum, iterations * 10)
        s()
    }

    func testFlatMapLatestCreating() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
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

        assertEqual(sum, iterations)
        s()
    }

    func testCombineLatestPumping() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
        var last = Observable.combineLatest(
            Observable.just(1), Observable.just(1), Observable.just(1),
            Observable<Int>.create { observer in
                for _ in 0 ..< iterations * 10 {
                    await observer.on(.next(1))
                }
                return Disposables.create()
            }
        ) { x, _, _, _ in x }

        for _ in 0 ..< 6 {
            last = Observable
                .combineLatest(Observable.just(1), Observable.just(1), Observable.just(1), last) { x, _, _, _ in x }
        }

        let subscription = await last
            .subscribe(onNext: { x in
                sum += x
            })

        await subscription.dispose()

        assertEqual(sum, iterations * 10)

        s()
    }

    func testCombineLatestCreating() async {
        let s = measureA()
        nonisolated(unsafe) var sum = 0
        for _ in 0 ..< iterations {
            var last = Observable.combineLatest(
                Observable<Int>.create { observer in
                    for _ in 0 ..< 1 {
                        await observer.on(.next(1))
                    }
                    return Disposables.create()
                }, Observable.just(1), Observable.just(1), Observable.just(1)
            ) { x, _, _, _ in x }

            for _ in 0 ..< 6 {
                last = Observable
                    .combineLatest(last, Observable.just(1), Observable.just(1), Observable.just(1)) { x, _, _, _ in
                        x
                    }
            }

            let subscription = await last
                .subscribe(onNext: { x in
                    sum += x
                })

            await subscription.dispose()
        }

        assertEqual(sum, iterations)
        s()
    }
}

enum Source {
    case async
    case combine
    case vanilla
    case unfairLock
    case asyncAlgo
}

final class Tally: @unchecked Sendable {
    static let instance = Tally()

    var vanillaResults: [String: Int] = [:]
    var unfairLockResults: [String: Int] = [:]
    var combineResults: [String: Int] = [:]
    var asyncResults: [String: Int] = [:]
    var asyncAlgo: [String: Int] = [:]

    func measureS(_ source: Source, _ label: String = #function, _ work: () -> Void) {
        let start = Date()

        work()
        let end = Date()

        let diff = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate

        let ms = Int(diff * 1000)

        writeResults(source, label, ms)
    }

    func measureA(_ source: Source, _ label: String = #function) -> () -> Void {
        let start = Date()

        return { [self] in
            let end = Date()

            let diff = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate

            let ms = Int(diff * 1000)

            writeResults(source, label, ms)
        }
    }

    func writeResults(_ source: Source, _ label: String, _ ms: Int) {
        switch source {

        case .asyncAlgo:
            asyncAlgo[label] = ms
        case .async:
            asyncResults[label] = ms
        case .combine:
            combineResults[label] = ms
        case .vanilla:
            vanillaResults[label] = ms
        case .unfairLock:
            unfairLockResults[label] = ms
        }

        let allGood = [
            asyncResults.keys,
            combineResults.keys,
            vanillaResults.keys,
            unfairLockResults.keys,
            asyncAlgo.keys,
        ]
        .allSatisfy { keys in
            keys.contains(where: { $0 == label })
        }

        if allGood {
            print(
                "\(label) | \(vanillaResults[label]!) | \(unfairLockResults[label]!) | \(combineResults[label]!) | \(asyncResults[label]!) | \(asyncAlgo[label]!)"
            )
//            print(
//                "ASDF \(label) rxswift: \(vanillaResults[label]!) ms, rsswiftunfair: \(unfairLockResults[label]!) ms,
//                combine: \(combineResults[label]!) ms, rxswiftawait: \(asyncResults[label]!) ms"
//            )
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
