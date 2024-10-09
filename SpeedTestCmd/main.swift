// import Foundation

//
// RxSwiftTests().testMapFilterPumping()
// RxSwiftUnfairTests().testMapFilterPumping()
// CombineTests().testMapFilterPumping()
// await RxSwiftAwaitTests().testMapFilterPumping()
// await SwiftAsyncAlgoTests().testMapFilterPumping()

// await testStateHolderActor()
// testStateHolderLocked()

// @main
// struct MyApp {
//
//    static func main() {
//        print("Starting the app")
//
//    }
//
// }

import Dispatch

struct A {

    struct Completion: Sendable {
        let closure: @Sendable () -> Void

        init(closure: @Sendable @escaping () -> Void) {
            self.closure = closure
        }

        func callAsFunction() {
            closure()
        }
    }

    func tests() async {
        print("run ", #function)
        await syncTests()
        await asyncTests()
    }

    func asyncTests() async {
        print("run ", #function)
        await testsRxAwait()
        await testsAsyncAlgo()
    }

    func syncTests() async {
        print("run ", #function)
        await testsRx()
        await testsRxUnfair()
        await testsCombine()
    }

    func testsCombineLatestConcurrent() async {
        await RxSwiftTests().testCombineLatestCreatingConcurrent()
        await RxSwiftUnfairTests().testCombineLatestCreatingConcurrent()
        await CombineTests().testCombineLatestCreatingConcurrent()
        await RxSwiftAwaitTests().testCombineLatestCreatingConcurrent()
        await SwiftAsyncAlgoTests().testCombineLatestCreatingConcurrent()
    }

    // func testsMapFilterPumpingSync() {
    //    RxSwiftTests().testMapFilterPumping()
    //    RxSwiftUnfairTests().testMapFilterPumping()
    //    CombineTests().testMapFilterPumping()
    ////    await RxSwiftAwaitTests().testMapFilterPumping()
    // }

    func testsRx() async {
        print("run ", #function)
        let tests = RxSwiftTests()
        tests.testPublishSubjectPumping()
        tests.testPublishSubjectPumpingTwoSubscriptions()
        tests.testPublishSubjectCreating()
        tests.testMapFilterPumping()
        tests.testMapFilterCreating()
        tests.testFlatMapsPumping()
        tests.testFlatMapsCreating()
        tests.testFlatMapLatestPumping()
        tests.testFlatMapLatestCreating()
        tests.testCombineLatestPumping()
        tests.testCombineLatestCreating()
        await tests.testCombineLatestCreatingConcurrent()
    }

    func testsRxUnfair() async {
        print("run ", #function)
        let tests = RxSwiftUnfairTests()
        tests.testPublishSubjectPumping()
        tests.testPublishSubjectPumpingTwoSubscriptions()
        tests.testPublishSubjectCreating()
        tests.testMapFilterPumping()
        tests.testMapFilterCreating()
        tests.testFlatMapsPumping()
        tests.testFlatMapsCreating()
        tests.testFlatMapLatestPumping()
        tests.testFlatMapLatestCreating()
        tests.testCombineLatestPumping()
        tests.testCombineLatestCreating()
        await tests.testCombineLatestCreatingConcurrent()
    }

    func testsCombine() async {
        print("run ", #function)
        let tests = CombineTests()
        tests.testPublishSubjectPumping()
        tests.testPublishSubjectPumpingTwoSubscriptions()
        tests.testPublishSubjectCreating()
        tests.testMapFilterPumping()
        tests.testMapFilterCreating()
        tests.testFlatMapsPumping()
        tests.testFlatMapsCreating()
        tests.testFlatMapLatestPumping()
        tests.testFlatMapLatestCreating()
        tests.testCombineLatestPumping()
        tests.testCombineLatestCreating()
        await tests.testCombineLatestCreatingConcurrent()
    }

    func testsRxAwait() async {
        print("run ", #function)
        let tests = RxSwiftAwaitTests()
        await tests.testPublishSubjectPumping()
        await tests.testPublishSubjectPumpingTwoSubscriptions()
        await tests.testPublishSubjectCreating()
        await tests.testMapFilterPumping()
        await tests.testMapFilterCreating()
        await tests.testFlatMapsPumping()
        await tests.testFlatMapsCreating()
        await tests.testFlatMapLatestPumping()
        await tests.testFlatMapLatestCreating()
        await tests.testCombineLatestPumping()
        await tests.testCombineLatestCreating()
        await tests.testCombineLatestCreatingConcurrent()
    }

    func testsAsyncAlgo() async {
        print("run ", #function)
        let tests = SwiftAsyncAlgoTests()
        await tests.testPublishSubjectPumping()
        await tests.testPublishSubjectPumpingTwoSubscriptions()
        await tests.testPublishSubjectCreating()
        await tests.testMapFilterPumping()
        await tests.testMapFilterCreating()
        await tests.testFlatMapsPumping()
        await tests.testFlatMapsCreating()
        await tests.testFlatMapLatestPumping()
        await tests.testFlatMapLatestCreating()
        await tests.testCombineLatestPumping()
        await tests.testCombineLatestCreating()
        await tests.testCombineLatestCreatingConcurrent()
    }

}

await A().testsCombineLatestConcurrent()

await RxSwiftUnfairTests().testCombineLatestCreatingUnfairConcurrentDispatchQ()
await RxSwiftUnfairTests().testCombineLatestCreatingUnfairConcurrentTask()
await RxSwiftUnfairTests().testCombineLatestCreatingUnfairSerialDispatchQ()
await RxSwiftUnfairTests().testCombineLatestCreatingUnfairSerialTask()
await RxSwiftAwaitTests().testCombineLatestCreatingRxSwiftAwaitSerial()
await RxSwiftAwaitTests().testCombineLatestCreatingRxSwiftAwaitConcurrent()

print("All work is done, now exiting")
