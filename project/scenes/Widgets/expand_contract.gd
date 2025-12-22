extends Node3D

@onready var plane := $Plane
@onready var clutch1 := $Plane/Clutch1
@onready var clutch2 := $Plane/Clutch2
@onready var clutch3 := $Plane/Clutch3
@onready var platform := $Plane/Platform

var is_contracting := true

func _ready():
	setup_contract_tween()

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

var quick_dur := 0.05
var long_dur := 2.0

var clutch1_tween: Tween = null
var clutch3_tween: Tween = null

func setup_contract_tween():
	if clutch1_tween != null:
		clutch1_tween.kill()
	if clutch3_tween != null:
		clutch3_tween.kill()

	clutch1_tween = get_tree().create_tween()
	clutch3_tween = get_tree().create_tween()

	clutch1_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	clutch1_tween.tween_property(clutch1, "position:x", -0.201, long_dur)
	clutch1_tween.tween_property(clutch1, "position:x", -0.759, quick_dur)
	clutch1_tween.set_loops()

	clutch3_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	clutch3_tween.tween_property(clutch3, "position:x", 0.201, long_dur)
	clutch3_tween.tween_property(clutch3, "position:x", 0.759, quick_dur)
	clutch3_tween.set_loops()

func setup_expand_tween():
	if clutch1_tween != null:
		clutch1_tween.kill()
	if clutch3_tween != null:
		clutch3_tween.kill()

	clutch1_tween = get_tree().create_tween()
	clutch3_tween = get_tree().create_tween()

	clutch1_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	clutch1_tween.tween_property(clutch1, "position:x", -0.759, long_dur)
	clutch1_tween.tween_property(clutch1, "position:x", -0.201, quick_dur)
	clutch1_tween.set_loops()

	clutch3_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	clutch3_tween.tween_property(clutch3, "position:x", 0.759, long_dur)
	clutch3_tween.tween_property(clutch3, "position:x", 0.201, quick_dur)
	clutch3_tween.set_loops()

func _input(event):
	if event.is_action_pressed("ExpandContractFixture"):
		if is_contracting:
			setup_expand_tween()
			is_contracting = false
		else:
			setup_contract_tween()
			is_contracting = true
