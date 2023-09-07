class_name PlayerCamera
extends Camera2D

@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = player.position	
	if (
		int(player_position.x / 256) != int(position.x / 256) or int(player_position.y / 128) != int(position.y / 64)
	):
		position.x = int(player_position.x / 256) * 256
		position.y = int(player_position.y / 128) * 128
		EventManager.emit_signal("room_changed")


func is_on_screen(location: Vector2):
	var left_bound = position.x
	var right_bound = position.x + 128
	var upper_bound = position.y
	var lower_bound = position.y + 128
	
	if location.x >= left_bound and location.x <= right_bound:
		if location.y >= upper_bound and location.y <= lower_bound:
			return true
	
	return false
