//
//  UIView+DataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
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

	
	public func requestContextUpdates(_ request: DataRequestContext<DataResponseContext>) {
		
		self.context?.requestUpdate(with: request, for: self)
	}

	
	open func contextWillChange() {}
	open func contextDidChange() {}
	
	open func update(with context:ViewUpdateContext?) {}
	
}
