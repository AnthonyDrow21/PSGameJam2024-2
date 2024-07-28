extends TileMap

var GATE_LAYER = 2 # tilemap layer

# note: assuming we only have one gate on this level.
func on_gate_unlocked():
	clear_layer(GATE_LAYER)
