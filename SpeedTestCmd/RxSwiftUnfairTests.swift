
import RxSwiftUnfair

class RxSwiftUnfairTests {
    func measureS(_ function: String = #function, _ work: () -> Void) {
        Tally.instance.measureS(.unfairLock, function, work)
    }

    func measureN(_ function: String = #function) -> () -> Void {
        Tally.instance.measureN(.unfairLock, function)
    }

    func testPublishSubjectPumping() {
        measureS {
            var sum = 0
            let subject = PublishSubject<Int>()

            let subscription = subject
                .subscribe(onNext: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                subject.on(.next(1))
            }

            subscription.dispose()

            assertEqual(sum, iterations * 100)
        }
    }

    func testPublishSubjectPumpingTwoSubscriptions() {
        measureS {
            var sum = 0
            let subject = PublishSubject<Int>()

            let subscription1 = subject
                .subscribe(onNext: { x in
                    sum += x
                })

            let subscription2 = subject
                .subscribe(onNext: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                subject.on(.next(1))
            }

            subscription1.dispose()
            subscription2.dispose()

            assertEqual(sum, iterations * 100 * 2)
        }
    }

    func testPublishSubjectCreating() {
        measureS {
            var sum = 0

            for _ in 0 ..< iterations * 10 {
                let subject = PublishSubject<Int>()

                let subscription = subject
                    .subscribe(onNext: { x in
                        sum += x
                    })

                for _ in 0 ..< 1 {
                    subject.on(.next(1))
                }

                subscription.dispose()
            }

            assertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterPumping() {
        measureS {
            var sum = 0

            let subscription = Observable<Int>
                .create { observer in
                    for _ in 0 ..< iterations * 10 {
                        observer.on(.next(1))
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

            subscription.dispose()

            assertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterCreating() {
        measureS {
            var sum = 0

            for _ in 0 ..< iterations {
                let subscription = Observable<Int>
                    .create { observer in
                        for _ in 0 ..< 1 {
                            observer.on(.next(1))
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

                subscription.dispose()
            }

            assertEqual(sum, iterations)
        }
    }

    func testFlatMapsPumping() {
        measureS {
            var sum = 0
            let subscription = Observable<Int>
                .create { observer in
                    for _ in 0 ..< iterations * 10 {
                        observer.on(.next(1))
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

            subscription.dispose()

            assertEqual(sum, iterations * 10)
        }
    }

    func testFlatMapsCreating() {
        measureS {
            var sum = 0
            for _ in 0 ..< iterations {
                let subscription = Observable<Int>.create { observer in
                    for _ in 0 ..< 1 {
                        observer.on(.next(1))
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

                subscription.dispose()
            }

            assertEqual(sum, iterations)
        }
    }

    func testFlatMapLatestPumping() {
        measureS {
            var sum = 0
            let subscription = Observable<Int>.create { observer in
                for _ in 0 ..< iterations * 10 {
                    observer.on(.next(1))
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

            subscription.dispose()

            assertEqual(sum, iterations * 10)
        }
    }

    func testFlatMapLatestCreating() {
        measureS {
            var sum = 0
            for _ in 0 ..< iterations {
                let subscription = Observable<Int>.create { observer in
                    for _ in 0 ..< 1 {
                        observer.on(.next(1))
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

                subscription.dispose()
            }

            assertEqual(sum, iterations)
        }
    }

    func testCombineLatestPumping() {
        measureS {
            var sum = 0
            var last = Observable.combineLatest(
                Observable.just(1), Observable.just(1),
                Observable<Int>.create { observer in
                    for _ in 0 ..< iterations * 10 {
                        observer.on(.next(1))
                    }
                    return Disposables.create()
                }
            ) { x, _, _ in x }

            for _ in 0 ..< 7 {
                last = Observable
                    .combineLatest(Observable.just(1), Observable.just(1), last) { x, _, _ in x }
            }

            let subscription = last
                .subscribe(onNext: { x in
                    sum += x
                })

            subscription.dispose()

            assertEqual(sum, iterations * 10)
        }
    }

    func testCombineLatestCreating() {
        measureS {
            var sum = 0
            for _ in 0 ..< iterations {
                var last = Observable.combineLatest(
                    Observable<Int>.create { observer in
                        for _ in 0 ..< 1 {
                            observer.on(.next(1))
                        }
                        return Disposables.create()
                    }, Observable.just(1), Observable.just(1)
                ) { x, _, _ in x }

                for _ in 0 ..< 7 {
                    last = Observable
                        .combineLatest(last, Observable.just(1), Observable.just(1)) { x, _, _ in
                            x
                        }
                }

                let subscription = last
                    .subscribe(onNext: { x in
                        sum += x
                    })

                subscription.dispose()
            }

            assertEqual(sum, iterations)
        }
    }

    func testCombineLatestCreatingConcurrent() async {
        await withCheckedContinuation { cont in
            var sum = 0
            let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInteractive)

            let source = Observable<Int>.create { observer in
                for _ in 0 ..< iterations {
                    observer.on(.next(1))
                }
                observer.onCompleted()
                return Disposables.create()
            }
            .observe(on: scheduler)

            var last = Observable.combineLatest(
                source, source, source
            ) { x, _, _ in x }

            for _ in 0 ..< 7 {
                last = Observable
                    .combineLatest(last, source, source) { x, _, _ in
                        x
                    }
            }

            let s = measureN()
            _ = last
                .subscribe(onNext: { x in
                    sum += x
                }, onCompleted: {

                    s()
                    cont.resume()
                })
        }
    }

    func testCombineLatestCreatingUnfairConcurrentDispatchQ() async {
        await withCheckedContinuation { cont in
            var sum = 0
            let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInteractive)

            let source = Observable<Int>.create { observer in
                for _ in 0 ..< iterations {
                    observer.on(.next(1))
                }
                observer.onCompleted()
                return Disposables.create()
            }
            .observe(on: scheduler)

            var last = Observable.combineLatest(
                source, source, source
            ) { x, _, _ in x }

            for _ in 0 ..< 7 {
                last = Observable
                    .combineLatest(last, source, source) { x, _, _ in
                        x
                    }
            }

            let s = Tally.instance.measureMs()
            _ = last
                .subscribe(onNext: { x in
                    sum += x
                }, onCompleted: {

                    let ms = s()

                    print("ASDF EXTRA TEST \(#function) \(ms) ms")
                    cont.resume()
                })
        }
    }

    func testCombineLatestCreatingUnfairConcurrentTask() async {
        await withCheckedContinuation { cont in
            var sum = 0
            let scheduler = ConcurrentTaskScheduler.shared

            let source = Observable<Int>.create { observer in
                for _ in 0 ..< iterations {
                    observer.on(.next(1))
                }
                observer.onCompleted()
                return Disposables.create()
            }
            .observe(on: scheduler)

            var last = Observable.combineLatest(
                source, source, source
            ) { x, _, _ in x }

            for _ in 0 ..< 7 {
                last = Observable
                    .combineLatest(last, source, source) { x, _, _ in
                        x
                    }
            }

            let s = Tally.instance.measureMs()
            _ = last
                .subscribe(onNext: { x in
                    sum += x
                }, onCompleted: {

                    let ms = s()

                    print("ASDF EXTRA TEST \(#function) \(ms) ms")
                    cont.resume()
                })
        }
    }

    func testCombineLatestCreatingUnfairSerialDispatchQ() async {
        await withCheckedContinuation { cont in
            var sum = 0
            let scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)

            let source = Observable<Int>.create { observer in
                for _ in 0 ..< iterations {
                    observer.on(.next(1))
                }
                observer.onCompleted()
                return Disposables.create()
            }
            .observe(on: scheduler)

            var last = Observable.combineLatest(
                source, source, source
            ) { x, _, _ in x }

            for _ in 0 ..< 7 {
                last = Observable
                    .combineLatest(last, source, source) { x, _, _ in
                        x
                    }
            }

            let s = Tally.instance.measureMs()
            _ = last
                .subscribe(onNext: { x in
                    sum += x
                }, onCompleted: {

                    let ms = s()

                    print("ASDF EXTRA TEST \(#function) \(ms) ms")
                    cont.resume()
                })
        }
    }

    func testCombineLatestCreatingUnfairSerialTask() async {
        await withCheckedContinuation { cont in
            var sum = 0
            let scheduler = SerialTaskScheduler()

            let source = Observable<Int>.create { observer in
                for _ in 0 ..< iterations {
                    observer.on(.next(1))
                }
                observer.onCompleted()
                return Disposables.create()
            }
            .observe(on: scheduler)

            var last = Observable.combineLatest(
                source, source, source
            ) { x, _, _ in x }

            for _ in 0 ..< 7 {
                last = Observable
                    .combineLatest(last, source, source) { x, _, _ in
                        x
                    }
            }

            let s = Tally.instance.measureMs()
            _ = last
                .subscribe(onNext: { x in
                    sum += x
                }, onCompleted: {

                    let ms = s()

                    print("ASDF EXTRA TEST \(#function) \(ms) ms")
                    cont.resume()
                })
        }
    }
}
