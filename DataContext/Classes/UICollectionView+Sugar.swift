//
//  UICollectionView+Sugar.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 27/03/17.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
	
	public func registerCell(_ xibName: String, id: String) {
		
		let xib = UINib(nibName: xibName, bundle: nil)
		
		self.register(xib, forCellWithReuseIdentifier: id)
	}
	
	public func registerHeader(_ xibName: String, id: String) {
		
		let xib = UINib(nibName: xibName, bundle: nil)
		
		self.register(xib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: id)
	}
	
	public func registerFooter(_ xibName: String, id: String) {
		
		let xib = UINib(nibName: xibName, bundle: nil)
		
		self.register(xib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: id)
	}
	
	// Same cell reuse id & xib name
	public func cell(_ id: String) {
		self.registerCell(id, id: id)
	}
	
	public func header(_ id: String) {
		self.registerHeader(id, id: id)
	}
	
	public func footer(_ id: String) {
		self.registerFooter(id, id: id)
	}
	
	// Multiple cell reuse id & xib name
	public func cells(_ ids: [String]) {
		
		for id in ids { self.cell(id) }
	}
	
	public func headers(_ ids: [String]) {
		
		for id in ids { self.header(id) }
	}
	
	public func footers(_ ids: [String]) {
		
		for id in ids { self.footer(id) }
	}
}
