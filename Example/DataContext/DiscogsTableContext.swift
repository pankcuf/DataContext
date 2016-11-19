//
//  DiscogsTableContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 19/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import DataContext

class DiscogsTableContext: TableDataContext {
	
	fileprivate var cellReuseId:String!

	override init(transport: DataTransport?) {
		
		super.init(transport: transport)
		
		self.cellReuseId = "DiscogsTableViewCell"
		self.emptyContext = DiscogsEmptyContext(message: "Sorry. There's no releases!")
	}

	override func uniqueCellIds() -> [String] {
		return [self.cellReuseId]
	}
	
	override func update(_ response: DataResponseContext?) -> ViewUpdateContext? {
		
		if let parsedResponse = response as? DiscogsJsonResponse {
			
			if let result = parsedResponse.parse() as? [ReleaseVO] {
				
				self.sectionContext.append(TableDataSectionContext(rowContext: self.createRows(result)))
				
				let sectionUpdate = TableViewSectionUpdateContext(index: 0, animationType: .automatic, actionType: .add)
				
				return TableViewUpdateContext(sectionsUpdates: [sectionUpdate])
			}
		}
		return TableViewUpdateContext()
	}
	
	func createRows(_ releases:[ReleaseVO]) -> [TableDataCellContext] {
		
		var cells:[TableDataCellContext] = []
		
		for rel in releases {
			cells.append(DiscogsCellContext(releaseVO: rel, reuseId: self.cellReuseId))
		}
		
		return cells
	}
}
