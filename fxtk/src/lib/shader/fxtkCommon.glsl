// https://github.com/CesiumGS/cesium/blob/master/Source/Shaders/Builtin/Functions/
float czm_luminance(vec3 rgb)
{
	// Algorithm from Chapter 10 of Graphics Shaders.
	const vec3 W = vec3(0.2125, 0.7154, 0.0721);
	return dot(rgb, W);
}
vec3 czm_saturation(vec3 rgb, float adjustment)
{
	// Algorithm from Chapter 16 of OpenGL Shading Language
	const vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 intensity = vec3(dot(rgb, W));
	return mix(intensity, rgb, adjustment);
}
// adjustment is in radians
vec3 czm_hue(vec3 rgb, float adjustment)
{
	const mat3 toYIQ = mat3(0.299,     0.587,     0.114,
	0.595716, -0.274453, -0.321263,
	0.211456, -0.522591,  0.311135);
	const mat3 toRGB = mat3(1.0,  0.9563,  0.6210,
	1.0, -0.2721, -0.6474,
	1.0, -1.107,   1.7046);

	vec3 yiq = toYIQ * rgb;
	float hue = atan(yiq.z, yiq.y) + adjustment;
	float chroma = sqrt(yiq.z * yiq.z + yiq.y * yiq.y);

	vec3 color = vec3(yiq.x, chroma * cos(hue), chroma * sin(hue));
	return toRGB * color;
}

// Maximum/minumum elements of a vector
float vmax(vec2 v) {
	return max(v.x, v.y);
}

float vmax(vec3 v) {
	return max(max(v.x, v.y), v.z);
}

float vmax(vec4 v) {
	return max(max(v.x, v.y), max(v.z, v.w));
}

float vmin(vec2 v) {
	return min(v.x, v.y);
}

float vmin(vec3 v) {
	return min(min(v.x, v.y), v.z);
}

float vmin(vec4 v) {
	return min(min(v.x, v.y), min(v.z, v.w));
}

// https://github.com/msfeldstein/glsl-map/blob/master/index.glsl

float mapRange(float value, float inMin, float inMax, float outMin, float outMax) {
	return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec2 mapRange(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
	return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec3 mapRange(vec3 value, vec3 inMin, vec3 inMax, vec3 outMin, vec3 outMax) {
	return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec4 mapRange(vec4 value, vec4 inMin, vec4 inMax, vec4 outMin, vec4 outMax) {
	return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

float wrapRange(float value, float low, float high) {
	return low + mod(value - low, high - low);
}

vec2 wrapRange(vec2 value, vec2 low, vec2 high) {
	return low + mod(value - low, high - low);
}

vec3 wrapRange(vec3 value, vec3 low, vec3 high) {
	return low + mod(value - low, high - low);
}

vec4 wrapRange(vec4 value, vec4 low, vec4 high) {
	return low + mod(value - low, high - low);
}

float modZigZag(float p) {
	float modded = mod(p, 2.);
	if (modded > 1) {
		return 2 - modded;
	}
	return modded;
}

vec2 modZigZag(vec2 p) {
	vec2 modded = mod(p, 2.);
	return vec2(
	modded.x > 1 ? (2 - modded.x) : modded.x,
	modded.y > 1 ? (2 - modded.y) : modded.y);
}

vec3 modZigZag(vec3 p) {
	vec3 modded = mod(p, 2.);
	return vec3(
	modded.x > 1 ? (2 - modded.x) : modded.x,
	modded.y > 1 ? (2 - modded.y) : modded.y,
	modded.z > 1 ? (2 - modded.z) : modded.z);
}

vec4 modZigZag(vec4 p) {
	vec4 modded = mod(p, 2.);
	return vec4(
	modded.x > 1 ? (2 - modded.x) : modded.x,
	modded.y > 1 ? (2 - modded.y) : modded.y,
	modded.z > 1 ? (2 - modded.z) : modded.z,
	modded.w > 1 ? (2 - modded.w) : modded.w);
}

float modZigZag(float p, float low, float high) {
	p -= low;
	float range = high - low;
	float modded = mod(p, range * 2.);
	if (modded > range) {
		return low + (range * 2. - modded);
	}
	return low + modded;
}

vec2 modZigZag(vec2 p, vec2 low, vec2 high) {
	p -= low;
	vec2 range = high - low;
	vec2 range2 = range * 2.;
	vec2 modded = mod(p, range2);
	return low + vec2(
	modded.x > range.x ? (range2.x - modded.x): modded.x,
	modded.y > range.y ? (range2.y - modded.y): modded.y);
}

vec3 modZigZag(vec3 p, vec3 low, vec3 high) {
	p -= low;
	vec3 range = high - low;
	vec3 range2 = range * 2.;
	vec3 modded = mod(p, range2);
	return low + vec3(
	modded.x > range.x ? (range2.x - modded.x): modded.x,
	modded.y > range.y ? (range2.y - modded.y): modded.y,
	modded.z > range.z ? (range2.z - modded.z): modded.z);
}

vec4 modZigZag(vec4 p, vec4 low, vec4 high) {
	p -= low;
	vec4 range = high - low;
	vec4 range2 = range * 2.;
	vec4 modded = mod(p, range2);
	return low + vec4(
	modded.x > range.x ? (range2.x - modded.x): modded.x,
	modded.y > range.y ? (range2.y - modded.y): modded.y,
	modded.z > range.z ? (range2.z - modded.z): modded.z,
	modded.w > range.w ? (range2.w - modded.w): modded.w);
}

bool IS_TRUE(float x) { return x >= 0.5; }
bool IS_TRUE(int x) { return x > 0; }
bool IS_TRUE(bool x) { return x; }
bool IS_FALSE(float x) { return x < 0.5; }
bool IS_FALSE(int x) { return x == 0; }
bool IS_FALSE(bool x) { return !x; }

const int CHAN_red = 0;
const int CHAN_green = 1;
const int CHAN_blue = 2;
const int CHAN_alpha = 3;
const int CHAN_luminance = 4;
const int CHAN_rgbaverage = 5;
const int CHAN_rgbaaverage = 6;
const int CHAN_rgbminimum = 7;
const int CHAN_rgbaminimum = 8;
const int CHAN_rgbmaximum = 9;
const int CHAN_rgbamaximum = 10;
const int CHAN_length = 11;

float getChan(vec4 val, int chan) {
	switch (chan) {
		case CHAN_red: return val.r;
		case CHAN_green: return val.g;
		case CHAN_blue: return val.b;
		case CHAN_alpha: return val.a;
		case CHAN_luminance: return czm_luminance(val.rgb);
		case CHAN_rgbaverage: return (val.r + val.g + val.b) / 3.;
		case CHAN_rgbaaverage: return (val.r + val.g + val.b + val.a) / 4.;
		case CHAN_rgbminimum: return vmin(val.rgb);
		case CHAN_rgbaminimum: return vmin(val.rgba);
		case CHAN_rgbmaximum: return vmax(val.rgb);
		case CHAN_rgbamaximum: return vmax(val.rgba);
		case CHAN_length: return length(val);
		default: return 0.;
	}
}

const int CLAMP_off = 0;
const int CLAMP_clamp = 1;
const int CLAMP_loop = 2;
const int CLAMP_zigzag = 3;

float applyClamp(float val, vec2 range, int mode) {
	switch (mode) {
		case CLAMP_clamp: return clamp(val, range.x, range.y);
		case CLAMP_loop: return wrapRange(val, range.x, range.y);
		case CLAMP_zigzag: return modZigZag(val, range.x, range.y);
		case CLAMP_off:
		default: return val;
	}
}
