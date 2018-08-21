//
//  InfiniteGridDataSource.swift
//  Infinite-CollectionViewGrid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-20.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT


import UIKit
class InfiniteGridDataSource: NSObject, UICollectionViewDataSource {

    let pathsCacheSize: Int = 1024 // arbitrary large number, increase if you use small tile sizes and some cells are not appearing when scrolling
    var pathsCache: [IndexPath: GridCoordinates] = [:]
    var pathsCacheIndex: Int = 0

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pathsCacheSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let coordinates = pathsCache[indexPath] ?? GridCoordinates(x: 0, y: 0)
        return InfiniteGridCell.dequeue(from: collectionView, at: indexPath, for: coordinates)
    }

    func assignPath(to coordinates: GridCoordinates) -> IndexPath {
        for cacheEntry in pathsCache where cacheEntry.value == coordinates {
            return cacheEntry.key
        }
        let indexPath = IndexPath(item: pathsCacheIndex, section: 0)
        pathsCacheIndex = (pathsCacheIndex + 1) % pathsCacheSize
        pathsCache[indexPath] = coordinates
        return indexPath
    }
}
