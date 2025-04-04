extends Control

var last_grass: float = 0
var grass: float = 0
var grass_per_sec: float = 0
var grass_per_click: float = 1

var tween: Tween

var items = {
	"fertilizer": {
		"name": "Fertilizer",
		"price": 10,
		"multiply_price": 1.15,
		"persec": 1,
		"img": "res://assets/fertilizer.png"
	}
}

func _ready() -> void:
	for item in items.keys():
		var node = $Upgrades/Template.duplicate()
		node.get_node("HBoxContainer/TextureRect").texture = load(items[item].img)
		node.get_node("HBoxContainer/Price").text = str(items[item].price)
		node.get_node("HBoxContainer/Price").modulate = Color.from_string("#f38ba8", Color.RED)
		node.get_node("HBoxContainer/VBoxContainer/Name").text = str(items[item].name)
		node.get_node("HBoxContainer/VBoxContainer/PerSec").text = "%s per second" % items[item].persec
		node.name = item
		node.show()
		
		node.get_node("Button").pressed.connect(func ():
			if grass >= items[item].price:
				grass -= items[item].price
				items[item].price = ceili(items[item].price * items[item].multiply_price)
				grass_per_sec += items[item].persec
				node.get_node("HBoxContainer/Price").text = str(items[item].price)
				$VBoxContainer/PerSec.text = "%d grass per second" % grass_per_sec
		)
		
		$Upgrades.add_child(node)

func _process(delta: float) -> void:
	$Label.text = "Grass: %d" % grass
	
	if grass != last_grass:
		for node in $Upgrades.get_children():
			if node.name != "Template":
				if grass >= items[node.name].price:
					node.get_node("HBoxContainer/Price").modulate = Color.WHITE
				else:
					node.get_node("HBoxContainer/Price").modulate = Color.from_string("#f38ba8", Color.RED)
	
	last_grass = grass

func _on_texture_button_pressed() -> void:
	grass += 1
	$VBoxContainer/TextureButton.custom_minimum_size = Vector2(128, 128)
	$VBoxContainer/TextureButton
	
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property($VBoxContainer/TextureButton, "custom_minimum_size", Vector2(96, 96), .1)
	tween.tween_property($VBoxContainer/TextureButton, "custom_minimum_size", Vector2(128, 128), .1)


func _on_second_timer_timeout() -> void:
	grass += grass_per_sec
