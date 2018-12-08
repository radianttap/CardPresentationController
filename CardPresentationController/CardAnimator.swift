//
//  CardAnimator.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

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

	var spacing: CGFloat = 34
	var topCornerRadius: CGFloat = 20
	var fadeAlpha: CGFloat = 0.8

	//	Local stuff

	private var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
	private var statusBarFrame: CGRect = UIApplication.shared.statusBarFrame

	//	MARK:- UIViewControllerAnimatedTransitioning

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
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
			let fromEndFrame = fromBeginFrame.inset(by: UIEdgeInsets(top: statusBarFrame.height, left: 0, bottom: 0, right: 0))

			let toStartFrame = initialTransitionFrame
			let toBaseFinalFrame = transitionContext.finalFrame(for: toVC)
			let toEndFrame = toBaseFinalFrame.inset(by: UIEdgeInsets(top: statusBarFrame.height + spacing, left: 0, bottom: 0, right: 0))

			toView.clipsToBounds = true
			toView.frame = toStartFrame
			containerView.addSubview(toView)

			let pa = UIViewPropertyAnimator(duration: duration, dampingRatio: ratio) {
				[weak self] in
				guard let self = self else { return }

				fromView.frame = fromEndFrame
				toView.frame = toEndFrame
				fromView.maskTopCard(cornerRadius: self.topCornerRadius)
				toView.maskTopCard(cornerRadius: self.topCornerRadius)
				fromView.alpha = self.fadeAlpha
			}
			pa.addCompletion {
				[weak self] _ in
				transitionContext.completeTransition(true)
				self?.direction = .dismissal
			}
			pa.startAnimation()

		case .dismissal:
			let fromEndFrame = initialTransitionFrame
			let toEndFrame = transitionContext.finalFrame(for: toVC)

			let pa = UIViewPropertyAnimator(duration: duration, dampingRatio: ratio) {
				fromView.maskTopCard(cornerRadius: 0)
				toView.maskTopCard(cornerRadius: 0)
				fromView.frame = fromEndFrame
				toView.frame = toEndFrame
				toView.alpha = 1
				fromView.alpha = 1
			}
			pa.addCompletion {
				[weak self] _ in
				transitionContext.completeTransition(true)
				fromView.removeFromSuperview()
				self?.direction = .presentation
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
