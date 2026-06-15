class_name DnaStrandDrawing extends Node2D

const DNA_STRAND_SPACING := 8
const DNA_BASE_SHAPE := Vector2(32, 16)
const STRAND_WIDTH := 4

var strand: DNAStrand
var shift: int: ## how to shift the strand up and down
	set(value):
		shift = value
		queue_redraw()
@export var is_left := true ## is it the strand on the left or on the right on the mutation  screen


func _ready() -> void:
	_test_strand() # TODO delete after testing


func _draw() -> void:
	# draw DNA line
	var strand_height = (DNA_BASE_SHAPE.y + DNA_STRAND_SPACING) * strand.bases.size() - DNA_STRAND_SPACING
	draw_line(Vector2.ZERO, Vector2(0, strand_height), Color.BLACK, STRAND_WIDTH)
	
	# draw DNA bases
	var base_position := Vector2(STRAND_WIDTH, shift * (DNA_BASE_SHAPE.y + DNA_STRAND_SPACING))
	if not is_left:
		base_position.x = base_position.x * -1 - DNA_BASE_SHAPE.x
	for base in strand.bases:
		if base_position.y >= 0 and base_position.y < strand_height:
			var base_rect := Rect2(base_position, DNA_BASE_SHAPE)
			draw_rect(base_rect, Color.HOT_PINK)
		base_position.y += DNA_BASE_SHAPE.y + DNA_STRAND_SPACING


func _test_strand() -> void:
	strand = DNAStrand.new()
	for i in 8:
		strand.bases.append(DNABase.new(DNABase.Shape.RoundSocket, DNABase.Attribute.HEALTH, 4))
	queue_redraw()
