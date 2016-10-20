//
//  DiscogsCellContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 20/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import DataContext

class DiscogsCellContext: TableDataCellContext {
	
	var releaseVO:ReleaseVO
	
	init(releaseVO:ReleaseVO, reuseId: String) {
		
		self.releaseVO = releaseVO
		
		super.init(reuseId: reuseId)
	}
}
