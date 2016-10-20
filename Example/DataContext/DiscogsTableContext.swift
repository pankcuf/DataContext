//
//  DiscogsTableContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 19/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import DataContext

class DiscogsTableContext: TableDataContext {
	
	fileprivate var headerReuseId:String!
	fileprivate var cellReuseId:String!

	override init(transport: DataTransport?) {
		
		super.init(transport: transport)
		
		self.headerReuseId = "MatchesDaySectionHeaderView"
		self.cellReuseId = "DiscogsTableViewCell"
	}

	override func uniqueCellIds() -> [String] {
		return [self.cellReuseId]
	}
	
	override func uniqueHeaderIds() -> [String] {
		return [self.headerReuseId]
	}

	override func update(_ response: DataResponseContext?) -> ViewUpdateContext? {
		
		if let parsedResponse = response as? DiscogsJsonResponse {
			
			if let result = parsedResponse.parse() as? [ReleaseVO] {
				
				self.sectionContext.append(TableDataSectionContext(rowContext: self.createRows(result)))
				
				let sectionUpdate = TableViewSectionUpdateContext(index: IndexSet(integer:0), animationType: .automatic, actionType: .add)
				
				
				return TableViewUpdateContext(sectionsUpdates: [sectionUpdate])
			}
		}
		return nil
	}
	
	func createRows(_ releases:[ReleaseVO]) -> [TableDataCellContext] {
		
		var cells:[TableDataCellContext] = []
		
		for rel in releases {
			cells.append(DiscogsCellContext(releaseVO: rel, reuseId: self.cellReuseId))
		}
		
		return cells
	}
}
