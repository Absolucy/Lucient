//
//  PreferencesController.swift
//
//
//  Created by Lucy on 6/21/21.
//

import SwiftUI

class PreferencesController: NomaePreferencesController {
	override var suiView: AnyView {
		get { AnyView(Preferences()) }
		set { super.suiView = newValue }
	}
}
