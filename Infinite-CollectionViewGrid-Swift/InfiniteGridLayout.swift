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

        guard
            let collectionView = self.collectionView as? InfiniteGrid,
            let dataSource = collectionView.dataSource as? InfiniteGridDataSource
            else { return nil }

        // Compute rect relation to grid center
        let gridCenterCoordinates = collectionView.centerCoordinates
        let gridCenterTileTopLeftPosition = CGPoint(x: (gridSize.width - tileSize.width) * 0.5, y: (gridSize.height - tileSize.height) * 0.5)
        let rectOriginDistanceX = rect.minX - gridCenterTileTopLeftPosition.x
        let rectOriginDistanceY = rect.minY - gridCenterTileTopLeftPosition.y
        let rectOriginTilesDistanceX = (rectOriginDistanceX / tileSize.width).rounded(.awayFromZero)
        let rectOriginTilesDistanceY = (rectOriginDistanceY / tileSize.height).rounded(.awayFromZero)

        // Prepare iterations variables
        var tilePosition = CGPoint(x: gridCenterTileTopLeftPosition.x + (rectOriginTilesDistanceX * tileSize.width),
                                   y: gridCenterTileTopLeftPosition.y + (rectOriginTilesDistanceY * tileSize.width))
        var coordinatesY: Int = gridCenterCoordinates.y + Int(rectOriginTilesDistanceY)
        var attributes: [UICollectionViewLayoutAttributes] = []

        repeat {
            let originX = tilePosition.x
            var coordinatesX: Int = gridCenterCoordinates.x + Int(rectOriginTilesDistanceX)
            repeat {

                // Build layout attributes
                let coordinates = GridCoordinates(x: coordinatesX, y: coordinatesY)
                let indexPath = dataSource.assignPath(to: coordinates)
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                layoutAttributes.frame = CGRect(x: tilePosition.x, y: tilePosition.y, width: tileSize.width, height: tileSize.height)
                attributes.append(layoutAttributes)

                // Iterate on the x axis for all elements in rect
                coordinatesX += 1
                tilePosition.x = tilePosition.x + tileSize.width
            } while tilePosition.x < rect.maxX

            // Iterate on the y axis for all elements in rect
            coordinatesY += 1
            tilePosition.x = originX
            tilePosition.y = tilePosition.y + tileSize.height
        } while tilePosition.y < rect.maxY

        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // Not supported
        return nil
    }
}
