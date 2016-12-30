//
//  DataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class DataContext: NSObject {
	
	public typealias ViewCallback = ((ViewUpdateContext?) -> ())

	open var transport: DataTransport?
	
	open var isUpdating: Bool = false

	public override init() {
		
		super.init()
	}
	
	public init(transport: DataTransport?) {
		
		super.init()
		
		self.transport = transport
	}

	open func requestUpdate(with request: DataRequestContext<DataResponseContext>, callback: @escaping ViewCallback) {
	
		self.isUpdating = true

		self.transport?.doAction(requestContext: request) { (response:DataResponseContext?) in
			
			let result = response?.parse()
			
			DispatchQueue.main.async {
				
				self.isUpdating = false
				let updateContext = self.update(result)
				callback(updateContext)
			}
		}
	}
	
	open func requestUpdate(with request: DataRequestContext<DataResponseContext>, for view: UIView) {
		
		self.requestUpdate(with: request) { (updateContext: ViewUpdateContext?) in
			view.update(with: updateContext)
		}
	}
	
	open func update(_ response: Any?) -> ViewUpdateContext? {
		return ViewUpdateContext()
	}
	
}
