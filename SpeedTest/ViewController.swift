//
//  ViewController.swift
//  SpeedTest
//
//  Created by Stefan Kofler on 02.08.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        DispatchQueue.global().async {
            self.tests()
        }
    }

    func tests() {
        testsRx()
        testsCombine()
        Task {
            await self.testsRxAwait()
        }
    }

    func testsRx() {
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
}
