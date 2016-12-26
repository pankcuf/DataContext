//
//  FakeDataTransport.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 18/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class FakeDataTransport: DataTransport {
	
	var result: Any?
	
	public init(result: Any?) {
		
		self.result = result
	}
	
	override open func doAction(requestContext: DataRequestContext<DataResponseContext>, callback: @escaping DataTransport.ActionCallback) {

		let delay: Double = 0.1
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
			
			self.responder(requestContext: requestContext, callback: callback)(self.result)
		}
	}
}
