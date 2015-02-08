
extends AnimatedSprite

export var player = -1
export var position_on_map = Vector2(0,0)
var current_map
var health_bar
var icon_shield
var type = 0

var life
var max_life
var attack
var plain
var road
var river
var max_ap
var attack_ap
var max_attacks_number
var ap
var attacks_number

var group = 'unit'

var explosion_template = preload('res://particle/explosion.xscn')
var explosion_big_template = preload('res://particle/explosion_big.xscn')
var explosion
var floating_damage_template = preload('res://particle/hit_points.xscn')
var floating_damage
var die = false
var parent

func set_ap(value):
	ap = value


func get_ap():
	return ap;

func get_player():
	return player

func get_type():
	return type

func get_pos_map():
	return position_on_map
	
func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos())
	return position_on_map

func get_stats():
	return {'life' : life, 'attack' : attack, 'plain' : plain, 'road' : road, 'river' : river, 'ap' : get_ap(), 'attack_ap': attack_ap, 'attacks_number' : attacks_number}

func set_stats(new_stats):
	life = new_stats.life
	attack = new_stats.attack
	ap = new_stats.ap
	attacks_number = new_stats.attacks_number
	update_healthbar()
	update_shield()

func reset_ap():
	ap = max_ap
	attacks_number = max_attacks_number
	update_shield()
	update_healthbar()
	
func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position
	
func can_attack():
	if ap >= attack_ap && attacks_number > 0:
		return true
	return false

func die():
	print('DIED!')

func set_damaged():
	print('DAMAGED!')
	
func update_healthbar():
	var frame = health_bar.get_frame()
	if self.life <= 2:
		health_bar.set_frame(2)
	elif self.life <= 7:
		health_bar.set_frame(1)
	else:
		health_bar.set_frame(0)
	return
	
func show_explosion():
	explosion = explosion_template.instance()
	explosion.unit = self
	self.add_child(explosion)
	
func show_big_explosion():
	explosion = explosion_big_template.instance()
	explosion.unit = self
	self.add_child(explosion)
	current_map.shake_camera()
	
func clear_explosion():
	self.remove_child(explosion)
	explosion.queue_free()
	if die:
		parent.remove_child(self)
		self.queue_free()

func show_floating_damage(amount):
	floating_damage = floating_damage_template.instance()
	floating_damage.set_text(str(amount))
	floating_damage.unit = self
	self.add_child(floating_damage)

func clear_floating_damage():
	self.remove_child(floating_damage)
	floating_damage.queue_free()

func die_after_explosion(ysort):
	die = true
	parent = ysort
	self.show_big_explosion()

func update_shield():
	if ap > 0:
		icon_shield.show()
	else:
		icon_shield.hide()

func _ready():
	add_to_group("units")
	get_node('anim').play("move")
	current_map = get_node("/root/game").current_map_terrain
	health_bar = get_node("health")
	icon_shield = get_node("shield")
	pass


