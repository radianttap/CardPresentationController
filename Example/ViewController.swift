//
//  ViewController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 9/15/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
	@IBOutlet private weak var defaultPopupButton: UIButton!
	@IBOutlet private weak var cardPopupButton: UIButton!

}

private extension ViewController {
	@IBAction func popupDefault(_ sender: UIButton) {
		let vc = PlainPopupController.instantiate()
		present(vc, animated: true, completion: nil)
	}

	@IBAction func popupCard(_ sender: UIButton) {

	}
}
