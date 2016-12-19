//
//  CoreDataAsyncTransport.swift
//  Pods
//
//  Created by Vladimir Pirogov on 20/12/16.
//
//

import Foundation
import CoreData

open class CoreDataAsyncTransport: DataTransport {
	
	let managedObjectContext: NSManagedObjectContext?
	
	public init(context: NSManagedObjectContext?) {
		
		self.managedObjectContext = context
		
		super.init()
	}
	
	open override func doAction(requestContext: DataRequestContext<DataResponseContext>, callback: @escaping DataTransport.ActionCallback) {
		
		guard let coreDataRequest = requestContext as? CoreDataRequestContext else { return }
		
		let transportCallback = self.responder(requestContext: coreDataRequest, callback: callback)
		
		let response = { (result: NSAsynchronousFetchResult<NSFetchRequestResult>) in
			
			transportCallback(result.finalResult)
		}
		
		let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: coreDataRequest.toFetchRequest(), completionBlock: response)
		
		self.managedObjectContext?.perform({
			
			do {
				
				try self.managedObjectContext?.execute(asyncRequest)
				
			} catch {
				
				print(error)
				transportCallback(error)
			}
		})
	}

}
