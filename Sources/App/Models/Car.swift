import Vapor
import Fluent
import Foundation

final class Car: Model, NodeConvertible {
	var id: Node?
	var make: String
	var model: String
	var sub_model: String
	var year:Int
	
	var exists: Bool = false
	
	
	init(content: String) {
		self.id = UUID().uuidString.makeNode()
		self.make = "Default Make"
		self.model = "Default Model"
		self.sub_model = "Default Sub_model"
		self.year = 0
	}
	
	init(node:Node) throws {
		make = try node.extract("make")
		print("2 Node make\(make)")
		model = try node.extract("model")
		sub_model = try node.extract("sub_model")
		year = try node.extract("year")
	}
	
	init(json:JSON) throws {
		make = try json.extract("make")
		model = try json.extract("model")
		sub_model = try json.extract("sub_model")
		year = try json.extract("year")
	}
	
	init(node: Node, in context: Context) throws {
		
		make = try node.extract("make")
		print("2 Node make\(make)")
		model = try node.extract("model")
		sub_model = try node.extract("sub_model")
		year = try node.extract("year")
		
	}
	
	

	
	func makeNode(context: Context) throws -> Node {
		return try Node(node: [
			"id": id,
			"make":make,
			"model":model,
			"sub_model":sub_model,
			"year":year
			])
	}
}



extension Car: Preparation {
	static func prepare(_ database: Database) throws {
		/*try database.create("Cars") { cars in
			cars.id()
			cars.string("make")
			//cars.string("model")
			//cars.string("sub_model")
			//cars.int("year")
			
		}*/
		
	}
	
	static func revert(_ database: Database) throws {
		/*
		try database.delete("Cars")
		*/
	}
}
