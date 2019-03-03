//
//  ViewController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 9/15/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit
import CardPresentationController

final class ViewController: UIViewController {
	@IBOutlet private weak var container: UIView!

	//	Embedded

	private var controller: ContentController?

	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		if let gradient = view as? GradientView {
			gradient.direction = .vertical
			gradient.colors = [.gray, .darkGray]
		}

		let vc = ContentController.instantiate()
		vc.context = .embed
		embed(controller: vc, into: container)
		controller = vc
	}
}

private extension ViewController {
	/// Display regular, familiar full screen popup
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupDefault(_ sender: UIButton) {
		let vc = ContentController.instantiate()
		addDismissBarButton(to: vc)

		//	wrap inside NC
		let nc = UINavigationController(rootViewController: vc)

		present(nc,
				animated: true)
	}

	/// Display popup as inset card
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupNavBarCard(_ sender: UIButton) {
		let vc = ContentController.instantiate()
		addDismissBarButton(to: vc)

		//	wrap inside custom NC, so we can enforce statusBarStyle
		let nc = PopupNavigationController(rootViewController: vc)

		presentCard(nc,
					animated: true)
	}

	/// Display custom container with embedded content, as popup card.
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupCustomContainerCard(_ sender: UIButton) {
		let vc = ContentController.instantiate()
		vc.context = .embed

		let cc = CustomContainerController.initial()
		cc.display(vc: vc)

		//	center the dismiss handle inside the reserved area at the top of the container
		let config = CardConfiguration(dismissAreaHeight: cc.edgeInsets.top)

		presentCard(cc,
					configuration: config,
					animated: true)
	}

	/// Expand popup from the arbitrary rect on the screen
	///	(and also collapse down to the same area)
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func expandCard(_ sender: UIButton) {
		let vc = ContentController.instantiate()
		vc.context = .embed

		let f = container.convert(sender.bounds, to: view.window!)
		let config = CardConfiguration(initialTransitionFrame: f)

		presentCard(vc,
					configuration: config,
					animated: true)
	}

	@IBAction func pushNext(_ sender: UIBarButtonItem) {
		let vc = SecondController.instantiate()
		show(vc, sender: self)
	}

	/// Display popup as inset card
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupGrid(_ sender: UIButton) {
		let vc = GridController()

		presentCard(vc,
					animated: true)
	}

	/// Display popup as inset card, with initial vertical inset of 132pt
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupLargeInsetCard(_ sender: UIButton) {
		let vc = ContentController.instantiate()

		let config = CardConfiguration(verticalInset: 132)

		presentCard(vc,
					configuration: config,
					animated: true)
	}
}


fileprivate extension ViewController {
	/// Dismisses whatever popup is currently shown
	///
	/// - Parameter sender: An UI object that initiated dismissal
	@IBAction func dismissPopup(_ sender: Any) {
		dismiss(animated: true)
	}

	func addDismissBarButton(to vc: UIViewController) {
		//	and add Done button to dismiss the popup
		let bbi = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.dismissPopup))
		var buttonItems = vc.navigationItem.leftBarButtonItems ?? []
		buttonItems.append(bbi)
		vc.navigationItem.leftBarButtonItems = buttonItems
	}
}
