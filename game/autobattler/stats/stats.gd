class_name Stats extends VBoxContainer

@onready var DamageValueLabel = %DamageValue
@onready var HPValueLabel = %HPValue
@onready var SpeedValueLabel = %SpeedValue


func init_stats(DAMAGE: int, HP: int, SPEED: int) -> void:
	DamageValueLabel.text = str(DAMAGE)
	HPValueLabel.text = str(HP)
	SpeedValueLabel.text = str(SPEED)


func update_HP(new_hp: int) -> void:
	print(new_hp)
	print(typeof(new_hp))
	print(typeof(str(new_hp)))
	var new_hp_str: String = str(new_hp)
	HPValueLabel.text = new_hp_str
