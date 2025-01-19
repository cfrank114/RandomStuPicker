shader_type canvas_item;

uniform float speed;
uniform float freq;
uniform float blurness;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float wavea = sin((TIME*speed)*freq)+1.0;
	float waveb = cos((TIME*speed)*freq)+1.0;
	vec4 pixcolor = texture(TEXTURE,vec2(UV.x*0.8+wavea*0.1,UV.y*0.8+waveb*0.1));
	float t=1.0;
	if(blurness>0.0){
		for (float i=-blurness;i<=blurness;i+=blurness*0.25){
			for (float j=-blurness;j<=blurness;j+=blurness*0.25){
				pixcolor+=texture(TEXTURE,vec2(UV.x*0.8+i+wavea*0.1,UV.y*0.8+j+waveb*0.1));
				t+=1.0;
		}
		}
	}
	COLOR=pixcolor/t;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
