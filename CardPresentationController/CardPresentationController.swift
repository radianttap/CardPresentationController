//
//  CardPresentationController.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

@available(iOS 10.0, *)
public class CardPresentationController: UIPresentationController {
	public static var useSystemPresentationOniOS13 = true

	///	This is a link to the original UIVC on which presentCard() was called.
	///	(this is populated by CardTransitionManager)
	///	It's used in this file to clean-up CTM instance once dismissal happens.
	weak var sourceController: UIViewController?

	///	Required link to the actual animator,
	///	so that pan gesture handler can drive the animation
	weak var cardAnimator: CardAnimator!

	///	How much space is available at the top of the presentedView (card) to draw the dismiss glyph (handle).
	///
	///	By default, it's assumed it's 16pt and handle will be 5pt tall, centered in the middle of that area
	///	(thus effectivelly its center is 8pt from the top of the card).
	var dismissAreaHeight: CGFloat = 16



	//	Init

	public private(set) var configuration: CardConfiguration

	public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		fatalError("Use init(configuration:presentedViewController:presenting:)")
	}

	public init(configuration: CardConfiguration, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		self.configuration = configuration
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
	}

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

	private var usesDismissHandle: Bool {
		return !(presentedViewController is UINavigationController)
	}

	//	MARK:- PresentationController

	public override func presentationTransitionWillBegin() {
		setupDismissHandle()

		super.presentationTransitionWillBegin()
	}

	public override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)

		if !completed {
			return
		}
		showDismissHandle()
		setupPanToDismiss()
	}

	public override func dismissalTransitionWillBegin() {
		fadeoutHandle()
		super.dismissalTransitionWillBegin()
	}

	public override func dismissalTransitionDidEnd(_ completed: Bool) {
		super.dismissalTransitionDidEnd(completed)
		if !completed {
			return
		}
		sourceController?.removeCardTransitionManager()
	}

	//	MARK:- Public

	func fadeinHandle() {
		UIView.animate(withDuration: 0.15) {
			[weak self] in
			guard let self = self else { return }
			self.handleView.alpha = 1
		}
	}

	func fadeoutHandle() {
		UIView.animate(withDuration: 0.15) {
			[weak self] in
			guard let self = self else { return }
			self.handleView.alpha = 0
		}
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

		//	Center dismiss handle in the (hopefully empty) area at the top of the presented card.
		//	Place in the middle of that space.
		if let v = presentedViewController.view {
			let handleCenterY = v.frame.minY + dismissAreaHeight / 2
			handleTopConstraint.constant = handleCenterY - handleView.frame.height / 2
		}

		self.handleView.superview?.layoutIfNeeded()
		self.fadeinHandle()
	}

	//	MARK:- Pan to dismiss

	private var panGR: UIPanGestureRecognizer?
	private var hasStartedPan = false

	private func setupPanToDismiss() {
		if !configuration.allowInteractiveDismissal { return }

		let gr = UIPanGestureRecognizer(target: self, action: #selector(panned))
		gr.delegate = self

		containerView?.addGestureRecognizer(gr)
		panGR = gr
	}

	@objc private func panned(_ gr: UIPanGestureRecognizer) {
		guard let containerView = containerView else { return }

		let verticalMove = gr.translation(in: containerView).y
		let pct = verticalMove / containerView.bounds.height
		let verticalVelocity = gr.velocity(in: containerView)

		switch gr.state {
		case .began:
			//	do not start dismiss until pan goes down
			if verticalMove <= 0 { return }
			//	setup flag that pan has finally started in the correct direction
			hasStartedPan = true
			//	and reset the movement so far
			gr.setTranslation(.zero, in: containerView)

			//	tell Animator that this will be interactive
			cardAnimator.isInteractive = true

			//	and then initiate dismissal
			presentedViewController.dismiss(animated: true)

		case .changed:
			if !hasStartedPan { return }
			cardAnimator.updateInteractiveTransition(pct)
			//			handleView.alpha = max(0, 1 - pct * 4)	//	handle disappears 4x faster

		case .ended, .cancelled:
			if !hasStartedPan { return }
			let vector = verticalVelocity.vector

			if verticalVelocity.y < 0 {
				cardAnimator.cancelInteractiveTransition(with: vector)
				handleView.alpha = 1

			} else if verticalVelocity.y > 0 {
				cardAnimator.finishInteractiveTransition(with: vector)
				handleView.alpha = 0

			} else {
				if pct < 0.5 {
					cardAnimator.cancelInteractiveTransition(with: vector)
					handleView.alpha = 1
				} else {
					cardAnimator.finishInteractiveTransition(with: vector)
					handleView.alpha = 0
				}
			}
			hasStartedPan = false

		default:
			break
		}
	}
}

extension CardPresentationController: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
								  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
	{
		if gestureRecognizer != panGR { return true }

		let otherView = otherGestureRecognizer.view

		//	allow unconditional panning if that other view is not `UIScrollView`
		guard let scrollView = otherView as? UIScrollView else {
			return true
		}

		//	if it is `UIScrollView`,
		//	allow panning only if its content is at the very top
		if (scrollView.contentOffset.y + scrollView.contentInset.top) == 0 {
			return true
		}

		//	otherwise, disallow pan to dismiss
		return false
	}
}

private extension CGPoint {
	var vector: CGVector {
		return CGVector(dx: x, dy: y)
	}
}

