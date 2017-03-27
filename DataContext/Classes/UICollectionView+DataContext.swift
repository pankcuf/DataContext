//
//  UICollectionView+DataContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 09/01/17.
//  Copyright © 2017 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
	
	open func collectionDataContext() -> CollectionDataContext? {
		
		return self.context as? CollectionDataContext
	}

	open override func contextDidChange() {
		
		if let ctx = self.context as? CollectionDataContext {
			
			self.createEmptyView()
			self.headers(ctx.uniqueHeaderIds())
			self.headers(ctx.uniqueFooterIds())
			self.cells(ctx.uniqueCellIds())
		}
	}
	
	open func createEmptyView() {
		
		if let emptyCtx = self.collectionDataContext()?.emptyContext {
			
			self.backgroundView = Bundle.main.loadNibNamed(emptyCtx.reuseId, owner: self, options: nil)?.first as? UIView
		}
	}
	
	override open func update(with context: ViewUpdateContext?) {
		
		if let collectionCtx = context as? CollectionViewUpdateContext {
			
			self.updateRowContext(collectionCtx)
			self.updateEmptyContext(collectionCtx)
		}
	}
	
	open func updateEmptyContext(_ response: CollectionViewUpdateContext?) {
		
		guard let ctx = self.collectionDataContext() else { return }
		
		let hasNoSections = ctx.sectionContext.isEmpty
		
		self.backgroundView?.isHidden = !hasNoSections
		self.backgroundView?.context = ctx.emptyContext
	}
	
	open func updateRowContext(_ response: CollectionViewUpdateContext?) {
		
		if let updates = response?.sectionsUpdates {
			
			self.performBatchUpdates({ 

				for update in updates {
					
					let iset = IndexSet(integer: update.index)
					
					switch update.actionType {
						
					case .add:
						self.insertSections(iset)
						break
						
					case .change:
						self.reloadSections(iset)
						break
						
					case .remove:
						self.deleteSections(iset)
						break
					}
				}

			}, completion: nil)
			
		} else {
			
			self.reloadData()
		}
	}

	open func collectionView(_ collectionView: UICollectionView, contextFor section: Int) -> CollectionDataSectionContext? {
		
		guard let ctx = self.collectionDataContext() else { return nil }
		
		let sectionContext = ctx.sectionContext[section]
		
		return sectionContext
	}
	
	open func collectionView(_ collectionView: UICollectionView, contextForRowAt indexPath: IndexPath) -> CollectionDataCellContext? {
		
		let sectionContext = self.collectionView(collectionView, contextFor: indexPath.section)
		
		let rowContext = sectionContext?.rowContext[indexPath.row]
		
		return rowContext
	}
}
