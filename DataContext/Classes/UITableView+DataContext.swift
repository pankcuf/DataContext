//
//  UITableView+DataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

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
	
	public func updateEmptyContext(_ response: TableViewUpdateContext?) {
		
		let ctx = self.tableDataContext()
		
		let hasNoSections = ctx?.sectionContext.isEmpty ?? true
		
		self.backgroundView?.isHidden = !hasNoSections
		self.backgroundView?.context = ctx?.emptyContext
	}

	public func updateHeaderContext(_ response: TableViewUpdateContext?) {
		
		self.tableHeaderView?.context = self.tableDataContext()?.headerContext
	}
	
	public func updateFooterContext(_ response: TableViewUpdateContext?) {
		
		self.tableFooterView?.context = self.tableDataContext()?.footerContext
	}
	
	public func updateRowContext(_ response: TableViewUpdateContext?) {
		
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
	
	/// Table Delegates
	
	@objc(tableView:heightForRowAtIndexPath:) open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let ctx = self.tableDataContext()?.sectionContext[indexPath.section].rowContext[indexPath.row]
		return ctx?.getDefaultHeight() ?? UITableViewAutomaticDimension
	}
	
	@objc(tableView:estimatedHeightForRowAtIndexPath:) open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		let ctx = self.tableDataContext()?.sectionContext[indexPath.section].rowContext[indexPath.row]
		return ctx?.getDefaultHeight() ?? UITableViewAutomaticDimension
	}

	@objc(tableView:willDisplayCell:forRowAtIndexPath:) open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		if self.tableView(tableView, heightForRowAt: indexPath) != UITableViewAutomaticDimension {
			cell.context = self.tableDataContext()!.sectionContext[indexPath.section].rowContext[indexPath.row]
		}
	}
	
	open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		if self.tableView(tableView, heightForHeaderInSection: section) != UITableViewAutomaticDimension {
			
			if let headerSectionContext = self.tableDataContext()?.sectionContext[section].headerContext {
			
				view.context = headerSectionContext
			}
		}
	}
	
	open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		if self.tableView(tableView, heightForFooterInSection: section) != UITableViewAutomaticDimension {
			
			if let footerSectionContext = self.tableDataContext()?.sectionContext[section].footerContext {
				
				view.context = footerSectionContext
			}
		}
	}

	@objc(numberOfSectionsInTableView:) open func numberOfSections(in tableView: UITableView) -> Int {
		
		return self.tableDataContext()?.sectionContext.count ?? 0
	}
	
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.tableDataContext()?.sectionContext[section].rowContext.count ?? 0
	}
	
	@objc(tableView:cellForRowAtIndexPath:) open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let section = indexPath.section
		let row = indexPath.row
		
		let rows = self.tableDataContext()!.sectionContext[section].rowContext
		
		let cellContext = rows[row]
		
		let reuseId = cellContext.reuseId
		
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)!
		
		if self.tableView(tableView, heightForRowAt: indexPath) == UITableViewAutomaticDimension {
			
			cell.context = self.tableDataContext()!.sectionContext[indexPath.section].rowContext[indexPath.row]
			cell.contentView.setNeedsLayout()
			cell.contentView.layoutIfNeeded()
		}
		
		return cell
	}
	
	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if let headerSectionContext = self.tableDataContext()?.sectionContext[section].headerContext {
			
			if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerSectionContext.reuseId) {

				if self.tableView(tableView, heightForHeaderInSection: section) == UITableViewAutomaticDimension {
					
					header.context = headerSectionContext
					header.contentView.setNeedsLayout()
					header.contentView.layoutIfNeeded()
				}
				
				return header
			}
		}
		
		return nil
	}
	
	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		if let footerSectionContext = self.tableDataContext()?.sectionContext[section].footerContext {
			
			if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerSectionContext.reuseId) {
				
				if self.tableView(tableView, heightForFooterInSection: section) == UITableViewAutomaticDimension {
					
					footer.context = footerSectionContext
					footer.contentView.setNeedsLayout()
					footer.contentView.layoutIfNeeded()
				}
				
				return footer
			}
		}
		
		return nil
	}
	
	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.tableDataContext()?.sectionContext[section].headerContext?.getDefaultHeight() ?? 0
	}
	
	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return self.tableDataContext()?.sectionContext[section].footerContext?.getDefaultHeight() ?? 0
	}

}
