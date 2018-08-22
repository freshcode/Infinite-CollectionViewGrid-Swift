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

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {

            let topLeftCoordinates = coordinates(at: CGPoint(x: rect.minX, y: rect.minY))
            let bottomRightCoordinates = coordinates(at: CGPoint(x: rect.maxX, y: rect.maxY))
            return layoutAttributes(from: topLeftCoordinates, to: bottomRightCoordinates)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // Not supported
        return nil
    }

    private func layoutAttributes(from topLeftCoordinates: GridCoordinates,
                          to bottomRightCoordinates: GridCoordinates)
        -> [UICollectionViewLayoutAttributes]? {

            guard
                let grid = self.collectionView as? InfiniteGrid,
                let dataSource = grid.dataSource as? InfiniteGridDataSource
                else { return nil }

            var attributes: [UICollectionViewLayoutAttributes] = []
            for xCoordinate in topLeftCoordinates.x ... bottomRightCoordinates.x {
                for yCoordinate in topLeftCoordinates.y ... bottomRightCoordinates.y {
                    let coordinates = GridCoordinates(x: xCoordinate, y: yCoordinate)
                    attributes.append(layoutAttributes(for: coordinates, using: dataSource))
                }
            }
            return attributes
    }

    private func layoutAttributes(for coordinates: GridCoordinates,
                          using dataSource: InfiniteGridDataSource)
        -> UICollectionViewLayoutAttributes {

            let indexPath = dataSource.assignPath(to: coordinates)
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = CGRect(origin: originForTile(at: coordinates),
                                            size: tileSize)
            return layoutAttributes
    }

    func coordinates(at point: CGPoint)
        -> GridCoordinates {

            guard
                let centerCoordinates = (self.collectionView as? InfiniteGrid)?.centerCoordinates
                else { return GridCoordinates(x: 0, y: 0) }

            let centerTileOffset = gridCenterTileOffset()
            let distance = (point.x - centerTileOffset.x, point.y - centerTileOffset.y)
            let (horizontalTiles, verticalTiles) = roundToTiles(distance: distance, rounding: .awayFromZero)
            return GridCoordinates(x: centerCoordinates.x + Int(horizontalTiles),
                                   y: centerCoordinates.y + Int(verticalTiles))
    }

    private func gridCenterTileOffset()
        -> CGPoint {
            return CGPoint(x: (gridSize.width - tileSize.width) * 0.5,
                           y: (gridSize.height - tileSize.height) * 0.5)
    }

    private func originForTile(at coordinates: GridCoordinates)
        -> CGPoint {

            guard
                let centerCoordinates = (self.collectionView as? InfiniteGrid)?.centerCoordinates
                else { return CGPoint.zero }

            let centerTileOffset = gridCenterTileOffset()
            return CGPoint(x: centerTileOffset.x + tileSize.width * CGFloat(coordinates.x - centerCoordinates.x),
                           y: centerTileOffset.y + tileSize.height * CGFloat(coordinates.y - centerCoordinates.y))
    }

    func gridCenterDisplacement()
        -> (CGFloat, CGFloat) {

            guard
                let grid = self.collectionView as? InfiniteGrid
                else { return (0, 0) }

            let contentOffset = grid.contentOffset
            let visibleSize = grid.frame.size
            return (contentOffset.x - (gridSize.width - visibleSize.width) * 0.5,
                    contentOffset.y - (gridSize.height - visibleSize.height) * 0.5)
    }

    func roundToTiles(distance: (CGFloat, CGFloat),
                      rounding roundingRule: FloatingPointRoundingRule)
        -> (CGFloat, CGFloat) {

            guard tileSize.width > 0,
                tileSize.height > 0
                else { return (0, 0) }

            let (horizontal, vertical) = distance
            return ((horizontal / tileSize.width).rounded(roundingRule),
                    (vertical / tileSize.height).rounded(roundingRule))
    }
}
