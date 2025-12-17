extends Camera3D


var line_side_pos := Vector3(0.001, -0.263, -0.83)
var line_side_rot := Vector3(0.0, 0.0, PI / 2.0)
var line_side_height := 1.75

func _ready():
	pass
	#setup_bar()

"""
func setup_bar():
	var line_grow_tween := get_tree().create_tween()
	line_grow_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	line_grow_tween.tween_property(line, "height", line_starting_height, 4.0)
"""

"""
func transition_to_side():
	var line_grow_tween := get_tree().create_tween()
	line_grow_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	line_grow_tween.tween_property(line, "height", line_side_height, 4.0)
"""