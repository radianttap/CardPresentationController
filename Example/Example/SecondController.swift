//
//  SecondController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 12/14/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class SecondController: UIViewController, StoryboardLoadable {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
}

private extension SecondController {
	/// Return to previous VC in the NC stack
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func goBack(_ sender: UIButton) {
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.popViewController(animated: true)
	}

	/// Display popup as inset card
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupCard(_ sender: UIButton) {
		let vc = ContentController.instantiate()

		presentCard(vc,
					animated: true)
	}
}
