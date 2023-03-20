#include "fxtkCommon"

uniform vec4 BlacklevelBrightnessContrastGamma;
uniform vec4 InvertOpacityHueoffsetSaturation;

out vec4 fragColor;
void main()
{
	vec4 inColor = texture(sTD2DInputs[0], vUV.st);
	vec3 color = inColor.rgb;
	float inv = InvertOpacityHueoffsetSaturation.x;
	color = mapRange(color, vec3(0.), vec3(1.), vec3(inv), vec3(1.) - inv);
	float bl = BlacklevelBrightnessContrastGamma.x;
	if (bl >= 1.) {
		color = vec3(0.);
	} else {
		color = vec3(1./(1. - bl)) * color - vec3(1./(1. - bl)) * bl;
	}
	color *= BlacklevelBrightnessContrastGamma.y;
	color = pow(color, vec3(1./BlacklevelBrightnessContrastGamma.w));
	color = ((color - .5) * max(BlacklevelBrightnessContrastGamma.z, 0.)) + .5;
//	vec3 hsv = TDRGBToHSV(color);
//	hsv.y *= InvertOpacityHueoffsetSaturation.w;
//	hsv.x += radians(InvertOpacityHueoffsetSaturation.y);
//	color = TDHSVToRGB(hsv);
	color = czm_hue(color, radians(-InvertOpacityHueoffsetSaturation.z));
	color = czm_saturation(color, InvertOpacityHueoffsetSaturation.w);
	vec4 outColor = vec4(color, inColor.a);
	outColor *= InvertOpacityHueoffsetSaturation.y;
	fragColor = TDOutputSwizzle(outColor);
}
