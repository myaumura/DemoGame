extends Node

@export var mob_scene: PackedScene
var score

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game() -> void:
	$Music.play()
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready!")

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	var velocity = Vector2(randf_range(150.0, 500.0), 0.0)
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
