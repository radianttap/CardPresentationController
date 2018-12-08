//
//  CardTransitionManager.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

public final class CardTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
	private lazy var animator = CardAnimator()

	public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let pc = CardPresentationController(presentedViewController: presented, presenting: presenting)
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
