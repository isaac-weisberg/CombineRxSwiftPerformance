import Foundation

func tests() async {
    print("run ", #function)
    testsRx()
    testsRxUnfair()
    testsCombine()
    await testsRxAwait()
    await testsAsyncAlgo()
}

// func testsMapFilterPumpingSync() {
//    RxSwiftTests().testMapFilterPumping()
//    RxSwiftUnfairTests().testMapFilterPumping()
//    CombineTests().testMapFilterPumping()
////    await RxSwiftAwaitTests().testMapFilterPumping()
// }

func testsRx() {
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
}

func testsRxUnfair() {
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
}

func testsCombine() {
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

}

await tests()

// RxSwiftTests().testMapFilterPumping()
// RxSwiftUnfairTests().testMapFilterPumping()
// CombineTests().testMapFilterPumping()
// await RxSwiftAwaitTests().testMapFilterPumping()
// await SwiftAsyncAlgoTests().testMapFilterPumping()

// await testStateHolderActor()
// testStateHolderLocked()
