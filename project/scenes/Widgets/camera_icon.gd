extends Node3D

@onready var plane := $Plane
@onready var clutch1 := $Plane/Clutch1
@onready var clutch2 := $Plane/Clutch2
@onready var clutch3 := $Plane/Clutch3
@onready var platform := $Plane/Platform

func _ready():
	var twist_amount := 2 * PI / 128.0
	var twist_dur := 5.0

	var plane_tween := get_tree().create_tween()
	plane_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	plane_tween.tween_property(plane, "rotation:y", twist_amount, twist_dur)
	plane_tween.tween_property(plane, "rotation:y", -twist_amount, twist_dur)
	plane_tween.set_loops()

	var plat_tween := get_tree().create_tween()
	plat_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	plat_tween.tween_property(platform, "position:y", -0.683, 1.5)
	plat_tween.tween_property(platform, "position:y", -0.612, 1.5)
	plat_tween.set_loops()
