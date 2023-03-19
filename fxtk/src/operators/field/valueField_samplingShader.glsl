#include "fxtkCommon"

uniform float Channel;


out vec4 fragColor;
void main()
{
	vec4 inVec = texture(sTD2DInputs[0], vUV.st);
	float val = getChan(inVec, int(Channel));
	fragColor = TDOutputSwizzle(vec4(vec3(val), 1.));
}
