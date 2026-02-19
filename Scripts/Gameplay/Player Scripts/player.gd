extends CharacterBody2D


## Player's general variables.
var SPEED : float = 300.0  # Player's Speed.
var J_SPEED : float = -600.0  # Jump Speed.
var DOUBLE_JUMP : bool

@onready var DASH_TIMER : Timer = $"Dash Timer"  # Reference for the Dash Timer.
@onready var DASH_PARTICLES : GPUParticles2D  # Reference for Dash Particles.
@onready var DASH_TRAIL : Line2D = $Trail2D # Reference for Dash Player


## Player Setup.
func _physics_process(delta: float) -> void:
	_get_input()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


## Player Functions.
func _get_input() -> void:  # it conceds user the capacibility of controling player.
	if Input.is_action_just_pressed("PlayerJump"):
		velocity.y = J_SPEED
		DOUBLE_JUMP = false
		_PLAYER_JUMP()
	elif Input.is_action_just_pressed("PlayerJump") and not is_on_floor():  # Handle Double Jump.
		if DOUBLE_JUMP == false:
			J_SPEED * 1000.0
			velocity.y = J_SPEED
			DOUBLE_JUMP = true
			_PLAYER_JUMP()
		else:
			pass
	
	var DIR := Input.get_axis("PlayerLeft", "PlayerRight")
	
	if DIR:
		velocity.x = DIR * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_released("PlayerDash"):
		_DETECT_DIR()
		DASH_TIMER.start()
		SPEED *= 5.0
		velocity.x = DIR * SPEED
		
		DASH_TRAIL.width = 0
		var dash_tw = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		dash_tw.tween_property(DASH_TRAIL, "width", 64, 0.3)

func _dash_timedout() -> void:
	SPEED = 300.0
	Global.PlayerDash_End.emit()
	
	DASH_TRAIL.width = 64
	var dash_tw = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	dash_tw.tween_property(DASH_TRAIL, "width", 0, 0.3)


func _DETECT_DIR() -> void: # Help the Camera decides what direction he need react when dashed.
	if Input.is_action_just_pressed("PlayerLeft"):
		Global.PlayerDash_Left.emit()
	else:
		Global.PlayerDash_Right.emit()


## Tween Stuff.
func _PLAYER_JUMP() -> void:  # Jump Animation.
	var jump_tw = create_tween()
	
	jump_tw.tween_property(self, "scale", Vector2(1.0 , 0.5), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	await jump_tw.finished
	var jump_tw2 = create_tween()
	
	jump_tw2.tween_property(self, "scale", Vector2(0.5 , 1.0), 0.2).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BACK)
	await jump_tw2.finished
	
	var jump_tw3 = create_tween()
	jump_tw3.tween_property(self, "scale", Vector2(1.0 , 1.0), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
