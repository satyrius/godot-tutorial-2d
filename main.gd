extends Control

@export var mob_scene: PackedScene
var score


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	score = 0
	$Player.start(get_viewport_rect().size / 2)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	var viewport_rect = get_viewport_rect()
	# Choose random edge: 0 for left, 1 for top, 2 for right, 3 for bottom
	match(randi() % 4):
		0:  # Left
			mob.position = Vector2(0, randf_range(0, viewport_rect.size.y))
			mob.rotation = atan2(0, 1)  # pointing rightwards
		1:  # Top
			mob.position = Vector2(randf_range(0, viewport_rect.size.x), 0)
			mob.rotation = atan2(1, 0)  # pointing downwards
		2:  # Right
			mob.position = Vector2(viewport_rect.size.x, randf_range(0, viewport_rect.size.y))
			mob.rotation = atan2(0, -1)  # pointing leftwards
		3:  # Bottom
			mob.position = Vector2(randf_range(0, viewport_rect.size.x), viewport_rect.size.y)
			mob.rotation = atan2(-1, 0)  # pointing upwards

	# Add some randomness to the direction.
	mob.rotation = mob.rotation + randf_range(-PI / 4, PI / 4)

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(mob.rotation)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

