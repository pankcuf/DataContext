//
//  DataContextDelegate.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 23/03/17.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

public protocol DataContextDelegate {

	func update(with context: ViewUpdateContext?)
	var context: DataContext? { get }
}
