//
//  DiscogsEmptyContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 19/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import DataContext

class DiscogsEmptyContext: TableDataEmptyContext {
	
	var message:String
	
	init(message: String) {
		
		self.message = message
		
		super.init(reuseId: "EmptyTableView")
	}
}
