//
//  CollectionDataContext.swift
//  CoinfoxApp
//
//  Created by Vladimir Pirogov on 09/01/17.
//  Copyright © 2017 Coinfox. All rights reserved.
//

import Foundation

open class CollectionDataContext: DataContext {
	
	open var emptyContext: CollectionDataLeafContext?
	open var sectionContext: [CollectionDataSectionContext]
	
	public override init() {
		
		self.sectionContext = []
		
		super.init()
	}
	
	
	public override init(transport: DataTransport?) {
		
		self.sectionContext = []
		
		super.init(transport: transport)
	}
	
	public init(sectionContext: [CollectionDataSectionContext]) {
		
		self.sectionContext = sectionContext
		
		super.init()
	}
	
	public init(transport: DataTransport?, sectionContext: [CollectionDataSectionContext]) {
		
		self.sectionContext = sectionContext
		
		super.init()
		
		self.transport = transport
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
