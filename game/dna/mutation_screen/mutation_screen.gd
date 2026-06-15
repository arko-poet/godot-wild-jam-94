extends Node

signal mutation_finished

@onready var player_creature: Sprite2D = $World/PlayerCreature
@onready var defeated_creature: Sprite2D = $World/DefeatedCreature

@onready var confirm_mutation_button: Button = $UILayer/UI/ConfirmMutationButton
@onready var skip_mutation_button: Button = $UILayer/UI/SkipMutationButton
@onready var shift_strand_up_button: Button = $UILayer/UI/ShiftStrandUpButton
@onready var shift_strand_down_button: Button = $UILayer/UI/ShiftStrandDownButton

var strandA: DNAStrand
var strandB: DNAStrand
var strandB_position: int ## relative to strandA


## TODO change parameters to get creature objects - for adding sprites etc.
## strandA -> player creature's strand that will change
## strandB -> slain creature strand that will affect strandA
func load_dna_strands(p_strandA: DNAStrand, p_strandB: DNAStrand) -> void:
	strandB_position = 0
	strandA = p_strandA
	strandB = p_strandB


func _on_confirm_mutation_button_pressed() -> void:
	strandA.combine_strands(strandB, strandB_position)
	mutation_finished.emit()


func _on_skip_mutation_button_pressed() -> void:
	mutation_finished.emit()


func _on_shift_strand_up_button_pressed() -> void:
	strandB_position -= 1


func _on_shift_strand_down_button_pressed() -> void:
	strandB_position += 1
