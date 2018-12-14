//
//  ViewController.swift
//  EmbeddedNCExample
//
//  Created by Aleksandar Vacić on 12/14/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

	private var controller: UIViewController?

	override func viewDidLoad() {
		super.viewDidLoad()

		let vc = ContentController.instantiate()

		let nc = UINavigationController(rootViewController: vc)
		nc.navigationBar.barTintColor = .red
//		nc.setNavigationBarHidden(true, animated: false)
		embed(controller: nc, into: view)
		controller = nc

		vc.message("The issue with this kind of setup is the magic that UIKit applies to safeAreaInsets and extending the navigationBar under status bar. So when you 'extract' views to make them part of transition, all that magic is gone and (sub)views reflow.\n\nNo idea is this fixable on general terms.")
	}
}

