# Combine vs. RxSwift Performance Benchmark Test Suite 📊
This project contains a benchmarking test suite for comparing the performance of the most commonly used components and operators in RxSwift and Combine. For a detailed comparison of RxSwift with Combine have a look at [our blog post](https://quickbirdstudios.com/blog/?p=831).

The RxSwift performance benchmark tests are [the original ones used in the RxSwift project](https://github.com/ReactiveX/RxSwift/blob/master/Tests/Benchmarks/Benchmarks.swift). We removed the two tests from RxCocoa testing Drivers, since there is no equivalent in Combine. The Combine tests are 1:1 translated tests from the Rx test-suite and should, therefore, be easily comparable.

**Important update:** As mentioned correctly the old numbers were created with XCTests running in DEBUG mode. The differences seem not so critical in Release builds. We have updated all the numbers and graphs to use release builds.

![](https://quickbirdstudios.com/files/benchmarks/all_release.png)

As a summary Combine was faster in every test and on average 41% more performant than RxSwift. These statistics show every test-method and its results. Lower is better.

## Test Results Summary

**Test** | **RxSwift (ms)** | **Combine (ms)** | **RxSwiftUnfair (ms)** | **RxSwiftAwait (ms)**
--- | --- | --- | --- | --- 
**PublishSubjectPumping** | 157 | 51 | 142
**PublishSubjectPumpingTwoSubscriptions** | 251 | 212 | 232
**PublishSubjectCreating** | 90 | 84 | 102
**MapFilterPumping** | 64 | 6 | 
**MapFilterCreating** | 53 | 39 | 
**FlatMapsPumping** | 231 | 171 | 231 (229, 155, 228)
**FlatMapsCreating** | 68 | 51 | 81 
**FlatMapLatestPumping** | 247 | 172 | 315
**FlatMapLatestCreating** | 71 | 52 | 93
**CombineLatestPumping** | 137 | 157 | 173
**CombineLatestCreating** | 166 | 192 | 221

### Testing Details
**Machine**: MacBook Pro 2023, Apple M3 Max, 48 GB
**IDE**: Xcode 16.0 beta 6 (11M382q)
**Testing Device**: iPhone 12 mini Simulator

## old result

**Test** | **RxSwift (ms)** | **Combine (ms)** | **Factor**
--- | --- | --- | ---
**PublishSubjectPumping** | 227 | 135 | 168%
**PublishSubjectPumpingTwoSubscriptions** | 400 | 246 | 163%
**PublishSubjectCreating** | 295 | 250 | 118%
**MapFilterPumping** | 123 | 132 | 93%
**MapFilterCreating** |168 | 114 | 147%
**FlatMapsPumping** | 646 | 367 | 176%
**FlatMapsCreating** | 214 | 121 | 177%
**FlatMapLatestPumping** | 810 | 696 | 116%
**FlatMapLatestCreating** | 263 | 180 | 146%
**CombineLatestPumping** | 298 | 282 | 106%
**CombineLatestCreating** | 644 | 467 | 138%

### Testing Details
**Machine**: MacBook Pro 2018, 2,7 GHz Intel Core i7, 16 GB
**IDE**: Xcode 11.0 beta 5 (11M382q)
**Testing Device**: iPhone XR Simulator

## Performance Test Example: PublishSubject Pumping

For every test we replace the RxSwift component with the corresponding Combine component. In this case `PublishSubject` with `PassthroughSubject`.

### RxSwift
```swift
func testPublishSubjectPumping() {
    measure {
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

        XCTAssertEqual(sum, iterations * 100)
    }
}
```

### Combine
```swift
func testPublishSubjectPumping() {
    measure {
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
        
        XCTAssertEqual(sum, iterations * 100)
    }
}
```

## Detailed Performance Test Results: RxSwift vs. Combine

### PublishSubjectPumping 

![](https://quickbirdstudios.com/files/benchmarks/1_release.png)

### PublishSubjectPumpingTwoSubscriptions

![](https://quickbirdstudios.com/files/benchmarks/2_release.png)

### PublishSubjectCreating

![](https://quickbirdstudios.com/files/benchmarks/3_release.png)

### MapFilterPumping

![](https://quickbirdstudios.com/files/benchmarks/4_release.png)

### MapFilterCreating

![](https://quickbirdstudios.com/files/benchmarks/5_release.png)

### FlatMapsPumping

![](https://quickbirdstudios.com/files/benchmarks/6_release.png)

### FlatMapsCreating

![](https://quickbirdstudios.com/files/benchmarks/7_release.png)

### FlatMapLatestPumping

![](https://quickbirdstudios.com/files/benchmarks/8_release.png)

### FlatMapLatestCreating

![](https://quickbirdstudios.com/files/benchmarks/9_release.png)

### CombineLatestPumping

![](https://quickbirdstudios.com/files/benchmarks/10_release.png)

### CombineLatestCreating

![](https://quickbirdstudios.com/files/benchmarks/11_release.png)

