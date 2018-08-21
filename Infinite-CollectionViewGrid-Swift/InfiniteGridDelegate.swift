//
//  InfiniteGridDelegate.swift
//  Infinite-CollectionViewGrid-Swift
//
//  Created by Dave Poirier on 2018-08-21.
//  Copyright © 2018 ID Fusion Software Inc. All rights reserved.
//

import UIKit

class InfiniteGridDelegate: NSObject, UIScrollViewDelegate, UICollectionViewDelegate {

    weak var grid: InfiniteGrid?
    weak var layout: InfiniteGridLayout?

    private var expectingEndDecelarationEvent: Bool = false

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else {
            expectingEndDecelarationEvent = true
            return
        }
        expectingEndDecelarationEvent = false
        self.readjustOffsets()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard expectingEndDecelarationEvent else { return }
        expectingEndDecelarationEvent = false
        self.readjustOffsets()
    }

    private func readjustOffsets() {
        guard
            let gridLayout = self.layout,
            let grid = self.grid,
            gridLayout.tileSize.width > 0,
            gridLayout.tileSize.height > 0
            else { return }

        let centreOffset = CGPoint(x: (gridLayout.gridSize.width - grid.frame.size.width) * 0.5,
                                   y: (gridLayout.gridSize.height - grid.frame.size.height) * 0.5)
        let currentOffset = grid.contentOffset

        let offsetX = currentOffset.x - centreOffset.x
        let offsetY = currentOffset.y - centreOffset.y
        let fullTileOffsetX = (offsetX / gridLayout.tileSize.width).rounded(.towardZero)
        let fullTileOffsetY = (offsetY / gridLayout.tileSize.height).rounded(.towardZero)
        if fullTileOffsetY != 0 || fullTileOffsetX != 0 {
            let updatedOffset = CGPoint(x: currentOffset.x - (fullTileOffsetX * gridLayout.tileSize.width),
                                        y: currentOffset.y - (fullTileOffsetY * gridLayout.tileSize.height))
            grid.setContentOffset(updatedOffset, animated: false)
            grid.centerCoordinates = GridCoordinates(x: grid.centerCoordinates.x + Int(fullTileOffsetX), y: grid.centerCoordinates.y + Int(fullTileOffsetY))
            // reloadData() performed by didSet of centerCoordinates
        }
    }
}
