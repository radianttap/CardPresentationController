//
//  CardConfiguration.swift
//  CardPresentationController
//
//  Copyright © 2018 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

///	Simple package for various values defining transition's look & feel.
///
///	Supply it as optional parameter to `presentCard(...)`.
public struct CardConfiguration {
	///	Vertical inset from the top or already shown card
	var verticalSpacing: CGFloat = 16

	///	Leading and trailing inset for the existing (presenting) view when it's being moved to the back
	var horizontalInset: CGFloat = 16

	///	Card has rounded corners, right?
	var cornerRadius: CGFloat = 12

	///	The starting frame position for the card
	var initialTransitionFrame: CGRect?

	///	How much to fade the back card.
	///
	///	Ignored if back card is UINavigationController
	var backFadeAlpha: CGFloat = 0.8

	///	If `true`, a temporary `UIVisualEffectView` with given UIBlurEffect.Style will be installed behind the already existing back card.
	///	This helps prevent noisy content overlap from multiple stacked cards.
	///
	///	Ignored if back card to which it should corresponds to, is actually `UINavigationController`.
	///	Also if `backFadeAlpha is `1.0`.
	var blurredBackViewStyle: UIBlurEffect.Style?

	///	Default initializer, with most suitable values
	init() {}
}

extension CardConfiguration {
	///	Very convenient initializer; supply only those params which are different from default ones.
	public init(verticalSpacing: CGFloat? = nil,
		 horizontalInset: CGFloat? = nil,
		 cornerRadius: CGFloat? = nil,
		 backFadeAlpha: CGFloat? = nil,
		 blurredBackViewStyle: UIBlurEffect.Style? = nil,
		 initialTransitionFrame: CGRect? = nil)
	{
		if let verticalSpacing = verticalSpacing {
			self.verticalSpacing = verticalSpacing
		}

		if let horizontalInset = horizontalInset {
			self.horizontalInset = horizontalInset
		}

		if let cornerRadius = cornerRadius {
			self.cornerRadius = cornerRadius
		}

		if let backFadeAlpha = backFadeAlpha {
			self.backFadeAlpha = backFadeAlpha
		}

		if let blurredBackViewStyle = blurredBackViewStyle {
			self.blurredBackViewStyle = blurredBackViewStyle
		}

		if let initialTransitionFrame = initialTransitionFrame {
			self.initialTransitionFrame = initialTransitionFrame
		}
	}
}
