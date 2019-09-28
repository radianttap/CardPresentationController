//
//  UIKit-CardPresentationExtensions.swift
//  CardPresentationController
//
//  Created by Aleksandar Vacić on 12/8/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

extension UIViewController {
	private struct AssociatedKeys {
		static var cardTransitionManager = "CardTransitionManager"
	}
	private(set) var cardTransitionManager: CardTransitionManager? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.cardTransitionManager) as? CardTransitionManager
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.cardTransitionManager, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}


	@available(iOS 10.0, *)
	/// Presents given View Controller using custom Card-like modal transition. Think like Apple‘s Music or Wallet apps.
	///
	///	Existing view will slide down and fade a bit and top corners would be rounded.
	///	Presented controller will slide up, over it, slightly below and also with rounder corners.
	///
	/// - Parameters:
	///   - viewControllerToPresent: `UIViewController` instance to present.
	///   - configuration: an instance of `CardConfiguration`. By default it's `nil` which means that defaults will be used.
	///   - flag: Pass `true` to animate the presentation; otherwise, `pass` false.
	///   - completion: The closure to execute after the presentation finishes. This closure has no return value and takes no parameters. You may specify `nil` for this parameter or omit it entirely.
	public func presentCard(_ viewControllerToPresent: UIViewController,
							configuration: CardConfiguration? = nil,
							animated flag: Bool,
							completion: (() -> Void)? = nil)
	{
		if #available(iOS 13, *), CardPresentationController.useSystemPresentationOniOS13 {
			//	if we are on iOS 13, fallback to default system look & behavior
			present(viewControllerToPresent, animated: flag, completion: completion)
		} else {
			//	make it custom
			viewControllerToPresent.modalPresentationStyle = .custom

			//	enforce statusBarStyle preferred by presented UIVC
			viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true

			//	card config, using supplied or default
			let config = configuration ?? CardConfiguration.shared

			//	then build transition manager
			let tm = CardTransitionManager(configuration: config)
			self.cardTransitionManager = tm
			viewControllerToPresent.transitioningDelegate = tm

			present(viewControllerToPresent,
					animated: flag,
					completion: completion)
		}
	}

	func removeCardTransitionManager() {
		cardTransitionManager = nil
	}
}

extension UIView {
	func cardMaskTopCorners(using cornerRadius: CGFloat = 24) {
		clipsToBounds = true

		//	from iOS 11, it's possible to choose which corners are rounded
		if #available(iOS 11.0, *) {
			layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		}

		layer.cornerRadius = cornerRadius
	}

	func cardUnmask() {
		layer.cornerRadius = 0
	}
}
