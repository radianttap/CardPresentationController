//
//  GridController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 12/16/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

typealias ColorPair = (start: UIColor, end: UIColor)

final class GridController: UICollectionViewController {
	init() {
		let layout = GridLayout()
		layout.minimumLineSpacing = 16
		layout.minimumInteritemSpacing = 16
		layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

		super.init(collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var gradients: [ColorPair] = []
}

extension GridController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .darkGray
		collectionView.backgroundColor = view.backgroundColor

		collectionView.register(GridCell.self)
		generateGradients()
	}
}

private extension GridController {
	func generateGradients() {
		for _ in 0 ..< 50 {
			let cp = ColorPair(.random, .random)
			gradients.append(cp)
		}
	}
}

extension GridController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return gradients.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: GridCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		let colorPair = gradients[indexPath.item]
		cell.populate(with: colorPair)
		return cell
	}
}

private extension UIColor {
	static var random: UIColor {
		let random = { CGFloat(arc4random_uniform(255)) / 255.0 }
		return UIColor(red: random(), green: random(), blue: random(), alpha: 1)
	}
}
