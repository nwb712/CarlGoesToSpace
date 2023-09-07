extends Node

var coins = 0
var keys = 0

var respawn_pos = Vector2()

var ui
var camera
var player
var player_pos_ui = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	EventManager.connect("damaged", Callable(self, "_on_damaged"))
	EventManager.connect("room_change", Callable(self, "_on_room_change"))
	EventManager.connect("game_won", Callable(self, "_on_game_won"))
	EventManager.connect("coin_collected", Callable(self, "_on_coin_collected"))
	EventManager.connect("key_collected", Callable(self, "_on_key_collected"))
	EventManager.connect("key_used", Callable(self, "_on_key_used"))


func _on_coin_collected():
	coins += 1
	ui.update_coins()


func _on_key_collected():
	keys += 1
	ui.update_keys()


func _on_key_used():
	keys -= 1
	ui.update_keys()


func _process(delta):
	pass
	# check_player_pos_for_ui()


# Reset vars to initial values
func reset():
	coins = 0


func _on_damaged():
	player.die()


func _on_game_won():
	get_tree().change_scene("res://menus/YouWin.tscn")


func _on_room_change():
	pass


func check_player_pos_for_ui():
	if int(player.position.x) % 64 <= 32 and player_pos_ui != "right":
		player_pos_ui = "right"
		ui.set_anchor_direction(player_pos_ui)
	elif int(player.position.x) % 64 > 32 and player_pos_ui != "left":
		player_pos_ui = "left"
		ui.set_anchor_direction(player_pos_ui)
