//
//  DataLeafContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class DataLeafContext: DataContext {
	
	open var reuseId:String
	
	public init(reuseId:String) {
		
		self.reuseId = reuseId
		
		super.init()
	}
}
