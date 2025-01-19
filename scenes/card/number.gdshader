shader_type canvas_item;

uniform vec4 color : source_color;

void vertex() {
}

void fragment() {
	if (COLOR.a!=0.0){
		COLOR=color;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
