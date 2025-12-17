extends Node2D

func _ready() -> void:
	draw_bounding_box(Rect2(Vector2(0.0, 0.0), Vector2(5.0, 10.0)), Color.ALICE_BLUE)
	pass

var quad_box := []

func draw_bounding_box(bounding_box: Rect2, color: Color, width: float = 25.0, fill: bool = true) -> void:
	var line_points: Array[Vector2] = [
		bounding_box.position,
		bounding_box.position + Vector2(bounding_box.size.x, 0),
		bounding_box.position + Vector2(bounding_box.size.x, 0),
		bounding_box.position + bounding_box.size,
		bounding_box.position + bounding_box.size,
		bounding_box.position + Vector2(0, bounding_box.size.y),
		bounding_box.position + Vector2(0, bounding_box.size.y),
		bounding_box.position
	]
	var draw_call: Dictionary = {
		"line_points": line_points,
		"color": color,
		"width": width,
		"box": bounding_box,
		"fill": fill
	}
	quad_box.append(draw_call)
	queue_redraw()

func _draw() -> void:
	for draw_call: Dictionary in quad_box:
		var line_points: Array[Vector2] = draw_call["line_points"]
		var color: Color = draw_call["color"]
		var width: float = draw_call["width"]
		var box: Rect2 = draw_call["box"]
		draw_multiline(line_points, color, width)
		color.a = 0.5
		if draw_call["fill"]:
			draw_rect(box, color, true)
