//
//  ViewController.swift
//  Infinite-CollectionViewGrid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-20.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit
class ViewController: UIViewController {

    var infiniteGrid: InfiniteGrid?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.infiniteGrid = InfiniteGrid(hostView: self.view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        infiniteGrid?.scrollToCenter()
    }
}
