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
	
	open func requestyy(_ task:URLSessionDataTask) -> ActionID {
		
		let requestID = UUID().uuidString
		self.tasksQueue[requestID] = task
		task.resume()
		return requestID
	}
}
