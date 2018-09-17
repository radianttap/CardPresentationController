//
//  CardTransitionManager.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class CardTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
	private lazy var animator = CardAnimator()

	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let pc = CardPresentationController(presentedViewController: presented, presenting: presenting)
		return pc
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return animator
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return animator
	}
}
