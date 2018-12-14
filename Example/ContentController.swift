//
//  PlainPopupController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 10/28/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class ContentController: UIViewController, StoryboardLoadable {
	//	Configuration

	enum Context {
		case popup
		case embed
	}
	var context: Context = .popup {
		didSet {
			if !isViewLoaded { return }
			processContext()
		}
	}


	//	UI

	@IBOutlet private weak var popupButton: UIButton!

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}


	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		processContext()
	}
}

private extension ContentController {
	func processContext() {
		switch context {
		case .embed:
			popupButton.isHidden = true
		case .popup:
			popupButton.isHidden = false
		}
	}

	@IBAction func popup(_ sender: UIButton) {
		let vc = ContentController.instantiate()
		presentCard(vc, animated: true)
	}
}



























































extension ContentController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)


	}
}
