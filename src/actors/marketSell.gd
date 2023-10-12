extends Control

@export var border = Vector2i(100,100)
@export var tweenSpeed = 1.0

@onready var box = preload("res://src/actors/inventoryBox.tscn")
@onready var merchButton = preload("res://src/actors/merchantSwitch.tscn")

signal endMarket

var storage = {}

var merchants = []
var currentMerchantNum := 0
var currentMerchant : MerchantController

var rows := 0
var rowsShowable := 0
var startPos : Vector2

func _ready():
	startPos = $Panel/Panel/GridContainer.position
	border.y = border.x
	global_position = Vector2(border/2)
	var availableSpace1 = Vector2i(get_window().size.x*4/5,get_window().size.y)
	$Panel.size = Vector2i(availableSpace1 - border)
	$Panel/Panel/GridContainer.columns = $Panel.size.x/210
	$Panel/Continue.position.y += $Panel/Continue.size.y
	$Panel/VScrollBar.position.x += $Panel/VScrollBar.size.x
	
	var availableSpace2 = Vector2i(get_window().size.x*1/5,get_window().size.y)
	$merchantPanel.size = Vector2i(availableSpace2 - border)
	$merchantPanel.position = Vector2(availableSpace1.x,0)
	
	var count := 0
	for merchant in get_node("/root/main/Merchants").get_children():
		merchants.append(merchant)
		var m = merchButton.instantiate()
		m.merchantNumber = count
		count += 1
		$merchantPanel/VBox.add_child(m)
	#merchantSwitch(0)
	
	$Panel.pivot_offset = $Panel.size/2
	inAnim()
	
func loadInv(dict: Dictionary):
	storage = dict
	for it in storage:
		var b = box.instantiate()
		b.loadBox(dict[it])
		$Panel/Panel/GridContainer.add_child(b)
	switchMerchant(0)
	updateRows()
		
func sellBox(invBox: Node, id: int):
	get_parent().inventory[id].buy(get_parent(),currentMerchant,invBox.totalPrice,invBox.amount)
	invBox.maxAmount -= invBox.amount
	if invBox.maxAmount == 0:
		storage.erase(id)
		invBox.queue_free()
		updateRows()
	get_parent().setMoney()

func switchMerchant(num: int):
	currentMerchantNum = num
	currentMerchant = merchants[num]
	for b in $Panel/Panel/GridContainer.get_children():
		if b.is_in_group("invBox"):
			b.updatePrices(currentMerchant)

func inAnim():
	var goal = $Panel.position
	$Panel.scale.x = .5
	$Panel.position.y += $Panel.size.y
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($Panel, "scale", Vector2(1,1), tweenSpeed)
	tween.tween_property($Panel, "position", Vector2(goal), tweenSpeed)
	await get_tree().create_timer(tweenSpeed).timeout

func outAnim():
	get_parent().setMoney()
	var goal = $Panel.position.y - $Panel.size.y
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property($Panel, "scale", Vector2(0,0.5), tweenSpeed)
	tween.tween_property($Panel, "position", Vector2($Panel.position.x,goal), tweenSpeed)
	await get_tree().create_timer(tweenSpeed).timeout

func continueHit():
	await outAnim()
	DayController.passHour()
	queue_free()
	
func updateRows():
	rows = ceili(float(storage.size())/$Panel/Panel/GridContainer.columns)
	rowsShowable = $Panel.size.y/310
	$Panel/VScrollBar.max_value = rows-rowsShowable
	#$Panel/Panel/GridContainer.size.y = rows*310

func _on_v_scroll_bar_value_changed(value):
	$Panel/Panel/GridContainer.position.y = startPos.y - value * 310
