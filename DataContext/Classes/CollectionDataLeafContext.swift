//
//  CollectionDataLeafContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 10/01/17.
//  Copyright © 2017 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class CollectionDataLeafContext: DataLeafContext {
	
	open func getDefaultSize() -> CGSize {
		
		return CGSize(width: 30.0, height: 30.0)
	}
}
