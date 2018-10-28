//
//  ViewController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 9/15/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
	@IBOutlet private weak var defaultPopupButton: UIButton!
	@IBOutlet private weak var cardPopupButton: UIButton!

	private lazy var transitionManager: CardTransitionManager = CardTransitionManager()
}

private extension ViewController {
	/// Display regular, familiar full screen popup
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupDefault(_ sender: UIButton) {
		let vc = PlainPopupController.instantiate()

		//	wrap inside NC
		let nc = UINavigationController(rootViewController: vc)

		present(nc, animated: true) {
			[weak vc] in
			guard let vc = vc else { return }
			//	and add Done button to dismiss the popup
			let bbi = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.dismissPopup))
			var buttonItems = vc.navigationItem.leftBarButtonItems ?? []
			buttonItems.append(bbi)
			vc.navigationItem.leftBarButtonItems = buttonItems
		}
	}

	/// Display popup as inset card
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupCard(_ sender: UIButton) {
		let vc = PlainPopupController.instantiate()

		//	make it custom
		vc.modalPresentationStyle = .custom
		//	so we can use our Card transition
		vc.transitioningDelegate = transitionManager

		present(vc, animated: true, completion: nil)
	}

	/// Dismisses whatever popup is currently shown
	///
	/// - Parameter sender: An UI object that initiated dismissal
	@IBAction func dismissPopup(_ sender: Any) {
		dismiss(animated: true)
	}
}
