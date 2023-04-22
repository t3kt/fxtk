#include "fxtkCommon"

#define W_OFFSET  uTD3DInfos[0].depth.z

#include "multiTapEffect"

vec4 getDelayed(float l) {
	return texture(sTD3DInputs[0], vec3(vUV.st, l + W_OFFSET));
}

vec4 getTapResult(int i) {
	float l = uTapVals[i].b;
	return getDelayed(l);
}

out vec4 fragColor;
void main()
{
	vec4 outColor;
	if (tapCount > 0) {
		vec4[8] colors = getTaps();
		outColor = compositeTaps(colors);
	} else {
		outColor = getDelayed(0.);
	}
	fragColor = TDOutputSwizzle(outColor);
}
