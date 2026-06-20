class_name Autobattler extends Node

signal player_won
signal player_lost

const CREATURE_SPRITES := {
	Creature.Species.TURTLE0: "res://assets/art/AssetsArchibald_x2/ArchibaldStand.png",
	Creature.Species.SALAMANDER: "res://assets/art/AssetsSalamander_x2/SalamanderStand.png"
}
const DAMAGE_VARIANCE := 0.2

var ally: Creature
var enemy: Creature

var combat_on := false

@onready var ally_sprite: Sprite2D = %AllySprite
@onready var enemy_sprite: Sprite2D = %EnemySprite

@onready var ally_stats: StatsContainer = %AllyStats
@onready var enemy_stats: StatsContainer = %EnemyStats

@onready var ally_health_bar: CreatureDisplay = %AllyHealthBar
@onready var enemy_health_bar: CreatureDisplay = %EnemyHealthBar

@onready var combat_log: RichTextLabel = %CombatLog

@onready var world: Node2D = $World
@onready var ui: Control = $Overlay/UI

@onready var title_bar: TitleBar = %TitleBar
@onready var win_screen: CanvasLayer = %WinScreen
@onready var combat_result_label = %CombatResultLabel

@onready var archibald_attack: AnimatedSprite2D = $World/ArchibaldAttack
@onready var archibald_hit: AnimatedSprite2D = $World/ArchibaldHit
@onready var enemy_attack: AnimatedSprite2D = $World/EnemyAttack
@onready var enemy_hit: AnimatedSprite2D = $World/EnemyHit

@onready var attack_sound_player: AudioStreamPlayer = $AttackSoundPlayer
@onready var enemy_intro_sound_player: AudioStreamPlayer = $EnemyIntroSoundPlayer


func set_creatures(p_ally: Creature, p_enemy: Creature) -> void:
	ally = p_ally
	enemy = p_enemy
	
	if not ally.died.is_connected(_on_ally_died):
		ally.died.connect(_on_ally_died)
	if not enemy.died.is_connected(_on_ally_died):
		enemy.died.connect(_on_enemy_died)
	
	ally_sprite.texture = Creatures.get_creature_texture(ally)
	enemy_sprite.texture = Creatures.get_creature_texture(enemy)

	enemy_intro_sound_player.stream = Creatures.get_creature_audio(enemy)
	
	ally_stats.creature = ally
	enemy_stats.creature = enemy
	
	ally_health_bar.creature = ally
	enemy_health_bar.creature = enemy
	
	combat_log.clear()
	

## shows/hides scene
func switch_scene(on := true) -> void:
	if on:
		world.show()
		ui.show()
	else:
		world.hide()
		ui.hide()


## shows/hides scene DEPRECATED
#func switch_scene(on := true) -> void:
	#for child in get_children():
		#if child is Control:
			#if on:
				#child.show()
			#else:
				#child.hide()
	#for child in overlay.get_children():
		#if child is Control:
			#if on:
				#child.show()
			#else:
				#child.hide()


func auto_battle() -> void:
	await get_tree().create_timer(0.5).timeout # So the intro sound doesn't play immediately
	enemy_intro_sound_player.play()
	await get_tree().create_timer(0.07).timeout 
	combat_on = true
	while combat_on:
		print(get_tree().paused)
		if not get_tree().paused:
			if ally.speed > enemy.speed:
				for i in ceil(float(ally.speed) / float(enemy.speed)):
					await _do_turn(ally)
				await _do_turn(enemy)
			else:
				for i in ceil(float(enemy.speed) / float(ally.speed)):
					await _do_turn(enemy)
				await _do_turn(ally)

		else:
			await get_tree().create_timer(1.0).timeout # Necessary for this pausing loop, otherwise will freeze up game. Need to refactor for better way




#func auto_battle() -> void:
	#while not enemy_party.is_empty() and not ally_party.is_empty():
		#for party_member in turn_order:
			#if party_member.dead:
				#turn_order.erase(party_member)
				#if party_member in ally_party:
					#ally_party.erase(party_member)
				#else:
					#enemy_party.erase(party_member)
				#continue
#
			#var target_player: PartyMember
			#if party_member in ally_party:
				#target_player = enemy_party[0]
				#if target_player.dead:
					#enemy_party.erase(target_player)
					#turn_order.erase(target_player)
					#continue
			#else:
				#target_player = ally_party[0]
				#if target_player.dead:
					#ally_party.erase(target_player)
					#turn_order.erase(target_player)
					#continue
#
			#party_member.target_player = target_player
			#await get_tree().create_timer(1.0).timeout # TODO band aid to be remove
			#party_member.do_turn(%CombatLog)


func _do_turn(creature: Creature) -> void:
	if not (combat_on and not enemy.dead and not ally.dead):
		return
		
	await get_tree().create_timer(1.0).timeout
	
	attack_sound_player.play()
	
	if creature == ally:
		archibald_attack.show()
		archibald_attack.play()
		await _animate_attack(ally_sprite, true)
		enemy_hit.show()
		enemy_hit.play()
		_animate_knockback(enemy_sprite, false)
	else:
		enemy_attack.show()
		enemy_attack.play()
		await _animate_attack(enemy_sprite, false)
		archibald_hit.show()
		archibald_hit.play()
		_animate_knockback(ally_sprite, true)
	
	var is_crit := creature == ally and randf() < ally.damage * 0.01
	
	var damage = roundi(randf_range(creature.damage * (1.0 - DAMAGE_VARIANCE), creature.damage * (1.0 + DAMAGE_VARIANCE)))
	if is_crit:
		damage *= 2
	
	var combat_text: String
	if is_crit and creature == ally:
		combat_text = "{0} crits for [color=orange][b]{1}[/b][/color]".format(
			[creature.name, damage]
		)
	else:	
		combat_text = "{0} hits for [color=orange]{1}[/color]".format(
			[creature.name, damage]
		)
	combat_log.append_text(combat_text)
	combat_log.newline()
	
	if creature == enemy:
		ally.health -= damage
	else:
		enemy.health -= damage



func _on_ally_died() -> void:
	combat_on = false
	
	_log_death(ally)

	combat_result_label.text = "YOU LOSE!"	
	win_screen.visible = true
	await get_tree().create_timer(3.0).timeout # give enough time for the player to see the lost screen
	print("lost")
	player_lost.emit()
	

func _on_enemy_died() -> void:
	combat_on = false
	
	print(enemy.dead)
	enemy_sprite.texture = Creatures.get_creature_texture(enemy)
	
	_log_death(enemy)
	
	combat_result_label.text = "YOU WIN!"
	win_screen.visible = true
	player_won.emit()


func _log_death(creature: Creature) -> void:
	combat_log.append_text("{0} [color=red][b]DIES[/b][/color]".format([creature.name]))
	combat_log.newline()


func _on_archibald_attack_animation_finished() -> void:
	archibald_attack.hide()


func _on_archibald_hit_animation_finished() -> void:
	archibald_hit.hide()


func _on_enemy_attack_animation_finished() -> void:
	enemy_attack.hide()


func _on_enemy_hit_animation_finished() -> void:
	enemy_hit.hide()


func _animate_knockback(sprite: Sprite2D, is_ally: bool) -> void:
	var tween := create_tween()
	var initial_position = sprite.position
	var direction := 1 if is_ally else -1
	tween.tween_property(sprite, ^"position:x", sprite.position.x + 10 * direction, 0.1)
	tween.tween_property(sprite, ^"position:y", sprite.position.y - 8, 0.1)
	tween.tween_property(sprite, ^"position", initial_position, 0.1)
	

func _animate_attack(sprite: Sprite2D, is_ally: bool) -> void:
	var tween := create_tween()
	var initial_position = sprite.position
	var direction := 1 if is_ally else -1
	tween.tween_property(sprite, ^"position:x", sprite.position.x + 10 * direction, 0.1)
	await tween.tween_property(sprite, ^"position:x", initial_position.x, 0.1)
