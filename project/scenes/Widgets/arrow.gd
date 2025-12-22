extends Node3D

@onready var _1 := $"1"
@onready var _2 := $"2"
@onready var _3 := $"3"
@onready var _4 := $"4"
@onready var _5 := $"5"
@onready var _6 := $"6"
@onready var _7 := $"7"
@onready var _8 := $"8"
@onready var _9 := $"9"
@onready var _10 := $"10"

const time_gap := 0.07
const time_interval := 1.05
const wave_pos_gap := 0.5
const tween_time := 0.2

func _ready():
	reset_to_main()

func reset_to_main() -> void:
	clear_started = false
	await get_tree().create_timer(7.0).timeout
	reveal()

func reveal():
	var reveal_time_gap := time_gap * 5.0
	_1.visible = true
	single_wave(_1)
	await get_tree().create_timer(reveal_time_gap).timeout
	_2.visible = true
	single_wave(_2)
	await get_tree().create_timer(reveal_time_gap).timeout
	_3.visible = true
	single_wave(_3)
	await get_tree().create_timer(reveal_time_gap).timeout
	_4.visible = true
	single_wave(_4)
	await get_tree().create_timer(reveal_time_gap).timeout
	_5.visible = true
	_8.visible = true
	_10.visible = true
	single_wave(_5)
	single_wave(_8)
	single_wave(_10)
	await get_tree().create_timer(reveal_time_gap).timeout
	_7.visible = true
	_9.visible = true
	single_wave(_7)
	single_wave(_9)
	await get_tree().create_timer(reveal_time_gap).timeout
	_6.visible = true
	single_wave(_6)
	await get_tree().create_timer(time_interval).timeout
	wave()

var clear_started := false
func start_clear() -> void:
	clear_started = true
	unreveal()

func unreveal():
	var reveal_time_gap := time_gap * 1.5
	_1.visible = false
	single_wave(_1)
	await get_tree().create_timer(reveal_time_gap).timeout
	_2.visible = false
	single_wave(_2)
	await get_tree().create_timer(reveal_time_gap).timeout
	_3.visible = false
	single_wave(_3)
	await get_tree().create_timer(reveal_time_gap).timeout
	_4.visible = false
	single_wave(_4)
	await get_tree().create_timer(reveal_time_gap).timeout
	_5.visible = false
	_8.visible = false
	_10.visible = false
	single_wave(_5)
	single_wave(_8)
	single_wave(_10)
	await get_tree().create_timer(reveal_time_gap).timeout
	_7.visible = false
	_9.visible = false
	single_wave(_7)
	single_wave(_9)
	await get_tree().create_timer(reveal_time_gap).timeout
	_6.visible = false
	single_wave(_6)
	await get_tree().create_timer(time_interval).timeout
	wave()

func single_wave(block):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_SINE)
	var start_z: float = block.position.z
	tween.tween_property(block, "position:z", start_z - wave_pos_gap, tween_time)
	tween.tween_property(block, "position:z", start_z + wave_pos_gap, tween_time * 2.0)
	tween.tween_property(block, "position:z", start_z, tween_time)

func wave():
	single_wave(_1)
	await get_tree().create_timer(time_gap).timeout
	if clear_started: return

	single_wave(_2)
	await get_tree().create_timer(time_gap).timeout
	if clear_started: return

	single_wave(_3)
	await get_tree().create_timer(time_gap).timeout
	if clear_started: return

	single_wave(_4)
	await get_tree().create_timer(time_gap).timeout
	if clear_started: return

	single_wave(_5)
	single_wave(_8)
	single_wave(_10)
	await get_tree().create_timer(time_gap).timeout
	if clear_started: return

	single_wave(_7)
	single_wave(_9)
	await get_tree().create_timer(time_gap).timeout
	if clear_started: return

	single_wave(_6)
	await get_tree().create_timer(time_interval * 2.0).timeout
	if clear_started: return

	wave()