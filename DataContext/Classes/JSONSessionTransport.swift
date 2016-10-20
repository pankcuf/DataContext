//
//  JSONSessionTransport.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 18/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class JSONSessionTransport: URLSessionTransport {

	override open class var shared: URLSessionTransport {
		struct Singleton { static let instance = JSONSessionTransport() }
		return Singleton.instance
	}
	
	open override func doAction(requestContext: DataRequestContext<DataResponseContext>, callback: @escaping ActionCallback) {
		
		let urlRequest = requestContext as! URLRequestContext
		
		self._makeJSONRequest(urlRequest.toURLRequest(), callback: self.responder(requestContext: requestContext, callback: callback))
	}
	
	@discardableResult
	fileprivate func _makeJSONRequest(_ request: URLRequest, callback: @escaping TransportCallback) -> String {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let task = self.session.dataTask(with: request) { data, response, error in
			
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			var json:Any?
			
			if error == nil {
				do {
					json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				} catch let perror {
					print(perror)
				}
			} else if error?._code == 1007 {
				
			}
			callback(json as AnyObject?)
		}
		
		return self.requestyy(task)
	}
}
