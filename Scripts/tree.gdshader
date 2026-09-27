shader_type spatial;

uniform float i : hint_range(0.0, 1.0, 0.1);

uniform vec3 dark : source_color;
uniform vec3 bright : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = mix(dark,bright,i);
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
