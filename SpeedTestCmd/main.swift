import Foundation

func tests() async {
    print("run ", #function)
    testsRx()
    testsCombine()

    await testsRxAwait()

}

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

testsRx()
testsCombine()
await testsRxAwait()
