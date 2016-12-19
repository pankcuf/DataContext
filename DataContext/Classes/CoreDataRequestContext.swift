//
//  CoreDataRequestContext.swift
//  Pods
//
//  Created by Vladimir Pirogov on 20/12/16.
//
//

import Foundation
import CoreData

open class CoreDataRequestContext<ResponseType: DataResponseContext>: DataRequestContext<DataResponseContext> {
	
	open let entityName: String
	open let predicate: NSPredicate
	
	public init(entityName: String, predicate: NSPredicate, responseType: ResponseType.Type) {
		
		self.entityName = entityName
		self.predicate = predicate
		
		super.init(responseType: responseType)
	}
	
	open func toFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
		fetchRequest.predicate = self.predicate
		fetchRequest.returnsObjectsAsFaults = false
		
		return fetchRequest
	}
}
