# Combine vs. RxSwift Performance Benchmark Test Suite 📊
This project contains a benchmarking test suite for comparing the performance of the most commonly used components and operators in RxSwift and Combine. For a detailed comparison of RxSwift with Combine have a look at [our blog post](https://quickbirdstudios.com/blog/?p=831).

The RxSwift performance benchmark tests are [the original ones used in the RxSwift project](https://github.com/ReactiveX/RxSwift/blob/master/Tests/Benchmarks/Benchmarks.swift). We removed the two tests from RxCocoa testing Drivers, since there is no equivalent in Combine. The Combine tests are 1:1 translated tests from the Rx test-suite and should, therefore, be easily comparable.

**Important update:** As mentioned correctly the old numbers were created with XCTests running in DEBUG mode. The differences seem not so critical in Release builds. We have updated all the numbers and graphs to use release builds.

![](https://quickbirdstudios.com/files/benchmarks/all_release.png)

As a summary Combine was faster in every test and on average 41% more performant than RxSwift. These statistics show every test-method and its results. Lower is better.

## Test Results Summary

UPDATE: with Swfit async algo!

**Test** | **RxSwift (ms)** | **RxSwiftUnfair (ms)** | **Combine (ms)** |  **RxSwiftAwait (ms)** | **swift-async-algorithms (ms)**
--- | --- | --- | --- | --- | ---
testMapFilterPumping() | 88 | 80 | 4 | 258 | 179
testMapFilterCreating() | 60 | 75 | 44 | 96 | 45
testFlatMapsPumping() | 299 | 292 | 202 | 1535 | 438
testFlatMapsCreating() | 79 | 87 | 55 | 280 | 63
testCombineLatestPumping() | 185 | 257 | 204 | 779 | 3982
testCombineLatestCreating() | 192 | 247 | 227 | 545 | 1770

**Test** | **RxSwift (ms)** | **RxSwiftUnfair (ms)** | **Combine (ms)** |  **RxSwiftAwait (ms)**
--- | --- | --- | --- | --- 
testPublishSubjectPumping() | 203 | 189 | 54 | 779
testPublishSubjectPumpingTwoSubscriptions() | 333 | 310 | 220 | 1130
testPublishSubjectCreating() | 106 | 116 | 94 | 244
testMapFilterPumping() | 82 | 76 | 4 | 250
testMapFilterCreating() | 59 | 74 | 43 | 94
testFlatMapsPumping() | 292 | 287 | 198 | 1522
testFlatMapsCreating() | 78 | 88 | 56 | 279
testFlatMapLatestPumping() | 301 | 381 | 210 | 1713
testFlatMapLatestCreating() | 79 | 100 | 58 | 301
testCombineLatestPumping() | 176 | 228 | 214 | 737
testCombineLatestCreating() | 204 | 267 | 242 | 615

### Testing Details
**Machine**: MacBook Pro 2023, Apple M3 Max, 48 GB  
**IDE**: Xcode 16.0  
**Testing Device**: macOS cli  

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

