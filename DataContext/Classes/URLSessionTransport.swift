//
//  URLSessionTransport.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 18/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class URLSessionTransport: DataTransport {

	fileprivate var tasksQueue:[String:URLSessionDataTask] = [:]
	
	open class var shared: URLSessionTransport {
		struct Singleton { static let instance = URLSessionTransport() }
		return Singleton.instance
	}
	
	open var session: URLSession {
		return URLSession.shared
	}
	
	open override func doAction(requestContext: DataRequestContext<DataResponseContext>, callback: @escaping ActionCallback) {
		
		let urlRequest = requestContext as! URLRequestContext
		
		self._makeDataRequest(urlRequest.toURLRequest(), callback: self.responder(requestContext: requestContext, callback: callback))
	}
	
	@discardableResult
	fileprivate func _makeDataRequest(_ request: URLRequest, callback: @escaping TransportCallback) -> String {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let task = self.session.dataTask(with: request) { data, response, error in
			
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			callback(data)
		}
		
		return self.requestyy(task)
	}

	
	open func requestyy(_ task:URLSessionDataTask) -> ActionID {
		
		let requestID = UUID().uuidString
		self.tasksQueue[requestID] = task
		task.resume()
		return requestID
	}
}
