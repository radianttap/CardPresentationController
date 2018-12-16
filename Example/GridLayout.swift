//
//  GridLayout.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 12/16/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

class GridLayout: BaseGridLayout {
	var numberOfColumns: Int?

	override func prepare() {
		defer {
			super.prepare()
		}
		guard var availableWidth = collectionView?.bounds.width else { return }

		let aspectRatio = itemSize.width / itemSize.height
		let columns: CGFloat
		if let numberOfColumns = numberOfColumns {
			columns = CGFloat(numberOfColumns)
		} else {
			//	customize for CV bounds.width
			columns = floor(availableWidth / itemSize.width)
		}

		availableWidth -= (columns - 1) * minimumInteritemSpacing
		availableWidth -= (sectionInset.left + sectionInset.right)

		itemSize.width = availableWidth / columns
		itemSize.height = itemSize.width * 1/aspectRatio
	}
}
