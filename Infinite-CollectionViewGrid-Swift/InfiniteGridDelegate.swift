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
        guard let layout = self.layout else { return }

        let displacement = layout.gridCenterDisplacement()
        let (horizontalTiles, verticalTiles) = layout.roundToTiles(distance: displacement, rounding: .towardZero)
        adjustContentOffsetBy(horizontalTiles, verticalTiles)
    }

    private func adjustContentOffsetBy(_ horizontalTiles: CGFloat, _ verticalTiles: CGFloat) {
        guard
            let tileSize = self.layout?.tileSize,
            let grid = self.grid,
            horizontalTiles != 0 || verticalTiles != 0
            else { return }

        let updatedOffset = CGPoint(x: grid.contentOffset.x - (horizontalTiles * tileSize.width),
                                    y: grid.contentOffset.y - (verticalTiles * tileSize.height))
        grid.setContentOffset(updatedOffset, animated: false)
        grid.centerCoordinates = GridCoordinates(x: grid.centerCoordinates.x + Int(horizontalTiles),
                                                 y: grid.centerCoordinates.y + Int(verticalTiles))
        // reloadData() performed by didSet of centerCoordinates
    }
}
