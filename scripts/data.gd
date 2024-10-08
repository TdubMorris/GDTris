extends Node

enum Tetros {
	I, L, J, O, S, T, Z
}

# Tetrominos
var Cells = {
	
	Tetros.I: [
		[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)],
		[Vector2i(1,-1), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)],
		[Vector2i(-1,1), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],
		[Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1), Vector2i(0,2)]
	],
	
	Tetros.L: [
		[Vector2i(1,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)],
		[Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1), Vector2i(1,1)],
		[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(-1,1)],
		[Vector2i(-1,-1), Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1)]
	],
	
	Tetros.J:  [
		[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)],
		[Vector2i(0,-1), Vector2i(1,-1), Vector2i(0,0), Vector2i(0,1)],
		[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(1,1)],
		[Vector2i(0,-1), Vector2i(0,0), Vector2i(-1,1), Vector2i(0,1)]
	],
	
	Tetros.O: [
		[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,-1), Vector2i(0,0)],
		[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,-1), Vector2i(0,0)],
		[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,-1), Vector2i(0,0)],
		[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,-1), Vector2i(0,0)]
	],
	
	Tetros.S:  [
		[Vector2i(0,-1), Vector2i(1,-1), Vector2i(-1,0), Vector2i(0,0)],
		[Vector2i(0,-1), Vector2i(0,0), Vector2i(1,0), Vector2i(1,1)],
		[Vector2i(0,0), Vector2i(1,0), Vector2i(-1,1),Vector2i(0,1)],
		[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1)]
	],
	
	Tetros.T: [
		[Vector2i(0,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)],
		[Vector2i(0,-1), Vector2i(0,0), Vector2i(1,0), Vector2i(0,1)],
		[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(0,1)],
		[Vector2i(0,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1)]
	],
	
	Tetros.Z: [
		[Vector2i(-1,-1), Vector2i(0,-1), Vector2i(0,0), Vector2i(1,0)],
		[Vector2i(1,-1), Vector2i(0,0), Vector2i(1,0), Vector2i(0,1)],
		[Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1), Vector2i(1,1)],
		[Vector2i(0,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(-1,1)]
	]
}

# Rotation Test for SRS (index corrisponds with new rotation index)
var cw_test := [
	[Vector2i(0,0), Vector2i(-1,0), Vector2i(-1,1), Vector2i(0,-2), Vector2i(-1,-2)], #L->0
	[Vector2i(0,0), Vector2i(-1,0), Vector2i(-1,-1), Vector2i(0,2), Vector2i(-1,2)], #0->R
	[Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(0,-2), Vector2i(1,-2)], #R->2
	[Vector2i(0,0), Vector2i(1,0), Vector2i(1,-1), Vector2i(0,2), Vector2i(1,2)], #2->L
]

var cw_test_I := [
	[Vector2i(0,0), Vector2i(1,0), Vector2i(-2,0), Vector2i(1,2), Vector2i(-2,-1)], #L->0
	[Vector2i(0,0), Vector2i(-2,0), Vector2i(1,0), Vector2i(-2,1), Vector2i(1,-2)], #0->R
	[Vector2i(0,0), Vector2i(-1,0), Vector2i(2,0), Vector2i(-1,-2), Vector2i(2,1)], #R->2
	[Vector2i(0,0), Vector2i(2,0), Vector2i(-1,0), Vector2i(2,-1), Vector2i(-1,2)] #2->L
]

# --- Global control settings for keyboard

#Speed settings in ms
var ARR : float = 2.0
var DAS : float = 8.0
var SDF : float = 7.0
 
