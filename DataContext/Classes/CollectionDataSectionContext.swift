//
//  CollectionDataSectionContext.swift
//  CoinfoxApp
//
//  Created by Vladimir Pirogov on 10/01/17.
//  Copyright © 2017 Coinfox. All rights reserved.
//

import Foundation

open class CollectionDataSectionContext: DataContext {
	
	open var headerContext: CollectionDataLeafContext?
	open var footerContext: CollectionDataLeafContext?
	open var rowContext: [CollectionDataCellContext]
	
	public init(rowContext: [CollectionDataCellContext]) {
		
		self.rowContext = rowContext
		
		super.init()
	}
	
	public init(headerContext: CollectionDataLeafContext?, rowContext: [CollectionDataCellContext]) {
		
		self.rowContext = rowContext
		
		super.init()
		
		self.headerContext = headerContext
	}
	
	public init(headerContext: CollectionDataLeafContext?, footerContext: CollectionDataLeafContext?, rowContext: [CollectionDataCellContext]) {
		
		self.rowContext = rowContext
		
		super.init()
		
		self.headerContext = headerContext
		self.footerContext = footerContext
	}
}
