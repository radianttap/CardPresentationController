//
//  UIKit-CardPresentationExtensions.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 12/8/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

extension UIViewController {
//	@available(iOS 5.0, *)
	open func presentCard(_ viewControllerToPresent: UIViewController,
						  using transitionManager: CardTransitionManager,
						  animated flag: Bool,
						  completion: (() -> Void)? = nil)
	{
		//	make it custom
		viewControllerToPresent.modalPresentationStyle = .custom
		//	so we can use our Card transition
		viewControllerToPresent.transitioningDelegate = transitionManager

		present(viewControllerToPresent,
				animated: flag,
				completion: completion)
	}

}
