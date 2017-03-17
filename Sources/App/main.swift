import Vapor
import VaporMySQL
import Fluent
import Foundation



let drop = Droplet()


drop.preparations.append(Car.self)
try drop.addProvider(VaporMySQL.Provider.self)
let database = drop.database?.driver as? MySQLDriver


drop.get("") { request in
	return try drop.view.make("angular.html")
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

	guard let db = database else {
		return "No MySQL database connection"
	}
	guard let car = try Car.find(carId) else {
		return "No car with this id"
	}
	
	try car.delete()
	
	return JSON("Car deleted")
	
}

drop.patch("cars",Int.self) { request, carId in
	if let db = drop.database?.driver as? MySQLDriver, var car = try Car.query().filter("id", carId).first(){
		try car.make = (request.json?.extract("make"))!
		try car.model = (request.json?.extract("model"))!
		try car.sub_model = (request.json?.extract("sub_model"))!
		try car.year = (request.json?.extract("year"))!
		try car.save()
		return JSON("Car Updated")
	}
	else {
		return JSON("No database connection or wrong id")
	}
}


drop.post("new") {	request in
	var car = try Car(json: request.json!)
	try car.save()
	return car
}

drop.run()
