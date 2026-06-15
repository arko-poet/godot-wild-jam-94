class_name DnaStrandDrawing extends Node2D

const BASE_HEIGHT := 16
const BASE_SPACING := 8
const BASE_SHAPE := Vector2(32, 16)

var strand: DNAStrand
var shift: int: ## how to shift the strand up and down
	set(value):
		shift = value
		queue_redraw()
@export var is_left := true ## otherwise it's right

func _ready() -> void:
	_test_strand() # TODO delete after testing
	queue_redraw()


func _draw() -> void:
	var strand_height = BASE_HEIGHT * strand.bases.size() + BASE_SPACING * (strand.bases.size() - 1)
	draw_line(Vector2.ZERO, Vector2(0, strand_height), Color.BLACK, 4)
	
	var base_position := Vector2(4, shift * (BASE_HEIGHT + BASE_SPACING))
	
	if not is_left: base_position.x = base_position.x * -1 - BASE_SHAPE.x
	for base in strand.bases:
		if base_position.y >= 0 and base_position.y < strand_height:
			var base_rect := Rect2(base_position, BASE_SHAPE)
			draw_rect(base_rect, Color.HOT_PINK)
		base_position.y += BASE_HEIGHT + BASE_SPACING


func _test_strand() -> void:
	strand = DNAStrand.new()
	for i in 8:
		strand.bases.append(DNABase.new(DNABase.Shape.RoundSocket, DNABase.Attribute.HEALTH, 4))
		
