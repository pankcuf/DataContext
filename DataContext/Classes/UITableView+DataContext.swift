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
			
			if let headerCtx = ctx.headerContext {
				
				self.tableHeaderView = Bundle.main.loadNibNamed(headerCtx.reuseId, owner: self, options: nil)?.first as? UIView
				
			} else {
				
				self.tableHeaderView = UIView()
			}
			
			if let footerCtx = ctx.footerContext {
				
				self.tableFooterView = Bundle.main.loadNibNamed(footerCtx.reuseId, owner: self, options: nil)?.first as? UIView
				
			} else {
				
				self.tableFooterView = UIView()
			}
			
			self.headers(ctx.uniqueHeaderIds())
			self.headers(ctx.uniqueFooterIds())
			self.cells(ctx.uniqueCellIds())
		}
	}
	
	override open func update(with context: ViewUpdateContext?) {
		
		if let tableCtx = context as? TableViewUpdateContext {
			
			self.updateHeaderContext(tableCtx)
			self.updateFooterContext(tableCtx)
			self.updateRowContext(tableCtx)
		}
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
				
				switch update.actionType {
					
				case .add:
					self.insertSections(update.index, with: update.animationType)
					break
					
				case .change:
					self.reloadSections(update.index, with: update.animationType)
					break
					
				case .remove:
					self.deleteSections(update.index, with: update.animationType)
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
		return ctx?.getDefaultHeight() ?? 0
	}
	
	@objc(tableView:willDisplayCell:forRowAtIndexPath:) open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		cell.context = self.tableDataContext()!.sectionContext[indexPath.section].rowContext[indexPath.row]
	}
	
	open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		if let headerSectionContext = self.tableDataContext()?.sectionContext[section].headerContext {
			
			view.context = headerSectionContext
		}
	}
	
	open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		if let footerSectionContext = self.tableDataContext()?.sectionContext[section].footerContext {
			
			view.context = footerSectionContext
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
		
		cell.context = cellContext
		
		if self.rowHeight == UITableViewAutomaticDimension {
			
			cell.contentView.setNeedsLayout()
			cell.contentView.layoutIfNeeded()
		}
		
		return cell
	}
	
	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if let headerSectionContext = self.tableDataContext()?.sectionContext[section].headerContext {
			
			if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerSectionContext.reuseId) {
				
				header.context = headerSectionContext
				
				if self.sectionHeaderHeight == UITableViewAutomaticDimension {
					
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
				
				footer.context = footerSectionContext
				
				if self.sectionFooterHeight == UITableViewAutomaticDimension {
					
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
