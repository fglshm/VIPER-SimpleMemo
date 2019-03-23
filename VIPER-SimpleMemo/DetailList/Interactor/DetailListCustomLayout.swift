//
//  DetailListCustomLayout.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/22.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import UIKit

class DetailListCustomCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate let numberOfColumns = 3
    fileprivate let cellPadding = 3
    fileprivate let cellHeight = 150
    weak var delegate: DetailListCustomCollectionViewDelegate?
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsets = [CGFloat]()
        for column in 0..<numberOfColumns {
            if column == 0 {
                xOffsets.append(0)
            }
            if column == 1 {
                xOffsets.append(columnWidth * 2)
            }
            if column == 2 {
                xOffsets.append(columnWidth * 3)
            }
        }
        var column = 0
        var yOffsets = [CGFloat]()
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            for column in 0..<numberOfColumns {
                switch column {
                case 0:
                    yOffsets.append(CGFloat(cellPadding * 2))
                case 1:
                    yOffsets.append(CGFloat(cellPadding * 2))
                case 2:
                    yOffsets.append(CGFloat(cellPadding + cellHeight))
                default:
                    break
                }
            }
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: columnWidth)
            let insetFrame = frame.insetBy(dx: CGFloat(cellPadding), dy: CGFloat(cellPadding))
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            contentHeight = max(collectionView.frame.height + 10, frame.maxX)
            let height = cellPadding * 2 + cellHeight
            yOffsets[column] = yOffsets[column] + CGFloat(2 * (height - cellPadding))
            let numberOfItems = delegate?.theNumberOfItemsInCollectionView()
            if let numberOfItems = numberOfItems, indexPath.item == numberOfItems - 1 {
                switch column {
                case 0:
                    column = 2
                case 2:
                    column = 0
                case 1:
                    column = 2
                default:
                    return
                }
            } else {
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

protocol DetailListCustomCollectionViewDelegate: class {
    func theNumberOfItemsInCollectionView() -> Int
}

extension DetailListCustomCollectionViewDelegate {
    func heightForContentInItem(at indexPath: IndexPath) -> CGFloat {
        return 0
    }
}
