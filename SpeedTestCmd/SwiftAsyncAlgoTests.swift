
import AsyncAlgorithms

class SwiftAsyncAlgoTests {
    func measureA(_ function: String = #function) -> () -> Void {
        Tally.instance.measureA(.asyncAlgo, function)
    }

    func testPublishSubjectPumping() async {
//        let s = measureA()
//        var sum = 0
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
    }

    func testPublishSubjectPumpingTwoSubscriptions() async {
//        let s = measureA()
//        var sum = 0
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
    }

    func testPublishSubjectCreating() async {
//        let s = measureA()
//        var sum = 0
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
    }

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

    func testMapFilterCreating() async {
        let s = measureA()
        var sum = 0

        for _ in 0 ..< iterations {
            let source = (0 ..< 1).async

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

        }

        assertEqual(sum, iterations)
        s()
    }

    func testFlatMapsPumping() async {
        let s = measureA()
        var sum = 0

        let source = (0 ..< iterations * 10).async

        let target = source
            .flatMap { x in [x].async }
            .flatMap { x in [x].async }
            .flatMap { x in [x].async }
            .flatMap { x in [x].async }
            .flatMap { x in [x].async }

        for await x in target {
            sum += x
        }

        assertEqual(sum, iterations * 10)
        s()
    }

    func testFlatMapsCreating() async {
        let s = measureA()
        var sum = 0
        for _ in 0 ..< iterations {
            let source = (0 ..< 1).async

            let target = source
                .flatMap { x in [x].async }
                .flatMap { x in [x].async }
                .flatMap { x in [x].async }
                .flatMap { x in [x].async }
                .flatMap { x in [x].async }

            for await x in target {
                sum += x
            }
        }

        assertEqual(sum, iterations)
        s()
    }

    /// wait, there is no flatMapLatest
    func testFlatMapLatestPumping() async {
//        let s = measureA()
//        var sum = 0
//        let subscription = await Observable<Int>.create { observer in
//            for _ in 0 ..< iterations * 10 {
//                await observer.on(.next(1))
//            }
//            return Disposables.create()
//        }
//        .flatMapLatest { x in [x].async }
//        .flatMapLatest { x in [x].async }
//        .flatMapLatest { x in [x].async }
//        .flatMapLatest { x in [x].async }
//        .flatMapLatest { x in [x].async }
//        .subscribe(onNext: { x in
//            sum += x
//        })
//
//        await subscription.dispose()
//
//        assertEqual(sum, iterations * 10)
//        s()
    }

    /// wait, there is no flatMapLatest
    func testFlatMapLatestCreating() async {
//        let s = measureA()
//        var sum = 0
//        for _ in 0 ..< iterations {
//            let source = (0 ..< 1).async
//
//
//            let target = source
//                .flatMapLatest { x in [x].async }
//                .flatMapLatest { x in [x].async }
//                .flatMapLatest { x in [x].async }
//                .flatMapLatest { x in [x].async }
//                .flatMapLatest { x in [x].async }
//                .subscribe(onNext: { x in
//                    sum += x
//                })
//
        ////            await subscription.dispose()
//        }
//
//        assertEqual(sum, iterations)
//        s()
    }

    func testCombineLatestPumping() async {
        let s = measureA()
        var sum = 0

        let source = (0 ..< iterations * 10).async

        let last = combineLatest(
            [1].async, [1].async, source
        )

        let iter1 = combineLatest([1].async, [1].async, last)
        let iter2 = combineLatest([1].async, [1].async, iter1)
        let iter3 = combineLatest([1].async, [1].async, iter2)
        let iter4 = combineLatest([1].async, [1].async, iter3)
        let iter5 = combineLatest([1].async, [1].async, iter4)
        let iter6 = combineLatest([1].async, [1].async, iter5)

        for await x in iter6 {
            sum += x.2.2.2.2.2.2.2
        }

        assertEqual(sum, iterations * 10)

        s()
    }

    func testCombineLatestCreating() async {
        let s = measureA()
        var sum = 0
        for _ in 0 ..< iterations {
            let source = [0].async
            let last = combineLatest(
                source, [1].async, [1].async
            )

            let iter1 = combineLatest(last, [1].async, [1].async)
            let iter2 = combineLatest(iter1, [1].async, [1].async)
            let iter3 = combineLatest(iter2, [1].async, [1].async)
            let iter4 = combineLatest(iter3, [1].async, [1].async)
            let iter5 = combineLatest(iter4, [1].async, [1].async)
            let iter6 = combineLatest(iter5, [1].async, [1].async)

            for await x in iter6 {
                sum += x.0.0.0.0.0.0.0
            }
        }

        assertEqual(sum, iterations)
        s()
    }
}
