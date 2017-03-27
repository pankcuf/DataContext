//
//  CollectionViewUpdateContext.swift
//  CoinfoxApp
//
//  Created by Vladimir Pirogov on 10/01/17.
//  Copyright © 2017 Coinfox. All rights reserved.
//

import Foundation

open class CollectionViewUpdateContext: ViewUpdateContext {
	
	open var sectionsUpdates: [CollectionViewSectionUpdateContext]?
	
	override public init() {
		// empty
		super.init()
	}
	
	public init(sectionsUpdates: [CollectionViewSectionUpdateContext]?) {
		
		super.init()
		
		self.sectionsUpdates = sectionsUpdates
	}
	
}
