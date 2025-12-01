extends CharacterBody2D

var speed = 1000
var jump_height = 3250
var dir = 1
var was_touching_wall = false
var coyote_time = 0
var jumped = false
var playing = false
var first_jump = false
var first_turn = false

func _ready() -> void:
	$win.hide()

func _physics_process(_delta: float) -> void:
	if playing:
		$AnimatedSprite2D.scale.x = dir
		velocity.x = dir * speed
		velocity.y += 100
		if is_on_floor():
			coyote_time = 8
			jumped = false
			$AnimatedSprite2D.animation = "ground"
		else:
			coyote_time -= 1
			$AnimatedSprite2D.animation = "air"
		if Input.is_action_just_pressed("jump") and not jumped:
			if is_on_floor() or coyote_time > 0:
				velocity.y = -jump_height
				if not first_jump:
					$jump.queue_free()
					first_jump = true
				if is_on_floor():
					jumped = true
		if Input.is_action_just_pressed("turn"):
			dir *= -1
			if not first_turn:
				$turn.queue_free()
				first_turn = true
		if is_on_wall() and was_touching_wall == false:
			dir *= -1
			was_touching_wall = true
		else:
			was_touching_wall = false
		move_and_slide()
		
		
		if position.x < -20000:
			$win.show()
			playing = false
	if Input.is_action_just_pressed("reset") and position.x < -20000:
			position = Vector2.ZERO
			playing = true
			$win.hide()

func bounce(height):
	velocity.y = -height


func _on_button_pressed() -> void:
	playing = true
