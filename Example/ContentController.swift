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

	@IBOutlet private weak var messageLabel: UILabel!
	@IBOutlet private weak var popupButton: UIButton!

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}


	//	Data source

	private var message: String?


	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		messageLabel.text = nil
		processContext()
		populateMessage()
	}

	func message(_ s: String) {
		self.message = s
		if !isViewLoaded { return }
		populateMessage()
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

	func populateMessage() {
		messageLabel.text = message
	}

	@IBAction func popup(_ sender: UIButton) {
		let vc = ContentController.instantiate()

		presentCard(vc,
					animated: true)
	}
}



























































extension ContentController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if countOfPresentingParents == 4 {
			popupButton.setTitle("Ehm, it's enough, don't you think?", for: .normal)
			popupButton.isUserInteractionEnabled = false
			popupButton.alpha = 0.6
		}
	}
}

fileprivate extension UIViewController {
	var countOfPresentingParents: Int {
		var c = 0
		if let vc = self.presentingViewController {
			c = 1 + vc.countOfPresentingParents
		}
		return c
	}
}
