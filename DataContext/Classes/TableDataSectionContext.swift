//
//  TableDataSectionContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class TableDataSectionContext: DataContext {
	
	open var headerContext:TableDataHeaderContext?
	open var footerContext:TableDataHeaderContext?
	open var rowContext:[TableDataCellContext]
	
	public init(rowContext:[TableDataCellContext]) {
		
		self.rowContext = rowContext
		
		super.init()
	}

	public init(headerContext:TableDataHeaderContext?, rowContext:[TableDataCellContext]) {
	
		self.rowContext = rowContext

		super.init()
		
		self.headerContext = headerContext
	}
	
	public init(headerContext:TableDataHeaderContext?, footerContext:TableDataHeaderContext?, rowContext:[TableDataCellContext]) {
		
		self.rowContext = rowContext
		
		super.init()
		
		self.headerContext = headerContext
		self.footerContext = footerContext
	}
}
