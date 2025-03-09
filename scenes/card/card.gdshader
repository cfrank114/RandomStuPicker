shader_type canvas_item;

// Noise Texture
uniform sampler2D noise_tex;
// Glow speed
uniform float speed: hint_range(0, 5) = 1.0;
// Intensity
uniform float intensity: hint_range(0, 2) = 1.0;
uniform vec4 glow_color: source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform float edge_threshold: hint_range(0, 1) = 0.5;
uniform float delta : hint_range(0,1)=0.0;


void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    float edge = smoothstep(edge_threshold - 0.1, edge_threshold + 0.1, tex_color.a);
    
    vec2 noise_uv = UV * 2.0;
    noise_uv.y += TIME * speed * 0.2;
    
    float noise = texture(noise_tex, noise_uv).r;
    
    float flow = sin(UV.x * 15.0 + TIME * speed * 4.0 + noise * 5.0 + delta) * 0.5 + 0.5+sin(UV.y * 15.0 + TIME * speed * 4.0 + noise * 5.0 + delta) * 0.5 + 0.5;
    
    float final_glow = flow * noise * edge * intensity;
    
    vec3 dynamic_color = glow_color.rgb * (sin(TIME * 2.0) * 0.3 + 0.7);
    
    COLOR.rgb = tex_color.rgb + dynamic_color * final_glow;
    COLOR.a = tex_color.a + final_glow * 0.5;
}