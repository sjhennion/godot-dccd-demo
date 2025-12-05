extends MeshInstance3D

@export var offset = 0.0

@onready var wireframe_shader := load("res://shaders/wireframe.gdshader")
@onready var hologram_shader := load("res://shaders/hologram.gdshader")
@onready var blank_shader := Shader.new()

@onready var shaders := [wireframe_shader, hologram_shader, blank_shader]
var shader_index := 0

@onready var wireframe_mat := ShaderMaterial.new()
@onready var hologram_mat := ShaderMaterial.new()

@onready var materials := [wireframe_mat, hologram_mat]
var mat_index := 0

func _ready():
	await get_tree().create_timer(offset).timeout

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_SINE)
	#tween.set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_property(self, "rotation", Vector3(0.0, PI, 0.0), 5.0)
	tween.tween_property(self, "rotation", Vector3(0.0, 0.0, 0.0), 5.0)
	tween.set_loops(0)
	pass

func swap_shader():
	shader_index = shader_index + 1 if shader_index + 1 < shaders.size() else 0
	get_active_material(0).shader = shaders[shader_index]

func _input(event):
	if event.is_action_pressed("SwapShader"):
		swap_shader()