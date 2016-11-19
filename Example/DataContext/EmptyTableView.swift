//
//  EmptyTableView.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 19/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DataContext

class EmptyTableView: UIView {
	
	@IBOutlet weak var label: UILabel!
	
	override func contextDidChange() {
	
		if let ctx = self.context as? DiscogsEmptyContext {
			
			self.label.text = ctx.message
		}
	}
}
