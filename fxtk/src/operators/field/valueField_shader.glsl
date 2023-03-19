#include "fxtkCommon"

uniform vec3 ChannelInputrange;
uniform float Enablelevels;
uniform vec4 BlacklevelBrightnessContrastGamma;
uniform vec3 OutputrangeClamptype;

out vec4 fragColor;
void main()
{
	vec4 inVec = texture(sTD2DInputs[0], vUV.st);
	float val = getChan(inVec, int(ChannelInputrange.x));
	val = mapRange(val, ChannelInputrange.y, ChannelInputrange.z, 0., 1.);
	if (IS_TRUE(Enablelevels)) {
		float bl = BlacklevelBrightnessContrastGamma.x;
		if (bl >= 1.) {
			val = 0.;
		} else {
			val = (1./(1. - bl)) * val - (1./(1. - bl) * bl);
		}
		val *= BlacklevelBrightnessContrastGamma.y;
		val = ((val - .5) * BlacklevelBrightnessContrastGamma.z) + .5;
		val = pow(val, 1./BlacklevelBrightnessContrastGamma.w);
	}
	val = mapRange(val, 0., 1., OutputrangeClamptype.x, OutputrangeClamptype.y);
	val = applyClamp(val, OutputrangeClamptype.xy, int(OutputrangeClamptype.z));
	fragColor = TDOutputSwizzle(vec4(vec3(val), 1.));
}
