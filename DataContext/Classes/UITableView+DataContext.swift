//
//  UITableView+DataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

//Need this feature:
//http://stackoverflow.com/questions/39487168/non-objc-method-does-not-satisfy-optional-requirement-of-objc-protocol/39604189
//https://bugs.swift.org/browse/SR-3349

extension UITableView {

	open override func contextDidChange() {
		
		if let ctx = self.context as? TableDataContext {
			
			self.createEmptyView()
			self.createHeader()
			self.createFooter()
			self.headers(ctx.uniqueHeaderIds())
			self.headers(ctx.uniqueFooterIds())
			self.cells(ctx.uniqueCellIds())
		}
	}
	
	open func createEmptyView() {
		
		if let emptyCtx = self.tableDataContext()?.emptyContext {
			
			self.backgroundView = Bundle.main.loadNibNamed(emptyCtx.reuseId, owner: self, options: nil)?.first as? UIView
		}
	}
	
	open func createHeader() {
		
		if let headerCtx = self.tableDataContext()?.headerContext {
			
			self.tableHeaderView = Bundle.main.loadNibNamed(headerCtx.reuseId, owner: self, options: nil)?.first as? UIView
		}
	}
	
	open func createFooter() {
		
		if let footerCtx = self.tableDataContext()?.footerContext {
			
			self.tableFooterView = Bundle.main.loadNibNamed(footerCtx.reuseId, owner: self, options: nil)?.first as? UIView
		}
	}

	override open func update(with context: ViewUpdateContext?) {
		
		if let tableCtx = context as? TableViewUpdateContext {
			
			self.updateHeaderContext(tableCtx)
			self.updateFooterContext(tableCtx)
			self.updateRowContext(tableCtx)
			self.updateEmptyContext(tableCtx)
		}
	}
	
	open func updateEmptyContext(_ response: TableViewUpdateContext?) {
		
		guard let ctx = self.tableDataContext() else { return }
		
		let hasNoSections = ctx.sectionContext.isEmpty
		
		self.backgroundView?.isHidden = !hasNoSections
		self.backgroundView?.context = ctx.emptyContext
		self.backgroundView?.contextDelegate = self
	}

	open func updateHeaderContext(_ response: TableViewUpdateContext?) {
		
		self.tableHeaderView?.context = self.tableDataContext()?.headerContext
		self.tableHeaderView?.contextDelegate = self
	}
	
	open func updateFooterContext(_ response: TableViewUpdateContext?) {
		
		self.tableFooterView?.context = self.tableDataContext()?.footerContext
		self.tableFooterView?.contextDelegate = self
	}
	
	open func updateRowContext(_ response: TableViewUpdateContext?) {
		
		if let updates = response?.sectionsUpdates {
			
			self.beginUpdates()
			
			for update in updates {
				
				let iset = IndexSet(integer: update.index)
				
				switch update.actionType {
					
				case .add:
					self.insertSections(iset, with: update.animationType)
					break
					
				case .change:
					self.reloadSections(iset, with: update.animationType)
					break
					
				case .remove:
					self.deleteSections(iset, with: update.animationType)
					break
				}
			}
			
			self.endUpdates()
			
		} else {
			
			self.reloadData()
		}
	}

	public func tableDataContext() -> TableDataContext? {
		return self.context as? TableDataContext
	}
	
	open func tableView(_ tableView: UITableView, contextFor section: Int) -> TableDataSectionContext? {
		
		guard let ctx = self.tableDataContext() else { return nil }
		
		let sectionContext = ctx.sectionContext[section]
		
		return sectionContext
	}

	open func tableView(_ tableView: UITableView, contextForRowAt indexPath: IndexPath) -> TableDataCellContext? {
		
		let sectionContext = self.tableView(tableView, contextFor: indexPath.section)
		
		let rowContext = sectionContext?.rowContext[indexPath.row]
		
		return rowContext
	}
}
