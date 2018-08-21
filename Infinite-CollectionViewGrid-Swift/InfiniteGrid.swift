//
//  InfiniteGrid.swift
//  Infinite-CollectionViewGrid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-20.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit
class InfiniteGrid: UICollectionView {

    let infiniteDataSource = InfiniteGridDataSource()
    let infiniteDelegate = InfiniteGridDelegate()
    var centerCoordinates = GridCoordinates(x: 0, y: 0) {
        didSet { self.reloadData() }
    }

    convenience init(hostView: UIView) {
        self.init(frame: hostView.bounds, collectionViewLayout: InfiniteGridLayout())
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
        self.backgroundColor = UIColor.clear
        self.dataSource = infiniteDataSource
        InfiniteGridCell.register(with: self)

        self.delegate = infiniteDelegate
        infiniteDelegate.grid = self
        infiniteDelegate.layout = self.collectionViewLayout as? InfiniteGridLayout

        hostView.addSubview(self)
    }

    func scrollToCenter() {
        let size = self.contentSize
        let topLeftCoordinatesWhenCentered = CGPoint(x: (size.width - self.frame.width) * 0.5,
                                                     y: (size.height - self.frame.height) * 0.5)
        self.setContentOffset(topLeftCoordinatesWhenCentered, animated: false)
    }
}
