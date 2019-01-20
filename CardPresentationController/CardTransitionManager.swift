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
	public private(set) var configuration: CardConfiguration

	init(configuration: CardConfiguration) {
		self.configuration = configuration
		super.init()
	}

	private lazy var animator = CardAnimator(configuration: configuration)

	public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let pc = CardPresentationController(configuration: configuration, presentedViewController: presented, presenting: presenting)
		pc.sourceController = source
		pc.cardAnimator = animator
		return pc
	}

	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animator.direction = .presentation
		return animator
	}

	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animator.direction = .dismissal
		return animator
	}
}
