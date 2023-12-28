extends Node
class_name BodyUtils

enum WALL {
	NONE = 0, LEFT = -1, RIGHT = 1
}

static func is_on_wall(state: PhysicsDirectBodyState2D):
	return get_wall(state) != WALL.NONE
	
static func get_wall(state: PhysicsDirectBodyState2D):
	var contact_count = state.get_contact_count()
	
	if contact_count == 0: 
		return WALL.NONE
		
	for i in range(contact_count):
		var contact_normal = state.get_contact_local_normal(i)
		if abs(contact_normal.dot(Vector2.LEFT)) > 0.5:
			var contact_position = state.get_contact_local_position(i)
			return sign(contact_position.x - state.transform.get_origin().x)
	
	return WALL.NONE

static func is_on_floor(state: PhysicsDirectBodyState2D):
	var contact_count = state.get_contact_count()
	
	if state.get_contact_count() == 0: 
		return false
		
	for i in range(contact_count):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2.UP) > 0.5:
			return true
	
	return false
