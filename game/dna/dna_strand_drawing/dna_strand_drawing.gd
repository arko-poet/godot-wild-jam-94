class_name DnaStrandDrawing extends Node2D

const DNA_STRAND_SPACING := 12
const DNA_BASE_HEIGHT := 23
const DNA_BASE_SHAPE := Vector2(63, 23)
const STRAND_WIDTH := 4

const DNABaseDrawingScene := preload("res://game/dna/dna_base_drawing/dna_base_drawing.tscn")

var strand: DNAStrand:
	set(value):
		strand = value
		if not strand.strand_mutated.is_connected(_on_strand_mutated):
			strand.strand_mutated.connect(_on_strand_mutated)
		_create_bases()
		_draw_bases()
		queue_redraw()
var shift: int: ## how to shift the strand up and down
	set(value):
		shift = value
		queue_redraw()
		_draw_bases()
var strand_base_drawings: Array[DNABaseDrawing]

@export var is_left := true ## is it the strand on the left or on the right on the mutation  screen


func _draw() -> void:
	# draw DNA line
	var strand_height = (
		(DNA_BASE_HEIGHT + DNA_STRAND_SPACING) * Strands.MAX_STRAND_LENGTH
		+ DNA_STRAND_SPACING
	)
	draw_line(Vector2.ZERO, Vector2(0, strand_height), Color.BLACK, STRAND_WIDTH)
	

	# draw DNA bases (DEPRECATED, using assets now instead)
	#var base_position := Vector2(STRAND_WIDTH, shift * (DNA_BASE_SHAPE.y + DNA_STRAND_SPACING))
	#if not is_left:
		#base_position.x = base_position.x * -1 - DNA_BASE_SHAPE.x
	#for base in strand.bases:
		#if base_position.y >= 0 and base_position.y < strand_height:
			#var base_rect := Rect2(base_position, DNA_BASE_SHAPE)
			#draw_rect(base_rect, Color.HOT_PINK)
		#base_position.y += DNA_BASE_SHAPE.y + DNA_STRAND_SPACING


func _create_bases() -> void:
	for drawing in strand_base_drawings:
		drawing.queue_free()
	strand_base_drawings.clear()
	
	for base in strand.bases:
		var base_drawing: DNABaseDrawing = DNABaseDrawingScene.instantiate()
		add_child(base_drawing)
		base_drawing.set_dna_base(base)
		strand_base_drawings.append(base_drawing)


func _draw_bases() -> void:
	var base_position := (
		Vector2(STRAND_WIDTH -2, shift * (DNA_BASE_HEIGHT + DNA_STRAND_SPACING) + DNA_STRAND_SPACING)
	)
	if not is_left:
		base_position.x = base_position.x * -1 - DNA_BASE_SHAPE.x -1
	for base_index in strand_base_drawings.size():
		var base := strand_base_drawings[base_index]
		base.set_alignement(is_left)
		base.hide()
		base.position = base_position
		if base_position.y >= 0 and base_index < Strands.MAX_STRAND_LENGTH - shift:
			base.show()
		base_position.y += DNA_BASE_HEIGHT + DNA_STRAND_SPACING


func _on_strand_mutated() -> void:
	_create_bases()
	_draw_bases()
	queue_redraw()
