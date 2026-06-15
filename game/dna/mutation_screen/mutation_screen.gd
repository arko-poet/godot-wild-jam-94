extends Node

signal mutation_finished

@onready var player_creature: Sprite2D = $World/PlayerCreature
@onready var corpse: Sprite2D = $World/Corpse
@onready var strand_a_drawing: DnaStrandDrawing = $World/StrandADrawing
@onready var strand_b_drawing: DnaStrandDrawing = $World/StrandBDrawing


@onready var confirm_mutation_button: Button = $UILayer/UI/ConfirmMutationButton
@onready var skip_mutation_button: Button = $UILayer/UI/SkipMutationButton
@onready var shift_strand_up_button: Button = $UILayer/UI/ShiftStrandUpButton
@onready var shift_strand_down_button: Button = $UILayer/UI/ShiftStrandDownButton


## TODO change parameters to get creature objects - for adding sprites etc.
## strandA -> player creature's strand that will change
## strandB -> slain creature strand that will affect strandA
func load_dna_strands(strandA: DNAStrand, strandB: DNAStrand) -> void:
	strand_a_drawing.strand = strandA
	strand_b_drawing.strand = strandB
	strand_b_drawing.shift = 0
	strand_b_drawing.is_left = false
	strand_a_drawing.queue_redraw()
	strand_b_drawing.queue_redraw()


func _on_confirm_mutation_button_pressed() -> void:
	strand_a_drawing.strand.combine_strands(strand_b_drawing.strand, strand_b_drawing.shift)
	mutation_finished.emit()


func _on_skip_mutation_button_pressed() -> void:
	mutation_finished.emit()


func _on_shift_strand_up_button_pressed() -> void:
	strand_b_drawing.shift -= 1


func _on_shift_strand_down_button_pressed() -> void:
	strand_b_drawing.shift += 1
