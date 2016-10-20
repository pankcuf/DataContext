//
//  TableViewUpdateContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class TableViewUpdateContext: ViewUpdateContext {

	open var sectionsUpdates:[TableViewSectionUpdateContext]?
	
	public init(sectionsUpdates:[TableViewSectionUpdateContext]?) {
		
		super.init()
		
		self.sectionsUpdates = sectionsUpdates
	}

}
