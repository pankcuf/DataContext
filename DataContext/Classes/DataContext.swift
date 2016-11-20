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

	open var transport:DataTransport?
	
	open var isUpdating:Bool = false

	public override init() {
		
		super.init()
	}
	
	public init(transport:DataTransport?) {
		
		super.init()
		
		self.transport = transport
	}

	open func requestUpdate(with request:DataRequestContext<DataResponseContext>, callback: @escaping ViewCallback) {
	
		self.isUpdating = true

		self.transport?.doAction(requestContext: request, callback: { (response:DataResponseContext?) in
			
			DispatchQueue.main.async {
				
				self.isUpdating = false
				let updateContext = self.update(response)
				callback(updateContext)
			}
		})
	}
	
	open func requestUpdate(with request:DataRequestContext<DataResponseContext>, for view:UIView) {
		
		self.requestUpdate(with: request) { (updateContext:ViewUpdateContext?) in
			view.update(with: updateContext)
		}
	}
	
	open func update(_ response:DataResponseContext?) -> ViewUpdateContext? {
		return ViewUpdateContext()
	}
	
}
