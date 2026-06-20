class_name StatsContainer extends Panel

@onready var NameLabel = %Name
@onready var DamageValueLabel = %DamageValue
@onready var HPValueLabel = %HPValue
@onready var SpeedValueLabel = %SpeedValue


var creature: Creature:
	set(value):
		creature = value
		if not creature.stats_changed.is_connected(_update_stats):
			creature.stats_changed.connect(_update_stats)
		_update_stats()


func _update_stats() -> void:
	NameLabel.text = creature.name
	DamageValueLabel.text = str(creature.damage)
	HPValueLabel.text = str(creature.max_health / 10)
	SpeedValueLabel.text = str(creature.speed)


#func update_hp(new_hp: int) -> void:
	#HPValueLabel.text = str(new_hp)
#	
#func update_dmg(new_dmg: int) -> void:
	#DamageValueLabel.text = str(new_dmg) 
#
#func update_speed(new_speed: int) -> void:
	#SpeedValueLabel.text = str(new_speed) 
