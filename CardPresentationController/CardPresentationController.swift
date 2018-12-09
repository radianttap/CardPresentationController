//
//  CardPresentationController.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

@available(iOS 11.0, *)
open class CardPresentationController: UIPresentationController {
	//	This is a link to the original UIVC on which presentCard() was called.
	//	(this is populated by CardTransitionManager)
	//	It's used in this file to clean-up CTM instance once dismissal happens.
	weak var sourceController: UIViewController?


	//	Private stuff

	private lazy var handleView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(white: 1, alpha: 0.5)
		view.layer.cornerRadius = 3
		view.alpha = 0
		return view
	}()

	private lazy var handleButton: UIButton = {
		let view = UIButton(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()

	private var handleTopConstraint: NSLayoutConstraint!
	private var tapGR: UITapGestureRecognizer?

	private var usesDismissHandle: Bool {
		return !(presentedViewController is UINavigationController)
	}

	//	MARK:- PresentationController

	open override func presentationTransitionWillBegin() {
		setupDismissHandle()
		super.presentationTransitionWillBegin()
	}

	open override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)

		if !completed {
			return
		}
		showDismissHandle()
	}

	open override func dismissalTransitionDidEnd(_ completed: Bool) {
		super.dismissalTransitionDidEnd(completed)
		if !completed {
			return
		}
		sourceController?.removeCardTransitionManager()
	}

	//	MARK:- Internal

	@objc private func handleTapped(_ sender: UIButton) {
		handleView.alpha = 0
		presentedViewController.dismiss(animated: true)
	}

	private func setupDismissHandle() {
		guard
			usesDismissHandle,
			let containerView = containerView
		else { return }

		containerView.addSubview(handleView)
		handleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
		handleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

		handleTopConstraint = handleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
		handleTopConstraint.isActive = true

		containerView.addSubview(handleButton)
		handleButton.widthAnchor.constraint(equalTo: handleView.widthAnchor).isActive = true
		handleButton.heightAnchor.constraint(equalTo: handleView.widthAnchor).isActive = true
		handleButton.centerYAnchor.constraint(equalTo: handleView.centerYAnchor).isActive = true
		handleButton.centerXAnchor.constraint(equalTo: handleView.centerXAnchor).isActive = true

		handleButton.addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
	}

	private func showDismissHandle() {
		guard
			usesDismissHandle,
			let containerView = containerView
		else { return }

		containerView.bringSubviewToFront(handleView)
		containerView.bringSubviewToFront(handleButton)

		//	assume there's 16pt space at the top, which can be used to fit-in dismiss handle
		//	place in the middle of that space
		if let v = presentedViewController.view {
			handleTopConstraint.constant = v.frame.minY + 8 - handleView.frame.height / 2
		}

		self.handleView.superview?.layoutIfNeeded()
		UIView.animate(withDuration: 0.15) {
			[weak self] in
			guard let self = self else { return }
			self.handleView.alpha = 1
		}
	}
}
