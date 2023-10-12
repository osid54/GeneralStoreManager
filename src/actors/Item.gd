extends Node
class_name Item

var id : int
var itemName : String
var type : String

var imagePath := "res://src/sprites/items/"

var valueTotal := 0.0
var valuePer := 0.0

var valueXTotal := 0.0
var valueXPer := 0.0

var sellTotal := 0.0
var sellPer := 0.0

var amount := 0

func _init(newID):
	id = newID
	for thing in TypeData.items[newID]:
		set(thing,TypeData.items[newID][thing])
	imagePath += str(type,"/",itemName,".png")

func buy(source: PersonController, buyer: PersonController, price: float, num: int):
	amount -= num
	source.sell(self, price, amount==0)
	buyer.add(self, price, num)
	
func getAmount():
	return amount 

func getID():
	return id
	
func getExpected(num: int):
	return snappedf(valueXPer * num, .01)
