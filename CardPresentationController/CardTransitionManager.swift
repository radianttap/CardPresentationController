//
//  CardTransitionManager.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

@available(iOS 10.0, *)
final class CardTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
	private(set) var configuration: CardConfiguration

	init(configuration: CardConfiguration) {
		self.configuration = configuration
		super.init()
	}

	private lazy var cardAnimator = CardAnimator(configuration: configuration)

	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let pc = CardPresentationController(configuration: configuration, presentedViewController: presented, presenting: presenting)
		pc.sourceController = source
		pc.cardAnimator = cardAnimator
		pc.dismissAreaHeight = configuration.dismissAreaHeight
		return pc
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		cardAnimator.direction = .presentation
		return cardAnimator
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		cardAnimator.direction = .dismissal
		return cardAnimator
	}

	func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		if cardAnimator.isInteractive { return cardAnimator }
		return nil
	}

	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		if cardAnimator.isInteractive { return cardAnimator }
		return nil
	}
}
