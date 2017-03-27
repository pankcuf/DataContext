//
//  CollectionViewSectionUpdateContext.swift
//  CoinfoxApp
//
//  Created by Vladimir Pirogov on 10/01/17.
//  Copyright © 2017 Coinfox. All rights reserved.
//

import Foundation
import UIKit

open class CollectionViewSectionUpdateContext: NSObject {
	
	public enum Action {
		case add
		case change
		case remove
	}
	
	open var index: Int
	open var actionType: Action
	
	public init(index: Int, actionType: Action) {
		
		self.index = index
		self.actionType = actionType
		
		super.init()
	}
	
}
