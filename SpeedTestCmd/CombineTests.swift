//
//  CombineTests.swift
//  SpeedTestTests
//
//  Created by Stefan Kofler on 02.08.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Combine
import Dispatch

class CombineTests {
    func measureS(_ function: String = #function, _ work: () -> Void) {
        Tally.instance.measureS(.combine, function, work)
    }

    func measureN(_ function: String = #function) -> () -> Void {
        Tally.instance.measureN(.combine, function)
    }

    func testPublishSubjectPumping() {
        measureS {
            var sum = 0
            let subject = PassthroughSubject<Int, Never>()

            let subscription = subject
                .sink(receiveValue: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                subject.send(1)
            }

            subscription.cancel()

            assertEqual(sum, iterations * 100)
        }
    }

    func testPublishSubjectPumpingTwoSubscriptions() {
        measureS {
            var sum = 0
            let subject = PassthroughSubject<Int, Never>()

            let subscription1 = subject
                .sink(receiveValue: { x in
                    sum += x
                })

            let subscription2 = subject
                .sink(receiveValue: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                subject.send(1)
            }

            subscription1.cancel()
            subscription2.cancel()

            assertEqual(sum, iterations * 100 * 2)
        }
    }

    func testPublishSubjectCreating() {
        measureS {
            var sum = 0

            for _ in 0 ..< iterations * 10 {
                let subject = PassthroughSubject<Int, Never>()

                let subscription = subject
                    .sink(receiveValue: { x in
                        sum += x
                    })

                for _ in 0 ..< 1 {
                    subject.send(1)
                }

                subscription.cancel()
            }

            assertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterPumping() {
        measureS {
            var sum = 0

            let subscription = AnyPublisher<Int, Never>.create { subscriber in
                for _ in 0 ..< iterations * 10 {
                    _ = subscriber.receive(1)
                }
            }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .sink(receiveValue: { x in
                sum += x
            })

            subscription.cancel()

            assertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterCreating() {
        measureS {
            var sum = 0

            for _ in 0 ..< iterations {
                let subscription = AnyPublisher<Int, Never>.create { subscriber in
                    for _ in 0 ..< 1 {
                        _ = subscriber.receive(1)
                    }
                }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .sink(receiveValue: { x in
                    sum += x
                })

                subscription.cancel()
            }

            assertEqual(sum, iterations)
        }
    }

    func testFlatMapsPumping() {
        measureS {
            var sum = 0
            let subscription = AnyPublisher<Int, Never>.create { subscriber in
                for _ in 0 ..< iterations * 10 {
                    _ = subscriber.receive(1)
                }
            }
            .flatMap { x in Just(x) }
            .flatMap { x in Just(x) }
            .flatMap { x in Just(x) }
            .flatMap { x in Just(x) }
            .flatMap { x in Just(x) }
            .sink(receiveValue: { x in
                sum += x
            })

            subscription.cancel()

            assertEqual(sum, iterations * 10)
        }
    }

    func testFlatMapsCreating() {
        measureS {
            var sum = 0
            for _ in 0 ..< iterations {
                let subscription = AnyPublisher<Int, Never>.create { subscriber in
                    for _ in 0 ..< 1 {
                        _ = subscriber.receive(1)
                    }
                }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .sink(receiveValue: { x in
                    sum += x
                })

                subscription.cancel()
            }

            assertEqual(sum, iterations)
        }
    }

    func testFlatMapLatestPumping() {
        measureS {
            var sum = 0
            let subscription = AnyPublisher<Int, Never>.create { subscriber in
                for _ in 0 ..< iterations * 10 {
                    _ = subscriber.receive(1)
                }
            }
            .map { x in Just(x) }
            .switchToLatest()
            .map { x in Just(x) }
            .switchToLatest()
            .map { x in Just(x) }
            .switchToLatest()
            .map { x in Just(x) }
            .switchToLatest()
            .map { x in Just(x) }
            .switchToLatest()
            .sink(receiveValue: { x in
                sum += x
            })

            subscription.cancel()

            assertEqual(sum, iterations * 10)
        }
    }

    func testFlatMapLatestCreating() {
        measureS {
            var sum = 0
            for _ in 0 ..< iterations {
                let subscription = AnyPublisher<Int, Never>.create { subscriber in
                    for _ in 0 ..< 1 {
                        _ = subscriber.receive(1)
                    }
                }
                .map { x in Just(x) }
                .switchToLatest()
                .map { x in Just(x) }
                .switchToLatest()
                .map { x in Just(x) }
                .switchToLatest()
                .map { x in Just(x) }
                .switchToLatest()
                .map { x in Just(x) }
                .switchToLatest()
                .sink(receiveValue: { x in
                    sum += x
                })

                subscription.cancel()
            }

            assertEqual(sum, iterations)
        }
    }

    func testCombineLatestPumping() {
        measureS {
            var sum = 0

            let publisher = (0 ..< iterations * 10)
                .map { _ in 1 }
                .publisher

            var last = Just(1).combineLatest(Just(1), publisher) { x, _, _ in x }.eraseToAnyPublisher()

            for _ in 0 ..< 7 {
                last = Just(1).combineLatest(Just(1), last) { x, _, _ in x }.eraseToAnyPublisher()
            }

            let subscription = last
                .sink(receiveValue: { x in
                    sum += x
                })

            subscription.cancel()

            assertEqual(sum, iterations * 10)
        }
    }

    func testCombineLatestCreating() {
        measureS {
            var sum = 0
            for _ in 0 ..< iterations {
                var last = AnyPublisher<Int, Never>.create { subscriber in
                    for _ in 0 ..< 1 {
                        _ = subscriber.receive(1)
                    }
                }
                .combineLatest(Just(1), Just(1)) { x, _, _ in x }.eraseToAnyPublisher()

                for _ in 0 ..< 7 {
                    last = Just(1).combineLatest(Just(1), last) { x, _, _ in x }.eraseToAnyPublisher()
                }

                let subscription = last
                    .sink(receiveValue: { x in
                        sum += x
                    })

                subscription.cancel()
            }

            assertEqual(sum, iterations)
        }
    }

    func testCombineLatestCreatingConcurrent() async {
        await withCheckedContinuation { cont in

            var sum = 0
            let concurrentQueue = DispatchQueue(label: "combine", attributes: .concurrent)

            let source = AnyPublisher<Int, Never>.create { subscriber in
                for _ in 0 ..< iterations {
                    _ = subscriber.receive(1)
                }
                subscriber.receive(completion: .finished)
            }
            .receive(on: concurrentQueue)

            var last = source.combineLatest(source, source) { x, _, _ in x }.eraseToAnyPublisher()

            for _ in 0 ..< 7 {
                last = source.combineLatest(source, last) { x, _, _ in x }.eraseToAnyPublisher()
            }

            let s = measureN()
            let sink = Subscribers.Sink<Int, Never>(receiveCompletion: { _ in
                s()
                cont.resume()
            }, receiveValue: { x in
                sum += x
            })

            last.subscribe(sink)
        }
    }
    
    
    func testCombineLatestCreatingCombineConcurrentDispatchQ() async {
        await withCheckedContinuation { cont in

            var sum = 0
            let concurrentQueue = DispatchQueue(label: "combine", attributes: .concurrent)

            let source = AnyPublisher<Int, Never>.create { subscriber in
                for _ in 0 ..< iterations {
                    _ = subscriber.receive(1)
                }
                subscriber.receive(completion: .finished)
            }
            .receive(on: concurrentQueue)

            var last = source.combineLatest(source, source) { x, _, _ in x }.eraseToAnyPublisher()

            for _ in 0 ..< 7 {
                last = source.combineLatest(source, last) { x, _, _ in x }.eraseToAnyPublisher()
            }

            let s = Tally.instance.measureMs()
            let sink = Subscribers.Sink<Int, Never>(receiveCompletion: { _ in
                
                let ms = s()

                print("ASDF EXTRA TEST \(#function) \(ms) ms")
                
                cont.resume()
            }, receiveValue: { x in
                sum += x
            })

            last.subscribe(sink)
        }
    }
    
    
    func testCombineLatestCreatingCombineSerialDispatchQ() async {
        await withCheckedContinuation { cont in

            var sum = 0
            let concurrentQueue = DispatchQueue(label: "combine")

            let source = AnyPublisher<Int, Never>.create { subscriber in
                for _ in 0 ..< iterations {
                    _ = subscriber.receive(1)
                }
                subscriber.receive(completion: .finished)
            }
            .receive(on: concurrentQueue)

            var last = source.combineLatest(source, source) { x, _, _ in x }.eraseToAnyPublisher()

            for _ in 0 ..< 7 {
                last = source.combineLatest(source, last) { x, _, _ in x }.eraseToAnyPublisher()
            }

            let s = Tally.instance.measureMs()
            let sink = Subscribers.Sink<Int, Never>(receiveCompletion: { _ in
                
                let ms = s()

                print("ASDF EXTRA TEST \(#function) \(ms) ms")
                
                cont.resume()
            }, receiveValue: { x in
                sum += x
            })

            last.subscribe(sink)
        }
    }
}

func assertEqual(_ args: Any...) {}
