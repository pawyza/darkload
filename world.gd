extends Node2D

var lifes = 3

@onready var enemy = $Enemy
@onready var player_sound_player = $PlayerSoundPlayer

var player_3 = preload("res://player_3.tscn")
var player_2 = preload("res://player_2.tscn")
var player_1 = preload("res://player_1.tscn")

var restartable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.player_hit.connect(player_died)
	player_sound_player.start_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept") and restartable:
		get_tree().reload_current_scene()
		var restartable = false

func player_died():
	match lifes:
		3:
			var old_ref = $Player_3
			var new_ref = player_2.instantiate()
			$AnimationPlayer.play("player_died_3")
			$Timer_reset.start()
			new_ref.position = old_ref.position
			new_ref.rotation = old_ref.rotation
			new_ref.sound_player = old_ref.sound_player
			player_sound_player.play_plyr(player_sound_player.PLAYER_KILL_SOUND)
			$AnimationPlayer.play("player_hit")
			move_child(new_ref, old_ref.get_index())
			add_child(new_ref)
			enemy.player = new_ref
			player_sound_player.player = new_ref
			old_ref.queue_free()
			lifes = 2
		2:
			var old_ref = $Player_2
			var new_ref = player_1.instantiate()
			$AnimationPlayer.play("player_died_2")
			$Timer_reset.start()
			new_ref.position = old_ref.position
			new_ref.rotation = old_ref.rotation
			new_ref.sound_player = old_ref.sound_player
			player_sound_player.play_plyr(player_sound_player.PLAYER_KILL_SOUND)
			$AnimationPlayer.play("player_hit")
			move_child(new_ref, old_ref.get_index())
			add_child(new_ref)
			enemy.player = new_ref
			player_sound_player.player = new_ref
			old_ref.queue_free()
			lifes = 1
		1:
			var old_ref = $Player_1
			player_sound_player.play_plyr(player_sound_player.PLAYER_FINALKILL_SOUND)
			$AnimationPlayer.play("player_died_1")
			$Timer_restart.start()
			#enemy.queue_free()
			lifes = 0

func _on_timer_reset_timeout():
	$AnimationPlayer.play("Control_back")

func return_control():
	Signals.emit_signal("control_back")

func _on_area_2d_body_entered_first_trigger(body):
	$enemy_sound_player.play_distance_enemy($enemy_sound_player.MONSTER_DISSAPPEAR_SOUND)
	$First_trigger.queue_free()

func _on_area_2d_body_entered_second_trigger(body):
	$Enemy.activate()
	$Second_trigger.queue_free()

func _on_area_2d_body_entered_safe_trigger(body):
	$Timer_restart.start()
	$AnimationPlayer.play("player_won")

func _on_button_pressed():
	$MenuCanvas.hide()
	player_sound_player.stop_music()
	player_sound_player.start_main_ambient()
	Signals.emit_signal("control_back")

func _on_timer_restart_timeout():
	$CanvasLayer/Label_restart.show()
	restartable = true
