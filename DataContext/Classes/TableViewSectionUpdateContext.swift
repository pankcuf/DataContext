//
//  TableViewSectionUpdateContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

open class TableViewSectionUpdateContext: NSObject {
	
	public enum Action {
		case add
		case change
		case remove
	}
	
	open var index:IndexSet
	open var animationType:UITableViewRowAnimation
	open var actionType:Action
	
	public init(index:IndexSet, animationType:UITableViewRowAnimation, actionType:Action) {
		
		self.index = index
		self.animationType = animationType
		self.actionType = actionType
		
		super.init()
	}

}
