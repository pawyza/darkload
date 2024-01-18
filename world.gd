extends Node2D

var lifes = 3

@onready var enemy = $Enemy

var player_3 = preload("res://player_3.tscn")
var player_2 = preload("res://player_2.tscn")
var player_1 = preload("res://player_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.player_hit.connect(player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_died():
	match lifes:
		3:
			var old_ref = $Player_3
			var new_ref = player_2.instantiate()
			$AnimationPlayer.play("player_died_3")
			$Timer_reset.start()
			new_ref.position = old_ref.position
			new_ref.rotation = old_ref.rotation
			$AnimationPlayer.play("player_hit")
			move_child(new_ref, old_ref.get_index())
			add_child(new_ref)
			enemy.player = new_ref
			old_ref.queue_free()
			lifes = 2
		2:
			var old_ref = $Player_2
			var new_ref = player_1.instantiate()
			$AnimationPlayer.play("player_died_2")
			$Timer_reset.start()
			new_ref.position = old_ref.position
			new_ref.rotation = old_ref.rotation
			$AnimationPlayer.play("player_hit")
			move_child(new_ref, old_ref.get_index())
			add_child(new_ref)
			enemy.player = new_ref
			old_ref.queue_free()
			lifes = 1
		1:
			var old_ref = $Player_1
			$AnimationPlayer.play("player_died_1")
			enemy.queue_free()
			old_ref.queue_free()
			lifes = 0

func _on_timer_reset_timeout():
	$AnimationPlayer.play("Control_back")

func return_control():
	Signals.emit_signal("control_back")

func _on_area_2d_body_entered_first_trigger(body):
	$First_trigger.queue_free()

func _on_area_2d_body_entered_second_trigger(body):
	$Enemy.activate()
