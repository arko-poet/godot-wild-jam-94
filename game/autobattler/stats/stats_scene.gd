class_name StatsScene extends VBoxContainer

@onready var NameLabel = %Name
@onready var DamageValueLabel = %DamageValue
@onready var HPValueLabel = %HPValue
@onready var SpeedValueLabel = %SpeedValue


func init_stats(stats: Stats, member_name: String) -> void:
	NameLabel = member_name
	DamageValueLabel.text = str(stats.STRENGTH)
	HPValueLabel.text = str(stats.HP)
	SpeedValueLabel.text = str(stats.SPEED)


func update_hp(new_hp: int) -> void:
	HPValueLabel.text = str(new_hp)

func update_dmg(new_dmg: int) -> void:
	DamageValueLabel.text = str(new_dmg) 

func update_speed(new_speed: int) -> void:
	SpeedValueLabel.text = str(new_speed) 
