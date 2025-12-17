extends Node3D

@onready var shader_select := $SubViewport/ShaderSelect

func _input(event):
	if event.is_action_pressed("SwapShader"):
		shader_select._input(event)
		#print("Swap Shader in Widget")
