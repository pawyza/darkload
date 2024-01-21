extends Node2D

@export var player : CharacterBody2D

@export var PLAYER_FLASH_ON_SOUND : Resource = preload("res://audio/DL_Player_Flash_On.wav")

@export var PLAYER_FLASH_OFF_SOUND : Resource = preload("res://audio/DL_Player_Flash_Off.wav")

@export var PLAYER_FLASH_OVERLOAD_SOUND : Resource = preload("res://audio/DL_Player_Flash_Overload.wav")

@export var PLAYER_FLASH_RESTART_SOUND : Resource = preload("res://audio/DL_Player_Flash_Restart.wav")

@export var PLAYER_FINALKILL_SOUND : Resource = preload("res://audio/DL_Player_FinalKill.wav")

@export var PLAYER_KILL_SOUND : Resource = preload("res://audio/DL_Player_Kill.wav")

@export var PLYR_WALK_SOUND_LIST : Array[Resource] = [
	preload("res://audio/DL_Player_Walk_1.wav"),
	preload("res://audio/DL_Player_Walk_2.wav"),
	preload("res://audio/DL_Player_Walk_3.wav"),
	preload("res://audio/DL_Player_Walk_4.wav"),
	preload("res://audio/DL_Player_Walk_5.wav"),
	preload("res://audio/DL_Player_Walk_6.wav"),
	preload("res://audio/DL_Player_Walk_7.wav"),
	preload("res://audio/DL_Player_Walk_8.wav"),
	preload("res://audio/DL_Player_Walk_9.wav"),
	preload("res://audio/DL_Player_Walk_10.wav"),
	preload("res://audio/DL_Player_Walk_11.wav"),
	preload("res://audio/DL_Player_Walk_12.wav"),
	preload("res://audio/DL_Player_Walk_13.wav"),
	preload("res://audio/DL_Player_Walk_14.wav"),
	preload("res://audio/DL_Player_Walk_15.wav"),
	preload("res://audio/DL_Player_Walk_16.wav"),
	preload("res://audio/DL_Player_Walk_16.wav"),
	preload("res://audio/DL_Player_Walk_17.wav"),
	preload("res://audio/DL_Player_Walk_18.wav"),
	preload("res://audio/DL_Player_Walk_19.wav"),
	preload("res://audio/DL_Player_Walk_20.wav"),
]

@export var AMBIENT_SOUND = preload("res://audio/DL_MainAmbience.wav")

func _physics_process(delta):
	if player:
		position = player.position

func play_ambient(sound, volume_db : float = 20.0, pitch_scale : float = 1.0):
	play_stream($AmbiencePlayer, sound, volume_db, pitch_scale)
	
func play_music(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	play_stream($MusicPlayer, sound, volume_db, pitch_scale)

func play_plyr(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	for audioStreamPlayer in $PlyrPlayers.get_children():
		if not audioStreamPlayer.playing:
			play_stream(audioStreamPlayer, sound, volume_db, pitch_scale)
			break

func play_ui(sound, volume_db : float = 0.0, pitch_scale : float = 1.0):
	for audioStreamPlayer in $UIPlayers.get_children():
		if not audioStreamPlayer.playing:
			play_stream(audioStreamPlayer, sound, volume_db, pitch_scale)
			break
#
func play_stream(audioStreamPlayer : AudioStreamPlayer2D, sound, volume_db, pitch_scale):
	audioStreamPlayer.volume_db = volume_db
	audioStreamPlayer.pitch_scale = pitch_scale
	audioStreamPlayer.stream = sound
	audioStreamPlayer.play()

func stop_music():
	$AnimationPlayerMusic.play("stop_music")

func start_music():
	$AnimationPlayerMusic.play("start_music")
	$MusicPlayer.play(0)

func start_main_ambient():
	$AnimationPlayerAmbience.play("start_ambient")

func _on_ambience_player_finished():
	$AmbiencePlayer.play()

func _on_music_player_finished():
	$MusicPlayer.play()
