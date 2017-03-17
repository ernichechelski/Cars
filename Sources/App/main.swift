import Vapor
import VaporMySQL
import Fluent
import Foundation
import Turnstile
import Auth
import HTTP


let drop = Droplet()

drop.addConfigurable(middleware: AuthMiddleware(user:CarUser.self), name: "auth")
drop.preparations.append(Car.self)
drop.preparations.append(CarUser.self)
try drop.addProvider(VaporMySQL.Provider.self)
let database = drop.database?.driver as? MySQLDriver




///////AUTH



drop.post("login") { request in
	guard let login = request.formURLEncoded?["login"]?.string, let passhash  = request.formURLEncoded?["passhash"]?.string else {
		return Abort.badRequest.message
	}
	let cred = UsernamePassword(username: login, password: passhash)
	do {
		try request.auth.login(cred)
		return Response(redirect: "/home")
	}catch let e as TurnstileError {
		return e.description
	}
}

drop.post("logout") { request in
	try request.auth.logout()
	return Response(redirect: "/")
}
//////AUTH END'


//WEBSOCKET



var sockets:[WebSocket] = []

func refreshData(message:String){
	for (index, element) in sockets.enumerated() {
		print("Item \(index): \(element)")
		do {
			try element.send(message)
		}
		catch{
			continue
		}
		
		
	}
}

drop.socket("ws") { req, ws in
	print("New WebSocket connected: \(ws)")
	
	sockets.append(ws)
	
	// ping the socket to keep it open
	try background {
		while ws.state == .open {
			try? ws.ping()
			drop.console.wait(seconds: 10) // every 10 seconds
		}
	}
	
	ws.onText = { ws, text in
		print("Text received: \(text) in \(ws)")
		
		refreshData(message: text)
		
		// reverse the characters and send back
		//let rev = String(text.characters.reversed())
		//try ws.send(rev)
	}
	
	ws.onClose = { ws, code, reason, clean in
		print("Closed.")
	}
}



//WEBSOCKET END

drop.get("") { request in
	return try drop.view.make("auth.html")
}

drop.get("home") { request in
	guard let currentUser = try? request.auth.user() as! CarUser else {
		return "You cannot access this page!"
	}
	return try drop.view.make("angular.html")
}




drop.get("emo") { request in
	return "😄"
}



drop.get("version") { request in
	
	guard let db = database else {
		return "No MySQL database connection"
	}
	let version = try db.raw("SELECT VERSION()")
	return try JSON(node: version)
	
	
}

drop.get("json") { request in
	
	guard let db = database else {
		return "No MySQL database connection"
	}
	
	return try JSON(node: Car.all().makeNode())
	
	
}

drop.get("cars") { request in
	
	guard let db = database else {
		return "No MySQL database connection"
	}
	
	let cars = try db.raw("SELECT * FROM Cars")
	return try JSON(node: cars)
}

drop.get("cars", Int.self) { request, carId in
	
	guard let db = database else {
		return "No MySQL database connection"
	}
	
	guard let car = try Car.find(carId) else {
		return "No car with this id"
	}
	
	/*return try drop.view.make("carDetail", [
		"model": car.model,
		"make": car.make,
		"submodel": car.sub_model,
		"year": car.year,
		])*/
	return try car.makeJSON()

}


//Getter by property
drop.get("cars", Int.self, String.self) { request, carId, property in
	
	guard let db = database else {
		return "No MySQL database connection"
	}
	
	let car = try Car.query().filter("id", carId)

	do {
		return try JSON(node: car.raw().extract(property))
	}
	catch{
		return "Property or id error"

	}
}




drop.delete("cars",Int.self) { request, carId in

	print(request)
	do {
		let currentUser = try? request.auth.user() as! CarUser
	}
	catch {
		return error.localizedDescription
	}
	
	guard let currentUser = try? request.auth.user() else {
		return "You cannot modify database!"
	}
	
	
	guard let db = database else {
		return "No MySQL database connection"
	}
	guard let car = try Car.find(carId) else {
		return "No car with this id"
	}
	
	try car.delete()
	refreshData(message: "Car deleted")
	
	return JSON("Car deleted")
	
}

drop.patch("cars",Int.self) { request, carId in
	
	
	
	
	guard let currentUser = try? request.auth.user() as! CarUser else {
		return "You cannot modify database!"
	}
	
	if let db = drop.database?.driver as? MySQLDriver, var car = try Car.query().filter("id", carId).first(){
		try car.make = (request.json?.extract("make"))!
		try car.model = (request.json?.extract("model"))!
		try car.sub_model = (request.json?.extract("sub_model"))!
		try car.year = (request.json?.extract("year"))!
		try car.save()
		refreshData(message: "Car updated")
		return JSON("Car Updated")
	}
	else {
		return JSON("No database connection or wrong id")
	}
}


drop.post("new") {	request in
	
	guard let currentUser = try? request.auth.user() as! CarUser else {
		return "You cannot modify database!"
	}
	
	var car = try Car(json: request.json!)
	try car.save()
	refreshData(message: "Car added")
	return car
}

drop.run()
