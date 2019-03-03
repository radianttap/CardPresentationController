//
//  CustomContainerController.swift
//  CardModal
//
//  Created by Aleksandar Vacić on 3/3/19.
//  Copyright © 2019 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class CustomContainerController: UIViewController, StoryboardLoadable {
	//	UI

	@IBOutlet private var containingView: UIView!


	//	Public

	private(set) var embeddedController: UIViewController?

	private(set) var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 44, left: 16, bottom: 16, right: 16)

	func display(vc: UIViewController) {
		embeddedController = vc
		if !isViewLoaded { return }
		embedIfNeeded()
	}

	func clear(vc: UIViewController?) {
		unembed(controller: vc)
		embeddedController = nil
	}







	//	UIKit

	override func viewDidLoad() {
		super.viewDidLoad()

		embedIfNeeded()
	}

	private func embedIfNeeded() {
		guard let vc = embeddedController else { return }
		embed(controller: vc, into: containingView)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
		super.dismiss(animated: flag) {
			[weak self] in

			self?.clear(vc: self?.embeddedController)

			completion?()
		}
	}
}

