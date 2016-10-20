//
//  TableDataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class TableDataContext: DataContext {

	open var headerContext:TableDataHeaderContext?
	open var footerContext:TableDataHeaderContext?
	open var sectionContext:[TableDataSectionContext]

	public override init() {
		
		self.sectionContext = []
		
		super.init()
	}
	
	
	public override init(transport:DataTransport?) {
		
		self.sectionContext = []
		
		super.init(transport: transport)
	}
	
	public init(headerContext:TableDataHeaderContext?, footerContext:TableDataHeaderContext?, sectionContext:[TableDataSectionContext]) {
		
		self.sectionContext = sectionContext
		
		super.init()
		
		self.headerContext = headerContext
		self.footerContext = footerContext
	}
	
	public init(transport:DataTransport?, headerContext:TableDataHeaderContext?, footerContext:TableDataHeaderContext?, sectionContext:[TableDataSectionContext]) {
		
		self.sectionContext = sectionContext
		
		super.init()
		
		self.transport = transport
		self.headerContext = headerContext
		self.footerContext = footerContext
	}
	
	open func uniqueHeaderIds() -> [String] {
		
		var cellids:Array<String> = []
		
		for section in self.sectionContext {
			
			if let hcontext = section.headerContext {
				
				let cellid = hcontext.reuseId
				
				if let _ = cellids.index(of: cellid) {
					continue
				} else {
					cellids.append(cellid)
				}
			}
		}
		
		return cellids
	}
	
	open func uniqueFooterIds() -> [String] {
		
		var cellids:[String] = []
		
		for section in self.sectionContext {
			
			if let fcontext = section.footerContext {
				
				let cellid = fcontext.reuseId
				
				if let _ = cellids.index(of: cellid) {
					continue
				} else {
					cellids.append(cellid)
				}
			}
		}
		
		return cellids
	}
	
	open func uniqueCellIds() -> [String] {
		
		var cellids:[String] = []
		
		for section in self.sectionContext {
			
			for cell in section.rowContext {
				
				let cellid = cell.reuseId
				
				if let _ = cellids.index(of: cellid) {
					continue
				} else {
					cellids.append(cellid)
				}
			}
		}
		
		return cellids
	}
	
}
