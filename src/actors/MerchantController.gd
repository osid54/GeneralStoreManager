extends PersonController
class_name MerchantController

var merchantType : String
var merchantName : String

func getPrice(it:Item):
	if inventory.has(it.getID()):
		pass
	else:
		if it.type == merchantType:
			inventory[it.getID()] = snappedi(it.getExpected(1) * randf_range(.95, 1.5), 1)
			if inventory[it.getID()] == 0:
				inventory[it.getID()] = 1
		else:
			inventory[it.getID()] = randi_range(1,it.getExpected(1)/3)
			while inventory[it.getID()] > it.getExpected(1):
				inventory[it.getID()] -= 1
	return inventory[it.getID()]

func add(_it: Item, _cost: float, _amt: int): #need to override person controller
	pass
