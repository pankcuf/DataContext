//
//  UIView+DataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

extension UIView: DataContextDelegate {
	
	@nonobjc static var CONTEXT_KEY = Int8(0x0000)
	public var context: DataContext? {
		set {
			self.contextWillChange()
			objc_setAssociatedObject(self, &UIView.CONTEXT_KEY, newValue, .OBJC_ASSOCIATION_RETAIN)
			self.contextDidChange()
		}
		get {
			return objc_getAssociatedObject(self, &UIView.CONTEXT_KEY) as? DataContext
		}
	}
	
	@nonobjc static var CONTEXT_DELEGATE_KEY = Int8(0x0001)
	public var contextDelegate: DataContextDelegate? {
		set {
			self.contextDelegateWillChange()
			objc_setAssociatedObject(self, &UIView.CONTEXT_DELEGATE_KEY, newValue, .OBJC_ASSOCIATION_RETAIN)
			self.contextDelegateDidChange()
		}
		get {
			return objc_getAssociatedObject(self, &UIView.CONTEXT_DELEGATE_KEY) as? DataContextDelegate
		}
	}

	public func requestContextUpdates(_ request: DataRequestContext<DataResponseContext>, _ updateCallback:@escaping (() -> ())) {
		
		self.context?.requestUpdate(with: request, callback: { (updateContext: ViewUpdateContext?) in
				self.update(with: updateContext)
				updateCallback()
		})
	}

	public func requestContextUpdates(_ request: DataRequestContext<DataResponseContext>) {
		
		self.context?.requestUpdate(with: request, for: self)
	}
	
	public func updateContext(with response:DataResponseContext?) {
		let updateContext = self.context?.update(response)
		self.update(with: updateContext)
	}
	
	open func contextWillChange() {}
	open func contextDidChange() {}
	
	open func contextDelegateWillChange() {}
	open func contextDelegateDidChange() {}
	
	open func update(with context: ViewUpdateContext?) {}
	
}
