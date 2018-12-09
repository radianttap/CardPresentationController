//
//  CardAnimator.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

@available(iOS 11.0, *)
final class CardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	enum Direction {
		case presentation
		case dismissal
	}

	//	

	var direction: Direction = .presentation

	lazy var initialTransitionFrame: CGRect = {
		var f: CGRect = .zero
		f.size.width = UIScreen.main.bounds.width
		f.origin.y = UIScreen.main.bounds.height
		return f
	}()

	//	Configuration

	var verticalSpacing: CGFloat = 17
	var horizontalInset: CGFloat = 16
	var topCornerRadius: CGFloat = 12
	var fadeAlpha: CGFloat = 0.8

	//	Local stuff

	private var statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
	private var initialBarStyle: UIBarStyle?

	//	MARK:- UIViewControllerAnimatedTransitioning

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.4
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to),
			let fromView = fromVC.view,
			let toView = toVC.view
		else {
			return
		}
		let containerView = transitionContext.containerView
		let duration = transitionDuration(using: transitionContext)
		let ratio: CGFloat = 0.86

		switch direction {
		case .presentation:
			let fromBeginFrame = transitionContext.initialFrame(for: fromVC)
			let fromEndFrame = fromBeginFrame.inset(by: UIEdgeInsets(top: statusBarFrame.height, left: horizontalInset, bottom: 0, right: horizontalInset))

			let toStartFrame = initialTransitionFrame
			let toBaseFinalFrame = transitionContext.finalFrame(for: toVC)
			let toEndFrame = toBaseFinalFrame.inset(by: UIEdgeInsets(top: statusBarFrame.height + verticalSpacing, left: 0, bottom: 0, right: 0))

			toView.clipsToBounds = true
			toView.frame = toStartFrame
			containerView.addSubview(toView)

			let fromNC = fromVC as? UINavigationController
			initialBarStyle = fromNC?.navigationBar.barStyle

			let pa = UIViewPropertyAnimator(duration: duration, dampingRatio: ratio) {
				[weak self] in
				guard let self = self else { return }

				fromView.frame = fromEndFrame
				toView.frame = toEndFrame
				fromView.cardMaskTopCorners(using: self.topCornerRadius)
				toView.cardMaskTopCorners(using: self.topCornerRadius)

				if let nc = fromVC as? UINavigationController, !nc.isNavigationBarHidden {
					nc.navigationBar.barStyle = .black
				} else {
					fromView.alpha = self.fadeAlpha
				}
			}
			pa.addCompletion {
				[weak self] _ in
				self?.direction = .dismissal

				transitionContext.completeTransition(true)
			}
			pa.startAnimation()

		case .dismissal:
			let fromEndFrame = initialTransitionFrame
			let toEndFrame = transitionContext.finalFrame(for: toVC)

			let pa = UIViewPropertyAnimator(duration: duration, dampingRatio: ratio) {
				[weak self] in

				fromView.cardUnmask()
				toView.cardUnmask()
				fromView.frame = fromEndFrame
				toView.frame = toEndFrame
				toView.alpha = 1
				fromView.alpha = 1

				if
					let nc = toVC as? UINavigationController,
					let barStyle = self?.initialBarStyle
				{
					nc.navigationBar.barStyle = barStyle
				}
			}
			pa.addCompletion {
				[weak self] _ in
				self?.direction = .presentation

				transitionContext.completeTransition(true)
				fromView.removeFromSuperview()
			}
			pa.startAnimation()
			break
		}
	}
}


private extension CardAnimator {

}



private extension UIViewControllerContextTransitioning {
	var fromContentController: UIViewController? {
		guard let topVC = viewController(forKey: .from) else { return nil }
		return recognize(topVC)
	}

	var toContentController: UIViewController? {
		guard let topVC = viewController(forKey: .to) else { return nil }
		return recognize(topVC)
	}

	func recognize(_ vc: UIViewController) -> UIViewController? {
		switch vc {
		case let nc as UINavigationController:
			return nc.topViewController ?? nc

		case let tbc as UITabBarController:
			guard let vc = tbc.selectedViewController else { return tbc }
			return recognize(vc)

		default:
			return vc
		}
	}
}
