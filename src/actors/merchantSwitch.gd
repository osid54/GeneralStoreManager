extends Button

var merchantNumber : int

func _ready():
	$Label.text = get_node("/root/main/Merchants").get_child(merchantNumber).merchantName
	self_modulate = TypeData.types[get_node("/root/main/Merchants").get_child(merchantNumber).merchantType]

func buttonClicked():
	get_node("/root/main/Manager/marketSell").switchMerchant(merchantNumber)
