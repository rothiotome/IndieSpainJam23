extends Node2D

var connected_rooms = {
	Vector2.RIGHT: null,
	Vector2.LEFT: null,
	Vector2.DOWN: null,
	Vector2.UP: null
}

@export var up_door:door
@export var down_door:door
@export var left_door:door
@export var right_door:door

@onready var open_door_button:OpenDoorButton = $OpenDoorButton

var number_of_connections:int = 0

func _ready():
	open_door_button.on_button_pushed.connect(open_room_doors)

func setup_door():
	for r in connected_rooms:
		if connected_rooms[r] == null:
			match r:
				Vector2.UP: up_door.set_door_state(door.door_state.DISABLED)
				Vector2.DOWN: down_door.set_door_state(door.door_state.DISABLED)
				Vector2.RIGHT: right_door.set_door_state(door.door_state.DISABLED)
				Vector2.LEFT: left_door.set_door_state(door.door_state.DISABLED)

func open_room_doors():
	open_if_enabled(up_door)
	open_if_enabled(down_door)
	open_if_enabled(right_door)
	open_if_enabled(left_door)
	
	for r in connected_rooms:
		if connected_rooms[r] != null:
			connected_rooms[r].open_opposite_door(r)

func _on_area_2d_body_entered(body):
	if(body.name == "Player"):
		get_node("/root/World/Camera2D").move(self.global_position)

func open_if_enabled(target_door):
	if(target_door.current_door_state != door.door_state.DISABLED): 
		target_door.call_deferred("set_door_state", door.door_state.OPENED)
		
func open_opposite_door(dir):
	match dir:
		Vector2.UP: down_door.call_deferred("set_door_state", door.door_state.OPENED)
		Vector2.DOWN: up_door.call_deferred("set_door_state", door.door_state.OPENED)
		Vector2.RIGHT: left_door.call_deferred("set_door_state", door.door_state.OPENED)
		Vector2.LEFT: right_door.call_deferred("set_door_state", door.door_state.OPENED)
