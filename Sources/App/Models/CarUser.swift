import Vapor
import Fluent
import Foundation
import Auth
import Turnstile


final class CarUser: Model, User{
	
	var exists: Bool = false

	var id: Node?
	var name:String
	var login:String
	var passhash:String
	
	init(login:String,passhash:String) throws {
		self.name = "New user"
		self.login = login
		self.passhash = passhash
	}
	
	init(node: Node, in context: Context) throws {
		id = try node.extract("id")
		name = try node.extract("name")
		login = try node.extract("login")
		passhash = try node.extract("passhash")
	}
	
	init(json: JSON, in context: Context) throws {
		id = try json.extract("id")
		name = try json.extract("name")
		login = try json.extract("login")
		passhash = try json.extract("passhash")
	}
	
	
}

extension CarUser: NodeConvertible {
	func makeNode(context: Context) throws -> Node {
		return try Node(node: [
			"id": id,
			"name": name,
			"login": login,
			"passhash": passhash
			])
	}
}

extension CarUser: Authenticator {
	static func authenticate(credentials: Credentials) throws -> User{
		
		
		var user:CarUser?
		
		switch credentials {
		case let cred as UsernamePassword:
			
			if let fetchedUser = try CarUser.query().filter("login",cred.username).first(){
				if fetchedUser.passhash.equals(caseInsensitive: cred.password){
					user = fetchedUser
				}
			}
			
			
			break
			
		case let cred as Identifier:
			
			user = try CarUser.find(cred.id)
			break
			
			
		default:
			throw UnsupportedCredentialsError()
		}
		
		if let user = user {
			return user
		}
		else{
			throw IncorrectCredentialsError()
		}
		
	}
	
	static func register(credentials: Credentials) throws -> User{
		throw Abort.badRequest
	}

}


extension CarUser: Preparation {
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

