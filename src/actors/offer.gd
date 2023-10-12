extends Control

var source : PlayerController
var item : Item

var from : String
var itemName : String
var pricePer : float
var amount : int
var totalPrice : float

@export var tweenSpeed := 1.0

@onready var man = get_parent()

signal offerDealtWith

func _ready():
	$VBox.pivot_offset = $VBox.size/2
	inAnim()

func setVars(f: PersonController, arr: Array):
	source = f
	item = arr[0]
	
	from = f.playerName
	itemName = arr[0].itemName
	pricePer = arr[2]
	amount = arr[1]
	totalPrice = snappedf(arr[1] * arr[2], .0)
	
	setUI()

func setUI():
	var f = from
	var iN = itemName
	var pP = str(pricePer)
	var amt = str(amount)
	var tP = str(totalPrice)
	
	$VBox/Panel/VBox/from.text = f
	$VBox/Panel/VBox/itemName.text = iN
	$VBox/Panel/VBox/pricePer.text = amt+" for "+pP+" g each"
	$VBox/Panel/VBox/totalPrice.text = "buy for "+tP+" g"

	$VBox/Panel/VBox/itemImage.texture = load(item.imagePath)
	$VBox/Panel/VBox/itemName.self_modulate = TypeData.types[item.type]

func onAccept():
	item.buy(source, man, totalPrice, amount)
	await outAnim()

func onDecline():
	await outAnim()

func inAnim():
	var goal = $VBox.position
	$VBox.scale.y = 0
	$VBox.position.x += $VBox.size.x
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($VBox, "scale", Vector2(1,1), tweenSpeed)
	tween.tween_property($VBox, "position", Vector2(goal), tweenSpeed)
	await get_tree().create_timer(tweenSpeed).timeout

func outAnim():
	for button in $VBox/HBox.get_children():
		button.disabled = true
	get_parent().setMoney()
	var goal = $VBox.position.x - $VBox.size.x
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property($VBox, "scale", Vector2(1,0), tweenSpeed)
	tween.tween_property($VBox, "position", Vector2(goal,$VBox.position.y), tweenSpeed)
	await get_tree().create_timer(tweenSpeed).timeout
	emit_signal("offerDealtWith")
