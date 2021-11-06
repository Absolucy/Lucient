//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

class PreferencesController: UIHostingController<Preferences> {
	override init(nibName _: String?,
	              bundle _: Bundle?)
	{
		super.init(rootView: Preferences())
		navigationItem.largeTitleDisplayMode = .never
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("stfu xcode")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.isOpaque = true
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.view.backgroundColor = .systemBackground
	}

	@objc var parentController: Any?
	@objc var rootController: Any?
	@objc var specifier: Any?
}
