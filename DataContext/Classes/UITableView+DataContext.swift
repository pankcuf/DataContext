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

open class TableDataContextImpl: NSObject, UITableViewDataSource, UITableViewDelegate {

	/// Table Delegates
	
	@objc(tableView:heightForRowAtIndexPath:) open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let ctx = tableView.tableView(tableView, contextForRowAt: indexPath)
		
		return ctx?.getDefaultHeight() ?? 0
	}
	
	@objc(tableView:estimatedHeightForRowAtIndexPath:) open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let ctx = tableView.tableView(tableView, contextForRowAt: indexPath)
		
		return ctx?.getDefaultHeight() ?? 0
	}
	
	@objc(tableView:willDisplayCell:forRowAtIndexPath:) open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard self.tableView(tableView, heightForRowAt: indexPath) != UITableViewAutomaticDimension else { return }
		
		cell.context = tableView.tableView(tableView, contextForRowAt: indexPath)
		cell.contextDelegate = tableView
	}
	
	open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		guard let headerSectionContext = tableView.tableView(tableView, contextFor: section)?.headerContext,
			headerSectionContext.getDefaultHeight() != UITableViewAutomaticDimension else { return }
		
		view.context = headerSectionContext
		view.contextDelegate = tableView
	}
	
	open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		guard let footerSectionContext = tableView.tableView(tableView, contextFor: section)?.footerContext,
			footerSectionContext.getDefaultHeight() != UITableViewAutomaticDimension else { return }
		
		view.context = footerSectionContext
		view.contextDelegate = tableView
	}
	
	@objc(numberOfSectionsInTableView:) open func numberOfSections(in tableView: UITableView) -> Int {
		
		return tableView.tableDataContext()?.sectionContext.count ?? 0
	}
	
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return tableView.tableView(tableView, contextFor: section)?.rowContext.count ?? 0
	}
	
	@objc(tableView:cellForRowAtIndexPath:) open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let section = indexPath.section
		let row = indexPath.row
		
		let ctx = tableView.tableView(tableView, contextFor: section)!
		
		let rows = ctx.rowContext
		
		let cellContext = rows[row]
		
		let reuseId = cellContext.reuseId
		
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)!
		
		if self.tableView(tableView, heightForRowAt: indexPath) == UITableViewAutomaticDimension {
			
			cell.context = tableView.tableView(tableView, contextForRowAt: indexPath)
			cell.contextDelegate = tableView
			cell.contentView.setNeedsLayout()
			cell.contentView.layoutIfNeeded()
		}
		
		return cell
	}
	
	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if let headerSectionContext = tableView.tableView(tableView, contextFor: section)?.headerContext {
			
			if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerSectionContext.reuseId) {
				
				if self.tableView(tableView, heightForHeaderInSection: section) == UITableViewAutomaticDimension {
					
					header.context = headerSectionContext
					header.contextDelegate = tableView
					header.contentView.setNeedsLayout()
					header.contentView.layoutIfNeeded()
				}
				
				return header
			}
		}
		
		return nil
	}
	
	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		if let footerSectionContext = tableView.tableView(tableView, contextFor: section)?.footerContext {
			
			if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerSectionContext.reuseId) {
				
				if self.tableView(tableView, heightForFooterInSection: section) == UITableViewAutomaticDimension {
					
					footer.context = footerSectionContext
					footer.contextDelegate = tableView
					footer.contentView.setNeedsLayout()
					footer.contentView.layoutIfNeeded()
				}
				
				return footer
			}
		}
		
		return nil
	}
	
	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return tableView.tableView(tableView, contextFor: section)?.headerContext?.getDefaultHeight() ?? 0
	}
	
	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return tableView.tableView(tableView, contextFor: section)?.footerContext?.getDefaultHeight() ?? 0
	}
	
}
