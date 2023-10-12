extends PersonController

@onready var off = preload("res://src/actors/offer.tscn")
@onready var market = preload("res://src/actors/marketSell.tscn")

var inOffers = []

func _ready():
	super()
	setMoney()
	$moneyLabel.global_position = Vector2(10,get_window().size.y-$moneyLabel.size.y)
	DayController.newDay.connect(prepareWares)
	DayController.checkOffers.connect(viewOffers)
	DayController.sellMarket.connect(viewMarket)

func offer(source: PersonController, arr: Array):
	var o = off.instantiate()
	o.setVars(source, arr)
	inOffers.push_back(o)

func viewOffers():
	while !inOffers.is_empty():
		var o = inOffers.pop_front()
		add_child(o)
		await o.offerDealtWith

		o.queue_free()
	if DayController.hoursSpent == 16:
		await viewMarket()
	DayController.passHour()
	
func viewMarket():
	var inv = market.instantiate()
	add_child(inv)
	inv.loadInv(inventory)
	await inv.endMarket
	inv.queue_free()

func prepareWares():
	pass

func setMoney():
	$moneyLabel.text = str(money," g",)
