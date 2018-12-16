//
//  GradientView.swift
//  Gradient View
//
//  Created by Sam Soffes on 10/27/09.
//  Copyright (c) 2009-2014 Sam Soffes. All rights reserved.
//

import UIKit

/// Simple view for drawing gradients and borders.
@IBDesignable open class GradientView: UIView {

	// MARK: - Types

	/// The mode of the gradient.
	@objc public enum Mode: Int {
		/// A linear gradient.
		case linear

		/// A radial gradient.
		case radial
	}


	/// The direction of the gradient.
	@objc public enum Direction: Int {
		/// The gradient is vertical.
		case vertical

		/// The gradient is horizontal
		case horizontal
	}


	// MARK: - Properties

	/// An optional array of `UIColor` objects used to draw the gradient. If the value is `nil`, the `backgroundColor`
	/// will be drawn instead of a gradient. The default is `nil`.
	open var colors: [UIColor]? {
		didSet {
			updateGradient()
		}
	}

	/// An array of `UIColor` objects used to draw the dimmed gradient. If the value is `nil`, `colors` will be
	/// converted to grayscale. This will use the same `locations` as `colors`. If length of arrays don't match, bad
	/// things will happen. You must make sure the number of dimmed colors equals the number of regular colors.
	///
	/// The default is `nil`.
	open var dimmedColors: [UIColor]? {
		didSet {
			updateGradient()
		}
	}

	/// Automatically dim gradient colors when prompted by the system (i.e. when an alert is shown).
	///
	/// The default is `true`.
	open var automaticallyDims: Bool = true

	/// An optional array of `CGFloat`s defining the location of each gradient stop.
	///
	/// The gradient stops are specified as values between `0` and `1`. The values must be monotonically increasing. If
	/// `nil`, the stops are spread uniformly across the range.
	///
	/// Defaults to `nil`.
	open var locations: [CGFloat]? {
		didSet {
			updateGradient()
		}
	}

	/// The mode of the gradient. The default is `.Linear`.
	@IBInspectable open var mode: Mode = .linear {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The direction of the gradient. Only valid for the `Mode.Linear` mode. The default is `.Vertical`.
	@IBInspectable open var direction: Direction = .horizontal {
		didSet {
			setNeedsDisplay()
		}
	}

	/// 1px borders will be drawn instead of 1pt borders. The default is `true`.
	@IBInspectable open var drawsThinBorders: Bool = true {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The top border color. The default is `nil`.
	@IBInspectable open var topBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The right border color. The default is `nil`.
	@IBInspectable open var rightBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}

	///  The bottom border color. The default is `nil`.
	@IBInspectable open var bottomBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}

	/// The left border color. The default is `nil`.
	@IBInspectable open var leftBorderColor: UIColor? {
		didSet {
			setNeedsDisplay()
		}
	}


	// MARK: - UIView

	override open func draw(_ rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		let size = bounds.size

		// Gradient
		if let gradient = gradient {
			let options: CGGradientDrawingOptions = [.drawsAfterEndLocation]

			if mode == .linear {
				let startPoint = CGPoint.zero
				let endPoint = direction == .vertical ? CGPoint(x: 0, y: size.height) : CGPoint(x: size.width, y: 0)
				context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
			} else {
				let center = CGPoint(x: bounds.midX, y: bounds.midY)
				context?.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: min(size.width, size.height) / 2, options: options)
			}
		}

		let screen: UIScreen = window?.screen ?? UIScreen.main
		let borderWidth: CGFloat = drawsThinBorders ? 1.0 / screen.scale : 1.0

		// Top border
		if let color = topBorderColor {
			context?.setFillColor(color.cgColor)
			context?.fill(CGRect(x: 0, y: 0, width: size.width, height: borderWidth))
		}

		let sideY: CGFloat = topBorderColor != nil ? borderWidth : 0
		let sideHeight: CGFloat = size.height - sideY - (bottomBorderColor != nil ? borderWidth : 0)

		// Right border
		if let color = rightBorderColor {
			context?.setFillColor(color.cgColor)
			context?.fill(CGRect(x: size.width - borderWidth, y: sideY, width: borderWidth, height: sideHeight))
		}

		// Bottom border
		if let color = bottomBorderColor {
			context?.setFillColor(color.cgColor)
			context?.fill(CGRect(x: 0, y: size.height - borderWidth, width: size.width, height: borderWidth))
		}

		// Left border
		if let color = leftBorderColor {
			context?.setFillColor(color.cgColor)
			context?.fill(CGRect(x: 0, y: sideY, width: borderWidth, height: sideHeight))
		}
	}

	override open func tintColorDidChange() {
		super.tintColorDidChange()

		if automaticallyDims {
			updateGradient()
		}
	}

	override open func didMoveToWindow() {
		super.didMoveToWindow()
		contentMode = .redraw
	}


	// MARK: - Private

	fileprivate var gradient: CGGradient?

	fileprivate func updateGradient() {
		gradient = nil
		setNeedsDisplay()

		let colors = gradientColors()
		if let colors = colors {
			let colorSpace = CGColorSpaceCreateDeviceRGB()
			let colorSpaceModel = colorSpace.model

			let gradientColors: [CGColor] = colors.compactMap { (color: UIColor) -> CGColor? in
				let cgColor = color.cgColor
				let cgColorSpace = cgColor.colorSpace ?? colorSpace

				// The color's color space is RGB, simply add it.
				if cgColorSpace.model == colorSpaceModel {
					return cgColor
				}

				// Convert to RGB. There may be a more efficient way to do this.
				var red: CGFloat = 0
				var blue: CGFloat = 0
				var green: CGFloat = 0
				var alpha: CGFloat = 0
				color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
				return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
			}

			gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)
		}
	}

	fileprivate func gradientColors() -> [UIColor]? {
		if tintAdjustmentMode == .dimmed {
			if let dimmedColors = dimmedColors {
				return dimmedColors
			}

			if automaticallyDims {
				if let colors = colors {
					return colors.map {
						var hue: CGFloat = 0
						var brightness: CGFloat = 0
						var alpha: CGFloat = 0

						$0.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)

						return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
					}
				}
			}
		}

		return colors
	}
}
