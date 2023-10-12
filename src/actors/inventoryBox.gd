extends Control

var item : Item
var amount := 1
var maxAmount := 0
var pricePer := 0.0
var totalPrice := 0.0

func _ready():
	pass 

func _process(_delta):
	pass
	
func loadBox(it: Item):
	item = it
	maxAmount = item.amount
	pricePer = item.getExpected(1)
	totalPrice = pricePer
	
	$Panel/VBox/itemName.text = item.itemName
	$Panel/VBox/HBox/amountMax.text = "/"+str(maxAmount)
	$Panel/VBox/HBox/pricePer.text = str(pricePer)+" g"
	$Panel/VBox/sellButton.text = str(totalPrice)+" g"
	
	$Panel/VBox/itemImage.texture = load(item.imagePath)
	$Panel/VBox/itemName.self_modulate = TypeData.types[item.type]

func sellHover():
	$Panel/VBox/sellButton.text = "sell"

func sellLeave():
	$Panel/VBox/sellButton.text = str(totalPrice)+" g"

func editorTextChanged(new_text):
	updateText(new_text)

func editFocusGone():
	updateText()
	checkNum()

func editorEnter(new_text):
	updateText(new_text)
	checkNum()

func updateText(check = $Panel/VBox/HBox/amountEditor.text):
	var txt = check as int
	if txt != null:
		if txt <= maxAmount:
			amount = txt
		else:
			amount = maxAmount
	else:
		amount = 1
	updateNum()
	
func checkNum():
	var txt = int($Panel/VBox/HBox/amountEditor.text)
	if txt <= 0:
		amount = 1
	elif txt > maxAmount:
		amount = maxAmount
	$Panel/VBox/HBox/amountEditor.text = str(amount)
	updateNum()

func updateNum():
	totalPrice = pricePer * amount
	sellLeave()

func onSellUp():
	get_node("/root/main/Manager/marketSell").sellBox(self,item.getID())

func updatePrices(merchant: MerchantController):
	if merchant.merchantType == item.type:
		$Panel.self_modulate = TypeData.types[merchant.merchantType]
	else:
		$Panel.self_modulate = Color.WHITE
	pricePer = merchant.getPrice(item)
	updateNum()
	$Panel/VBox/HBox/pricePer.text = str(pricePer)+" g"
	sellLeave()
	
func updateAmount():
	$Panel/VBox/HBox/amountMax.text = "/"+str(maxAmount)
	updateText()
