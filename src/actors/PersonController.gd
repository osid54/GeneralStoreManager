extends Node2D
class_name PersonController

var inventory := {}
var money := 5000.0
			
func _ready():
	position = Vector2i(get_window().size/2.0)

func _init(inv:= {}, mon:= 5000.0):
	inventory = inv
	money = mon

func offer(_source: PersonController, _arr: Array): #thing = [item,amount,priceP]
	pass
	
func add(it: Item, cost: float, amt: int):
	var newIt = Item.new(it.getID())
	newIt.amount = amt
	if inventory.has(newIt.getID()):
		inventory[newIt.getID()].amount += amt
	else:
		inventory[newIt.getID()] = newIt
	money -= cost

func sell(it: Item, mon: float, rem: bool):
	money += mon
	if rem:
		inventory.erase(it.getID())
		it.queue_free()
		

