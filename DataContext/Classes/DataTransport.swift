//
//  DataTransport.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class DataTransport: NSObject {
	
	public typealias ActionCallback = ((DataResponseContext?) -> Void)
	public typealias TransportCallback = ((Any?) -> Void)

	public typealias ActionID = String
	
	// need override for real fetch data
	open func doAction(requestContext: DataRequestContext<DataResponseContext>, callback: @escaping ActionCallback) {

		self.responder(requestContext: requestContext, callback: callback)(nil)
	}
	
	func responder(requestContext: DataRequestContext<DataResponseContext>, callback: @escaping ActionCallback) -> TransportCallback {
	
		return { (result:Any?) in
			
			callback(requestContext.responseType.init(request: requestContext, result: result))
		}
	}
}
