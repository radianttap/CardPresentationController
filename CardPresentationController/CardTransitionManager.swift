//
//  CardTransitionManager.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

@available(iOS 10.0, *)
public final class CardTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
	private lazy var animator = CardAnimator()

	var initialTransitionFrame: CGRect?

	public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let pc = CardPresentationController(presentedViewController: presented, presenting: presenting)
		pc.sourceController = source
		return pc
	}

	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animator.direction = .presentation

		if let initialTransitionFrame = initialTransitionFrame {
			animator.initialTransitionFrame = initialTransitionFrame
		}
		return animator
	}

	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animator.direction = .dismissal
		return animator
	}
}
