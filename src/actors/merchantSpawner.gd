extends Node

@onready var merchant = preload("res://src/actors/merchant.tscn")

func _ready():
	for type in TypeData.types:
		var m = merchant.instantiate()
		m.merchantType = type
		m.merchantName = type
		add_child(m)
