//
//  GridCell.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 12/16/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class GridCell: UICollectionViewCell, NibReusableView {
	@IBOutlet private weak var gradient: GradientView!

	private var startColor: UIColor = .darkGray
	private var endColor: UIColor = .orange
}

extension GridCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()

		applyTheme()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with color: ColorPair) {
		startColor = color.start
		endColor = color.end

		applyTheme()
	}
}

private extension GridCell {
	func cleanup() {
	}

	func applyTheme() {
		gradient.direction = .vertical
		gradient.clipsToBounds = true
		gradient.layer.cornerRadius = 6

		gradient.colors = [
			startColor,
			endColor
		]
	}
}
