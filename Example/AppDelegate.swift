//
//  AppDelegate.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 9/15/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit
import CardPresentationController

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		applyTheme()
		return true
	}

}

private extension AppDelegate {
	func applyTheme() {
		//	Example of globally changing every card in the app
		//	
		//	(uncomment to see it in action)
		CardConfiguration.shared = CardConfiguration(verticalSpacing: 8,
													 horizontalInset: 8,
													 cornerRadius: 0,
													 backFadeAlpha: 0.5)
	}
}
