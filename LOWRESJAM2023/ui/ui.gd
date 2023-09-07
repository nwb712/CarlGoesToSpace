extends CanvasLayer


var progress_bar
var key_container

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.ui = self
	progress_bar = $Control/TextureProgressBar
	key_container = $Control/KeyContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins():
	progress_bar.value = GameManager.coins % int(progress_bar.max_value)


func update_keys():
	var keys = GameManager.keys
	if keys == 0:
		key_container.get_node("Key1").visible = false
		key_container.get_node("Key2").visible = false
	elif keys == 1:
		key_container.get_node("Key1").visible = true
		key_container.get_node("Key2").visible = false
	else:
		key_container.get_node("Key1").visible = true
		key_container.get_node("Key2").visible = true
		


func set_anchor_direction(direction: String):
	var children = $Control.get_children()
	for c in children:
		if direction == "left":
			c.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
		if direction == "right":
			c.set_anchors_preset(Control.PRESET_BOTTOM_LEFT, true)
