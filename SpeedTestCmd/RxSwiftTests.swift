@preconcurrency import RxSwift

let iterations = 10000

class RxSwiftTests {
    func measureS(_ function: String = #function, _ work: () -> Void) {
        Tally.instance.measureS(.vanilla, function, work)
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
                Observable.just(1), Observable.just(1), Observable.just(1),
                Observable<Int>.create { observer in
                    for _ in 0 ..< iterations * 10 {
                        observer.on(.next(1))
                    }
                    return Disposables.create()
                }
            ) { x, _, _, _ in x }

            for _ in 0 ..< 6 {
                last = Observable
                    .combineLatest(Observable.just(1), Observable.just(1), Observable.just(1), last) { x, _, _, _ in x }
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
                    }, Observable.just(1), Observable.just(1), Observable.just(1)
                ) { x, _, _, _ in x }

                for _ in 0 ..< 6 {
                    last = Observable
                        .combineLatest(last, Observable.just(1), Observable.just(1), Observable.just(1)) { x, _, _, _ in
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
}
