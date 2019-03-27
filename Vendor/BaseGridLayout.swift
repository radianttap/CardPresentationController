//
//  GridLayout.swift
//  Radiant Tap Essentials
//
//  Copyright © 2015 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class BaseGridLayout: UICollectionViewFlowLayout {

	override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}

	override init() {
		super.init()
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	func commonInit() {
		scrollDirection = .vertical
		itemSize = CGSize(width: 120, height: 120)
		headerReferenceSize = .zero
		footerReferenceSize = .zero
		minimumLineSpacing = 0
		minimumInteritemSpacing = 0
		sectionInset = .zero
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		switch scrollDirection {
		case .horizontal:
			return newBounds.height != collectionView?.bounds.height
		case .vertical:
			return newBounds.width != collectionView?.bounds.width
		@unknown default:
			return false
		}
	}

	override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
		let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
		switch scrollDirection {
		case .horizontal:
			context.invalidateFlowLayoutDelegateMetrics = newBounds.height != collectionView?.bounds.height
		case .vertical:
			context.invalidateFlowLayoutDelegateMetrics = newBounds.width != collectionView?.bounds.width
		@unknown default:
			break
		}
		return context
	}
}
