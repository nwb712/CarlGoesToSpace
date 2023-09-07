class_name GameManager
extends Node

signal coin_count_changed(new_count: int)
signal key_count_changed(new_count: int)

enum GameStates{MAIN_MENU, GAME, PAUSE}

var game_state: set = _set_game_state

var levels: Resource = preload("res://levels/level_index.tres")
var current_level_data = load(levels.level_paths["test"])
var current_level

var coins = 0
var keys = 0

var player


# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	game_state = GameStates.GAME
	_load_level(levels.level_paths["test"])


func _connect_signals() -> void:
	EventManager.connect("damaged", Callable(self, "_on_damaged"))
	EventManager.connect("room_change", Callable(self, "_on_room_change"))
	EventManager.connect("game_won", Callable(self, "_on_game_won"))
	EventManager.connect("coin_collected", Callable(self, "_on_coin_collected"))
	EventManager.connect("key_collected", Callable(self, "_on_key_collected"))
	EventManager.connect("key_used", Callable(self, "_on_key_used"))
	EventManager.connect("player_spawned", Callable(self, "_player_spawned"))
	EventManager.connect("change_level", Callable(self, "_load_level"))


## Load and instance the level at the specified path while freeing any other level already loaded
func _load_level(path: String) -> void:
	if current_level != null:
		current_level.queue_free()
	current_level_data = load(path)
	current_level = current_level_data.instantiate()
	add_child(current_level)


## Grab a reference to the player instance when it spawns
func _on_player_spawned(plyr: Player):
	player = plyr


func _on_coin_collected():
	coins += 1
	emit_signal("coin_count_changed", coins)


func _on_key_collected():
	keys += 1
	emit_signal("key_count_changed", keys)


func _on_key_used():
	keys -= 1
	emit_signal("key_count_changed", keys)


# Reset vars to initial values
func reset():
	coins = 0
	keys = 0
	emit_signal("coin_count_changed", coins)
	emit_signal("key_count_changed", keys)


func _on_damaged():
	player.die()


func _on_game_won():
	get_tree().change_scene("res://menus/YouWin.tscn")


func _set_game_state(state: GameStates):
	game_state = state
