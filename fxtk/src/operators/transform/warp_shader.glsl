#define PI 3.14159265
#define TAU (2*PI)

#define DIRMODE_CARTESIAN 0
#define DIRMODE_POLAR 1
uniform ivec2 uModeReverse = ivec2(DIRMODE_CARTESIAN, 0);

uniform vec4 uMidPointAmountOffset;
uniform vec4 uWeight;  // x,y, dist,angle
uniform float uAmount = 1.;

vec2 cartesianOffset(vec2 src) {
	return src * uWeight.xy;
}

vec2 polarOffset(vec2 src) {
	vec2 pol = src * uWeight.zw;
	float r = pol.x;
	float a = TAU * (pol.y + uMidPointAmountOffset.w);
	return vec2(r * cos(a), r * sin(a));
}

out vec4 fragColor;
void main()
{
	vec2 src = texture(sTD2DInputs[1], vUV.st).rg - uMidPointAmountOffset.xy;
	vec2 offset;
	if (uModeReverse.x == DIRMODE_POLAR) {
		offset = polarOffset(src);
	} else {
		offset = cartesianOffset(src);
	}
	if (uModeReverse.y > 0) offset *= -1.;
	offset *= uMidPointAmountOffset.z;
	fragColor = TDOutputSwizzle(texture(sTD2DInputs[0], vUV.st + offset));
}
