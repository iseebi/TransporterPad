//
//  DeviceCollectionViewLayout.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/7/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

class DeviceCollectionViewLayout: NSCollectionViewLayout {
    
    let itemSize: CGSize = CGSize(width: 150, height: 250)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override var collectionViewContentSize: NSSize {
        guard let collectionView = self.collectionView
            else { return CGSize.zero }

        let count = collectionView.numberOfItems(inSection: 0)
        let itemWidth = itemSize.width
        let drawWidth = itemWidth * CGFloat(count)
        
        return CGSize(width: drawWidth, height: itemSize.height)
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        guard let collectionView = self.collectionView,
            let superView = collectionView.superview else { return [] }
        
        let count = collectionView.numberOfItems(inSection: 0)
        let areaWidth = superView.bounds.width
        let itemWidth = itemSize.width
        let drawWidth = itemWidth * CGFloat(count)
        
        var layoutAttributes: [NSCollectionViewLayoutAttributes] = []
        var from = 0
        var to = count
        
        if areaWidth <= drawWidth {
            // need slice
            from = max(Int(floor(rect.minX / itemWidth)), 0)
            to = min(Int(ceil(rect.maxX / itemWidth)) + 1, count)
        }
        
        for i in from..<to {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attribute)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView,
            let superView = collectionView.superview else { return nil }

        let count = collectionView.numberOfItems(inSection: 0)
        let areaWidth = superView.bounds.width
        let itemWidth = itemSize.width
        let drawWidth = itemWidth * CGFloat(count)

        if count == 0 { return nil }

        var baseX: CGFloat = 0

        if areaWidth > drawWidth {
            // centering mode
            baseX = (areaWidth - drawWidth) / 2
        }

        let x = baseX + (itemWidth * CGFloat(indexPath.item))
        let itemRect = CGRect(x: x, y: 0, width: itemSize.width, height: itemSize.height)

        let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
        attributes.frame = itemRect
        attributes.zIndex = indexPath.item

        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return true
    }

    // hack for scroll
    func scrollDirection() -> NSCollectionViewScrollDirection {
        return .horizontal
    }
}
