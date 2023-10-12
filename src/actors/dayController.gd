extends Node

signal newHour
signal newNight
signal newDay
signal checkOffers
signal sellMarket

var hoursSpent := 0
var currentDay := 1

var colors = []
@export var steps : float = 5.0
@export var changeTime : float = 1.0

func _ready():
	var img = load("res://src/sprites/dayGradientAdjusted.png")
	for i in range(24):
		colors.append(img.get_pixel(i,0))
	$ColorRect.texture.gradient.colors = [colors[0],colors[1]]
	$ColorRect.texture.width = int(get_window().size.x/100)
	$ColorRect.texture.height = int(get_window().size.y/100)
	setTime()
	
	#hoursSpent = 15
	
	passHour()

func setTime():
	var clock = str((hoursSpent+8)%12,":00 ")
	if clock == "0:00 ":
		clock = "12:00 "
	if hoursSpent >= 4 and hoursSpent < 16:
		clock += "pm"
	else:
		clock += "am"
	if hoursSpent >= 16:
		$Label.text = str("night ",currentDay,"\n",clock)
	else:
		$Label.text = str("day: ",currentDay,"\n",clock)


func _process(_delta):
	pass

func passHour():
	if hoursSpent < 16:
		$Timer.wait_time = 1
	else:
		$Timer.wait_time = .2
	colorChange(hoursSpent)
	$Timer.start()


func colorChange(hS):
	if hS < 16:
		for i in range(steps):
			$ColorRect.texture.gradient.colors[0] = colors[hS-1].lerp(colors[hS],i*1/steps)
			$ColorRect.texture.gradient.colors[1] = colors[hS].lerp(colors[(hS+1)%24],i*1/steps)
			await get_tree().create_timer(changeTime/steps).timeout
	$ColorRect.texture.gradient.colors = [colors[hS],colors[(hS+1)%24]]

func _on_timer_timeout():
	hoursSpent += 1
	if hoursSpent == 16:
		emit_signal("newNight")
	elif hoursSpent > 16 and hoursSpent < 24:
		passHour()
	elif hoursSpent == 24:
		currentDay += 1
		hoursSpent = 0
		emit_signal("newDay")
	else:
		emit_signal("newHour")
	setTime()
	emit_signal("checkOffers")
