//
//  TableDataImpl.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 27/03/17.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

open class TableDataImpl: NSObject, UITableViewDataSource, UITableViewDelegate {
	
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
