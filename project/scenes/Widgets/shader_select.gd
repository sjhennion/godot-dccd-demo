extends Node3D

@onready var blank := $Plane/Blank
@onready var wireframe := $Plane/Wireframe
@onready var hologram := $Plane/Hologram
@onready var platform := $Plane/Platform

@onready var flat_plane := $Plane

func _ready():
	setup_tween(blank)
	setup_tween(wireframe)
	setup_tween(hologram)

	var plat_tween := get_tree().create_tween()
	plat_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	plat_tween.tween_property(platform, "position:y", -0.049, 1.5)
	plat_tween.tween_property(platform, "position:y", -0.066, 1.5)
	plat_tween.set_loops()

var steady_tween_dur := 3.0

func setup_tween(item):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_SINE)
	tween.tween_property(item, "rotation:y", 2 * PI, steady_tween_dur)
	tween.tween_property(item, "rotation:y", 0, steady_tween_dur)
	tween.set_loops(0)


const rot_dur := 0.25
const shader_count := 3
const rot_amt := (2 * PI) / shader_count
var rot_idx := 0

func start_rotate():
	var rot_tween = get_tree().create_tween()
	#rot_idx = rot_idx + 1 if rot_idx + 1 < shader_count else 0
	rot_idx += 1
	#rot_tween.tween_property(flat_plane, "rotation:y", flat_plane.rotation.y - (rot_idx * rot_amt), rot_dur)
	rot_tween.tween_property(flat_plane, "rotation:y", -rot_idx * rot_amt, rot_dur)

func _input(event):
	if event.is_action_pressed("SwapShader"):
		start_rotate()