//
//  DataResponseContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class DataResponseContext: NSObject {
	
	public var request:DataRequestContext<DataResponseContext>?
	public var result:Any?
	
	public required init(request:DataRequestContext<DataResponseContext>?, result:Any?) {
		
		super.init()
		
		self.request = request
		self.result = result
	}
	
	open func parse() -> Any? {
		return self.result
	}
	
}
