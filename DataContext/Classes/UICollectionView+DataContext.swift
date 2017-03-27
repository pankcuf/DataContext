//
//  UICollectionView+DataContext.swift
//  CoinfoxApp
//
//  Created by Vladimir Pirogov on 09/01/17.
//  Copyright © 2017 Coinfox. All rights reserved.
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
		
		let ctx = self.collectionDataContext()!
		
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

	open func collectionView(_ collectionView: UICollectionView, contextFor section: Int) -> CollectionDataSectionContext {
		
		let ctx = self.collectionDataContext()!
		
		let sectionContext = ctx.sectionContext[section]
		
		return sectionContext
	}
	
	open func collectionView(_ collectionView: UICollectionView, contextForRowAt indexPath: IndexPath) -> CollectionDataCellContext {
		
		let sectionContext = self.collectionView(collectionView, contextFor: indexPath.section)
		
		let rowContext = sectionContext.rowContext[indexPath.row]
		
		return rowContext
	}
}

open class CollectionDataContextImpl: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@objc(numberOfSectionsInCollectionView:)
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return collectionView.collectionDataContext()?.sectionContext.count ?? 0
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return collectionView.collectionView(collectionView, contextFor: section).rowContext.count
	}
	
	@objc(collectionView:layout:sizeForItemAtIndexPath:)
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let ctx = collectionView.collectionView(collectionView, contextForRowAt: indexPath)
		
		return ctx.getDefaultSize()
	}
	
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		
		let ctx = collectionView.collectionView(collectionView, contextFor: section).headerContext
		
		return ctx?.getDefaultSize() ?? CGSize.zero
	}
	
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		
		let ctx = collectionView.collectionView(collectionView, contextFor: section).footerContext
		
		return ctx?.getDefaultSize() ?? CGSize.zero
	}
	
	@objc(collectionView:cellForItemAtIndexPath:)
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let section = indexPath.section
		let row = indexPath.row
		
		let rows = collectionView.collectionView(collectionView, contextFor: section).rowContext
		
		let cellContext = rows[row]
		
		let reuseId = cellContext.reuseId
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
		
		let layout = collectionView.collectionViewLayout
		
		let itemSize = self.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
		
		if #available(iOS 10.0, *), itemSize == UICollectionViewFlowLayoutAutomaticSize {
			
			cell.context = cellContext
			cell.contentView.setNeedsLayout()
			cell.contentView.layoutIfNeeded()
		}
		
		return cell
	}
	
	@objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
	open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		let leafCtx = collectionView.collectionView(collectionView, contextForRowAt: indexPath)
		let leaf = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: leafCtx.reuseId, for: indexPath)
		
		let leafSize: CGSize
		
		if kind == UICollectionElementKindSectionHeader {
			leafSize = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForHeaderInSection: indexPath.section)
		} else if kind == UICollectionElementKindSectionFooter {
			leafSize = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForFooterInSection: indexPath.section)
		} else {
			leafSize = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
		}
		//		UICollectionElementCategory?
		
		if #available(iOS 10.0, *), leafSize == UICollectionViewFlowLayoutAutomaticSize {
			
			leaf.context = leafCtx
			leaf.setNeedsLayout()
			leaf.layoutIfNeeded()
		}
		
		return leaf
	}
	
	@objc(collectionView:willDisplayCell:forItemAtIndexPath:)
	open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		if #available(iOS 10.0, *), self.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath) != UICollectionViewFlowLayoutAutomaticSize {
			cell.context = collectionView.collectionView(collectionView, contextForRowAt: indexPath)
		}
	}
	
	@objc(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)
	public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		
		if #available(iOS 10.0, *) {
			
			if elementKind == UICollectionElementKindSectionHeader {
				
				if self.collectionView(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForHeaderInSection: indexPath.section) != UICollectionViewFlowLayoutAutomaticSize {
					view.context = collectionView.collectionView(collectionView, contextFor: indexPath.section)
				}
				
			} else if elementKind == UICollectionElementKindSectionFooter {
				
				if self.collectionView(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForHeaderInSection: indexPath.section) != UICollectionViewFlowLayoutAutomaticSize {
					view.context = collectionView.collectionView(collectionView, contextFor: indexPath.section)
				}
				
			} else if self.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath) != UICollectionViewFlowLayoutAutomaticSize {
				
				view.context = collectionView.collectionView(collectionView, contextFor: indexPath.section)
			}
		}
	}
}
