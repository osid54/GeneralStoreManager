extends PersonController 
class_name PlayerController

var manager : PersonController
var playerName := "tester"
var playerNameOptions = ["player_one", "player_two", "player_three", "player_four", "player_five"]
var preferences = {}

@onready var man = 	get_tree().root.get_node("/root/main/Manager")

func _init(inv:= {}, mon:= 5000.0, p := {}):
	DayController.newHour.connect(atTheHour)
	DayController.newNight.connect(atNight)
	super(inv, mon)
	playerName = playerNameOptions.pick_random()
	if p == {}:
		var typesNum = TypeData.types.size()
		var pMin = 5 + typesNum-1
		var pMax = 4 * typesNum
		var pCount : int
		while pCount < pMin or pCount > pMax:
			pCount = 0
			for t in TypeData.types:
				preferences[t] = randi_range(1,5)
				pCount += preferences[t]
			#print(pCount)
	else:
		preferences = p
		print("init done")

func offer(source: PersonController, arr: Array):
	for thing in arr: #thing = [item,amount,priceP]
		var it = thing[0]
		var amount = thing[1]
		var price = thing[2] * amount
		var buyChance = price / it.getExpected(amount) * 0.5
		if randf() <= buyChance:
			thing[0].buy(source,self,price,amount)

func sendOffer(night:= false):
	var off := []
	var n := [0,0,0,0,0]
	if night:
		n = [4,10,7,.05,.1]
	for i in randi_range(1 + n[0], 5 + n[1]):
		var it = Item.new(randi_range(0,TypeData.items.size()-2))
		if inventory.has(it.getID()):
			it.amount = inventory[it.getID()].amount
		else:
			inventory[it.getID()] = it
		
		var amt = randi_range(1,8 + n[2])
		inventory[it.getID()].amount += amt
		
		var price = it.getExpected(1)
		price *= randf_range(.85 - n[3], 1.15 - n[4])
		price = snappedi(price,1)
		
		off = [inventory[it.getID()],amt,price]
		man.offer(self,off)
	
func atTheHour():
	sendOffer(false)

func atNight():
	sendOffer(true)
