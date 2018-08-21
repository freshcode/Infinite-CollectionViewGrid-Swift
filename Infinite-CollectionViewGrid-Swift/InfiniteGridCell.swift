//
//  InfiniteGridCell.swift
//  Infinite-CollectionViewGrid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-20.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit
class InfiniteGridCell: UICollectionViewCell {

    private(set) var coordinates = GridCoordinates(x: 0, y: 0) {
        didSet { coordinatesLabel().text = "\(coordinates.x), \(coordinates.y)" }
    }

    static let identifier = "InfiniteGridCell"
    static func register(with collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: identifier)
    }

    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath,
                        for coordinates: GridCoordinates) -> InfiniteGridCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? InfiniteGridCell ?? InfiniteGridCell()
        cell.coordinates = coordinates
        return cell
    }

    private func coordinatesLabel() -> UILabel {
        if let label = self.contentView.subviews.first as? UILabel {
            return label
        }
        let label = UILabel(frame: self.contentView.bounds)
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        label.translatesAutoresizingMaskIntoConstraints = true
        self.contentView.addSubview(label)
        return label
    }
}
