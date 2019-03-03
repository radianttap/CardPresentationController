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
	///	Vertical inset from the top or already shown card.
	public var verticalSpacing: CGFloat = 16

	/// Top vertical inset for the existing (presenting) view when it's being pushed further back.
	public var verticalInset: CGFloat = UIApplication.shared.statusBarFrame.size.height

	///	Leading and trailing inset for the existing (presenting) view when it's being pushed further back.
	public var horizontalInset: CGFloat = 16

	///	Height of the "empty" area at the top of the card where dismiss handle glyph will be centered.
	public var dismissAreaHeight: CGFloat = 16

	///	Cards have rounded corners, right?
	public var cornerRadius: CGFloat = 12

	///	The starting frame for the presented card.
	public var initialTransitionFrame: CGRect?

	///	How much to fade the back card.
	public var backFadeAlpha: CGFloat = 0.8

	///	Set to false to disable interactive dismissal
	public var allowInteractiveDismissal = true

	///	Default initializer, with most suitable values
	init() {}

	///	Common instance of the Configuration, applied to all cards
	///	unless a specific instance is supplied in `presentCard()` call.
	///
	///	Set this value early in your app lifecycle to adjust the look of all cards in your app.
	public static var shared = CardConfiguration()
}

extension CardConfiguration {
	///	Very convenient initializer; supply only those params which are different from default ones.
	public init(verticalSpacing: CGFloat? = nil,
				verticalInset: CGFloat? = nil,
				horizontalInset: CGFloat? = nil,
				dismissAreaHeight: CGFloat? = nil,
				cornerRadius: CGFloat? = nil,
				backFadeAlpha: CGFloat? = nil,
				initialTransitionFrame: CGRect? = nil,
				allowInteractiveDismissal: Bool? = nil)
	{
		if let verticalSpacing = verticalSpacing {
			self.verticalSpacing = verticalSpacing
		}

		if let verticalInset = verticalInset {
			self.verticalInset = verticalInset
		}

		if let horizontalInset = horizontalInset {
			self.horizontalInset = horizontalInset
		}

		if let dismissAreaHeight = dismissAreaHeight {
			self.dismissAreaHeight = dismissAreaHeight
		}

		if let cornerRadius = cornerRadius {
			self.cornerRadius = cornerRadius
		}

		if let backFadeAlpha = backFadeAlpha {
			self.backFadeAlpha = backFadeAlpha
		}

		if let initialTransitionFrame = initialTransitionFrame {
			self.initialTransitionFrame = initialTransitionFrame
		}

		if let allowInteractiveDismissal = allowInteractiveDismissal {
			self.allowInteractiveDismissal = allowInteractiveDismissal
		}
	}
}
