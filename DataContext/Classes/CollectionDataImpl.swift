//
//  CollectionDataImpl.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 27/03/17.
//  Copyright © 2017 Vladimir Pirogov. All rights reserved.
//

import Foundation
import UIKit

open class CollectionDataImpl: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@objc(numberOfSectionsInCollectionView:)
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return collectionView.collectionDataContext()?.sectionContext.count ?? 0
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return collectionView.collectionView(collectionView, contextFor: section)?.rowContext.count ?? 0
	}
	
	@objc(collectionView:layout:sizeForItemAtIndexPath:)
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let ctx = collectionView.collectionView(collectionView, contextForRowAt: indexPath)
		
		return ctx?.getDefaultSize() ?? CGSize.zero
	}
	
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		
		let ctx = collectionView.collectionView(collectionView, contextFor: section)?.headerContext
		
		return ctx?.getDefaultSize() ?? CGSize.zero
	}
	
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		
		let ctx = collectionView.collectionView(collectionView, contextFor: section)?.footerContext
		
		return ctx?.getDefaultSize() ?? CGSize.zero
	}
	
	@objc(collectionView:cellForItemAtIndexPath:)
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let section = indexPath.section
		let row = indexPath.row
		
		let ctx = collectionView.collectionView(collectionView, contextFor: section)!
		let rows = ctx.rowContext
		
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
		
		let leafCtx = collectionView.collectionView(collectionView, contextForRowAt: indexPath)!
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
