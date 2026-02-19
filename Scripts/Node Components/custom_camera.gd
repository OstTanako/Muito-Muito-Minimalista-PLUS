extends Camera2D
class_name CustomCamera


## Camera Setup.
func _ready() -> void:
	self.position_smoothing_enabled = true
	self.rotation_smoothing_enabled = true
	self.ignore_rotation = false
	self.zoom = Vector2(0.7 , 0.7)
	
	Global.PlayerDash_Left.connect(_LEFT_DASH)
	Global.PlayerDash_Right.connect(_RIGHT_DASH)
	Global.PlayerDash_End.connect(_END_DASH)
	_INTRO_OUT()



## Tween Stuff for Camera Animations.
func _RIGHT_DASH() -> void:
	var rotation_tw = create_tween().set_parallel(true)
	rotation_tw.tween_property(self, "rotation_degrees", 4.0, 0.3)

func _LEFT_DASH() -> void:
	var rotation_tw = create_tween().set_parallel(true)
	rotation_tw.tween_property(self, "rotation_degrees", -4.0, 0.3)

func _END_DASH() -> void:
	var rotation_tw = create_tween().set_parallel(true)
	rotation_tw.tween_property(self, "rotation_degrees", 0.0, 0.3)

func _INTRO_IN() -> void:
	self.zoom = Vector2(0.0, 0.0)
	self.rotation_degrees = 0.0
	
	var intro_tw = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	intro_tw.tween_property(self, "zoom", Vector2(2.0, 2.0), 0.5)
	intro_tw.tween_property(self, "rotation_degrees", 4.0 or -4.0, 0.5)

func _INTRO_OUT() -> void:
	self.zoom = Vector2(2.0, 2.0)
	self.rotation_degrees = 4.0
	
	var intro_tw = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	intro_tw.tween_property(self, "zoom", Vector2(0.7, 0.7), 0.7)
	intro_tw.tween_property(self, "rotation_degrees", 0.0, 0.7)
