//
//  InfiniteGridLayout.swift
//  Infinite-CollectionViewGrid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-20.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit
class InfiniteGridLayout: UICollectionViewLayout {

    let gridSize = CGSize(width: 10000000.0, height: 10000000.0) // arbitrary size - something very large
    let tileSize = CGSize(width: 100.0, height: 100.0) // arbitrary size
    override var collectionViewContentSize: CGSize {
        return gridSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        // ignore rect for now, just return one cell at center of the grid
        let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        itemAttributes.frame = CGRect(x: (gridSize.width - tileSize.width) * 0.5, y: (gridSize.height - tileSize.height) * 0.5, width: tileSize.width, height: tileSize.height)
        return [itemAttributes]
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // Not supported
        return nil
    }
}
