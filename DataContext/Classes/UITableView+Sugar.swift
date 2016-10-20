//
//  UITableView+Sugar.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import UIKit

public extension UITableView {

	public func registerCell(_ xibName: String, id:String) {
		self.register(UINib(nibName: xibName, bundle: nil), forCellReuseIdentifier: id)
	}
	
	public func registerHeader(_ xibName: String, id:String) {
		self.register(UINib(nibName: xibName, bundle: nil), forHeaderFooterViewReuseIdentifier: id)
	}
	
	// Same cell reuse id & xib name
	public func cell(_ id:String) {
		self.registerCell(id, id: id)
	}
	
	public func header(_ id:String) {
		self.registerHeader(id, id: id)
	}
	
	// Multiple cell reuse id & xib name
	public func cells(_ ids:[String]) {
		for id in ids {
			self.cell(id)
		}
	}
	
	public func headers(_ ids:[String]) {
		for id in ids {
			self.header(id)
		}
	}

}
