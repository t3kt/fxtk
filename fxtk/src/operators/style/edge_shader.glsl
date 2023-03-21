#include "fxtkCommon"

uniform vec4 OffsetBlacklevelStrength;
uniform vec4 Color;

#define mainIn sTD2DInputs[0]

float getInput(vec2 offset) {
	return texture(sTD2DInputs[0], vUV.st + offset).r;
}

float applyBlackLevel(float val) {
	float bl = OffsetBlacklevelStrength.z;
	if (bl >= 1.) return 0.;
	return (1./(1. - bl)) * val - (1./(1. - bl)) * bl;
}

out vec4 fragColor;
void main()
{
	vec2 offset = OffsetBlacklevelStrength.xy * uTDOutputInfo.res.xy;
	float tl = getInput(vec2(-offset.x, offset.y));
	float t = getInput(vec2(0., offset.y));
	float tr = getInput(vec2(offset.x, offset.y));
	float l = getInput(vec2(-offset.x, 0.));
	float r = getInput(vec2(offset.x, 0.));
	float bl = getInput(vec2(-offset.x, -offset.y));
	float b = getInput(vec2(0., -offset.y));
	float br = getInput(vec2(offset.x, -offset.y));

//	tl = applyBlackLevel(tl);
//	t = applyBlackLevel(t);
//	tr = applyBlackLevel(tr);
//	l = applyBlackLevel(l);
//	r = applyBlackLevel(r);
//	bl = applyBlackLevel(bl);
//	b = applyBlackLevel(b);
//	br = applyBlackLevel(br);

	float horz = br + (2.0*r) + tr - (bl + (2.0*l) + tl);
	float vert = bl + (2.0*b) + br - (tl + (2.0*t) + tr);
	horz *= OffsetBlacklevelStrength.w;
	vert *= OffsetBlacklevelStrength.w;

	float blackLevel = OffsetBlacklevelStrength.z;
	blackLevel = 0.;
//	float edge = sqrt((horz * horz) + (vert * vert));
	float edge = clamp(sqrt(horz + vert) + blackLevel, 0., 1.);

	vec4 color = Color * edge;
	fragColor = TDOutputSwizzle(color);
}
/*

	bl = texture2D(tex, coord + vec2( -w, -h));
	b = texture2D(tex, coord + vec2(0.0, -h));
	br = texture2D(tex, coord + vec2(  w, -h));
	l = texture2D(tex, coord + vec2( -w, 0.0));
	n[4] = texture2D(tex, coord);
	r = texture2D(tex, coord + vec2(  w, 0.0));
	tl = texture2D(tex, coord + vec2( -w, h));
	t = texture2D(tex, coord + vec2(0.0, h));
	tr = texture2D(tex, coord + vec2(  w, h));
}

void main(void) 
{
	vec4 n[9];
	make_kernel( n, texture, gl_TexCoord[0].st );

	vec4 sobel_edge_h = br + (2.0*r) + tr - (bl + (2.0*l) + tl);
  	vec4 sobel_edge_v = bl + (2.0*b) + br - (tl + (2.0*t) + tr);
*/