extends Node3D

@onready var camera := $Camera3D
@onready var title_card := $Camera3D/TitleCard

const width := 64
const height := 48
const dot_r := 0.015
const dot_height := 0.005
const dot_gap := 0.03

var drop_plane: Plane
var display_pos_bounds := Vector2(width * dot_gap, height * dot_gap)

var dots: Array[Array] = []

var awd_bitmap: Array[Array]
var peanut_bitmap: Array[Array]
var current_bitmap: Array[Array]
var current_bitmap_name := ""

func _ready():
	initialize_display()

	var bitmap: Array[Array] = [
		[1, 0, 0, 0],
		[0, 1, 0, 1],
		[0, 1, 1, 0],
		[0, 1, 1, 1],
	]

	drop_plane = Plane(Vector3(0, 0, 1), 0.0)

	var awd := Image.load_from_file("res://images/dot_display_awd1.png")
	awd_bitmap = convert_png_to_bitmap(awd)
	var peanut := Image.load_from_file("res://images/peanut_side.png")
	peanut_bitmap = convert_png_to_bitmap(peanut)

	draw_display("peanut", peanut_bitmap)

const scale_down_dur := 1.0
const scale_up_dur := 1.0
const scale_bulge_dur := 0.25
const scale_pos_dur := 0.25
const scale_dot_dur := 0.0001

const scale_bulge_factor := 1.5
const scale_down_factor := 0.0
const scale_pos_back_factor := -0.025
const scale_pos_front_factor := 0.025

func scale_load(bitmap_name: String, bitmap: Array[Array]) -> void:
	for c: int in range(width):
		for r: int in range(height):
			var dot: CSGCylinder3D = dots[r][c]

			var cur_dot = current_bitmap[r][c]
			var new_dot = bitmap[r][c]

			if cur_dot == 0 and new_dot == 0:
				# Do nothing
				pass
			elif cur_dot == 1 and new_dot == 0:
				# Remove current dot
				var tween = get_tree().create_tween()
				tween.tween_property(dot, "scale", Vector3(scale_down_factor, scale_down_factor, scale_down_factor), scale_down_dur)
			elif cur_dot == 0 and new_dot == 1:
				# Add new dot
				var tween = get_tree().create_tween()
				tween.tween_property(dot, "scale", Vector3(1.0, 1.0, 1.0), scale_up_dur)
			elif cur_dot == 1 and new_dot == 1:
				# Bulge dot
				var tween = get_tree().create_tween()
				tween.tween_property(dot, "scale", Vector3(scale_bulge_factor, scale_bulge_factor, scale_bulge_factor), scale_bulge_dur)
				tween.tween_property(dot, "scale", Vector3(1.0, 1.0, 1.0), scale_up_dur)

			"""
			var pos_tween = get_tree().create_tween()
			pos_tween.set_trans(Tween.TransitionType.TRANS_SINE)
			pos_tween.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, scale_pos_front_factor), scale_pos_dur)
			pos_tween.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, scale_pos_back_factor), scale_pos_dur * 2.0)
			pos_tween.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, dot.position.z), scale_pos_dur)
			"""

		await get_tree().create_timer(col_time_gap).timeout

	current_bitmap = bitmap
	current_bitmap_name = bitmap_name


var wave_time_gap := 3.0
var col_time_gap := 0.02
var wave_dot_rot_dur := 1.0
var wave_pos_delta := 0.03

func wave() -> void:
	print("wave")
	for c: int in range(width):
		for r: int in range(height):
			var dot: CSGCylinder3D = dots[r][c]
			var tween1 = get_tree().create_tween()
			tween1.tween_property(dot, "rotation", Vector3(dot.rotation.x, dot.rotation.y + PI, 0.0), wave_dot_rot_dur)
			tween1.tween_property(dot, "rotation", Vector3(dot.rotation.x, dot.rotation.y, 0.0), wave_dot_rot_dur)
			
			var tween2 = get_tree().create_tween()
			tween2.set_trans(Tween.TransitionType.TRANS_SINE)
			tween2.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y + wave_pos_delta, dot.position.z), wave_dot_rot_dur)
			tween2.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, dot.position.z), wave_dot_rot_dur)
	#	await get_tree().create_timer(col_time_gap).timeout

	#wave()


func wave_load_callback(bitmap: Array[Array], row: int, col: int) -> void:
	dots[row][col].visible = bitmap[row][col] == 1

func wave_load(bitmap: Array[Array], bitmap_name: String) -> void:
	await get_tree().create_timer(wave_time_gap).timeout

	for c: int in range(width):
		for r: int in range(height):
			var dot: CSGCylinder3D = dots[r][c]
			var tween1 = get_tree().create_tween()
			tween1.tween_property(dot, "rotation", Vector3(dot.rotation.x, dot.rotation.y + PI, 0.0), wave_dot_rot_dur)
			tween1.tween_property(dot, "rotation", Vector3(dot.rotation.x, dot.rotation.y, 0.0), wave_dot_rot_dur)
			tween1.tween_callback(wave_load_callback.bind(bitmap, r, c))
			
			var tween2 = get_tree().create_tween()
			tween2.set_trans(Tween.TransitionType.TRANS_SINE)
			tween2.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y + wave_pos_delta, dot.position.z), wave_dot_rot_dur)
			tween2.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, dot.position.z), wave_dot_rot_dur)
		await get_tree().create_timer(col_time_gap).timeout

	if bitmap_name == "awd":
		wave_load(peanut_bitmap, "peanut")
	else:
		wave_load(awd_bitmap, "awd")


func convert_png_to_bitmap(png: Image) -> Array[Array]:
	var bitmap: Array[Array] = []

	for r: int in range(height):
		var row := Array()
		for c: int in range(width):
			var pixel := png.get_pixel(c, r)
			if pixel.r == 0 and pixel.g == 0 and pixel.b == 0:
				row.append(0)
			else:
				row.append(1)
		bitmap.append(row)

	return bitmap

func initialize_display() -> void:
	var x_offset := (width * dot_gap) / 2.0
	var y_offset := (height * dot_gap) / 2.0

	for r: int in range(height):
		var row := Array()
		for c: int in range(width):
			var dot := CSGCylinder3D.new()
			dot.radius = dot_r
			dot.height = dot_height
			var x := (c * dot_gap) - x_offset + dot_gap / 2.0
			var y := y_offset - (r * dot_gap) - dot_gap / 2.0
			dot.position = Vector3(x, y, 0.0)
			dot.rotation = Vector3(PI / 2.0, 0.0, 0.0)
			row.append(dot)
			add_child(dot)
		dots.append(row)

	dots[0][0].scale = Vector3(0.0, 0.0, 0.0)
		
func draw_display(bitmap_name: String, bitmap: Array[Array]) -> void:
	for c: int in range(bitmap[0].size()):
		for r: int in range(bitmap.size()):
			var scale_factor := 1.0 if bitmap[r][c] == 1 else scale_down_factor
			dots[r][c].scale = Vector3(scale_factor, scale_factor, scale_factor)

	current_bitmap = bitmap
	current_bitmap_name = bitmap_name


func cycle_bitmap() -> void:
	print("Cycle bitmap")

	if current_bitmap_name == "peanut":
		scale_load("awd", awd_bitmap)
	else:
		scale_load("peanut", peanut_bitmap)

func _input(event):
	if event.is_action_pressed("CycleBitmap"):
		cycle_bitmap()

var last_mouse_x := 0
var last_mouse_y := 0

func mouse_over(mouse_pos: Vector3) -> void:
	if abs(mouse_pos.x) > display_pos_bounds.x / 2.0 or abs(mouse_pos.y) > display_pos_bounds.y / 2.0:
		#print(mouse_pos)
		return

	var dot_x := int(width / 2.0 + mouse_pos.x / dot_gap)
	var dot_y := int(height / 2.0 - mouse_pos.y / dot_gap)

	if last_mouse_x == dot_x and last_mouse_y == dot_y:
		return

	last_mouse_x = dot_x
	last_mouse_y = dot_y

	#print(mouse_pos)
	#print("%s %s" % [dot_x, dot_y])

	var dot: CSGCylinder3D = dots[dot_y][dot_x]

	print(dot)

	#dot.position = Vector3(dot.position.x, dot.position.y, dot.position.z + 0.1)

	print(dot.rotation)

	var rot_tween = get_tree().create_tween()
	rot_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	rot_tween.tween_property(dot, "rotation", Vector3(dot.rotation.x + (2 * PI), dot.rotation.y, dot.rotation.z), 1.0)
	rot_tween.tween_property(dot, "rotation", Vector3(PI / 2.0, dot.rotation.y, dot.rotation.z), 0.0)

	var pos_tween = get_tree().create_tween()
	pos_tween.set_trans(Tween.TransitionType.TRANS_SINE)
	pos_tween.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, scale_pos_front_factor), scale_pos_dur)
	pos_tween.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, scale_pos_back_factor), scale_pos_dur)
	pos_tween.tween_property(dot, "position", Vector3(dot.position.x, dot.position.y, 0.0), scale_pos_dur)


func _process(delta):
	var mouse_pos := get_viewport().get_mouse_position()
	var mouse_3d = drop_plane.intersects_ray(
							 camera.project_ray_origin(mouse_pos),
							 camera.project_ray_normal(mouse_pos))

	if mouse_3d != null:
		mouse_over(mouse_3d)

	#print(mouse_3d)

	pass
	#call_deferred("wave")
