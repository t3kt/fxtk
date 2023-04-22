uniform int stepCompMode;
uniform int tapCount;
// r: active, g: alpha
uniform vec4 uTapVals[8];

#define COMP_ADD 0
#define COMP_ATOP 1
#define COMP_AVERAGE 2
#define COMP_DIFFERENCE 3
#define COMP_INSIDE 4
#define COMP_MAXIMUM 5
#define COMP_MINIMUM 6
#define COMP_MULTIPLY 7
#define COMP_OUTSIDE 8
#define COMP_OVER 9
#define COMP_SCREEN 10
#define COMP_SUBTRACT 11
#define COMP_UNDER 12

bool getTapState(int i) {
	return (tapCount >= (i + 1)) && uTapVals[i].r > 0.;
}

vec4 getTapResult(int i);

vec4[8] getTaps() {
	vec4[8] colors;
	for (int i = 0; i < 8; i++) {
		if (getTapState(i)) {
			float a = uTapVals[i].g;
			colors[i] = getTapResult(i) * vec4(vec3(1.), a);
		} else {
			colors[i] = vec4(0.);
		}
	}
	return colors;
}

vec4 compositeTaps_add(vec4[8] colors) {
	vec4 color = vec4(0.);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color += colors[i];
		}
	}
	return color;
}

vec4 compositeTaps_atop(vec4[8] colors) {
	vec4 color = vec4(0.);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = (color.rgba * colors[i].a) + (colors[i].rgba * (1.0 - color.a));
		}
	}
	return color;
}

vec4 compositeTaps_average(vec4[8] colors) {
	vec4 color = vec4(0.);
	float n = 0.;
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color += colors[i];
			n += 1.;
		}
	}
	return color / max(1., n);
}

vec4 compositeTaps_difference(vec4[8] colors) {
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color.rgb = abs(color.rgb - colors[i].rgb);
		}
	}
	return color;
}

vec4 compositeTaps_inside(vec4[8] colors) {
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = color * clamp(colors[i], 0.0, 1.0);
		}
	}
	return color;
}

vec4 compositeTaps_maximum(vec4[8] colors) {
	vec4 color = vec4(0.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = max(color, colors[i]);
		}
	}
	return color;
}

vec4 compositeTaps_minimum(vec4[8] colors) {
	vec4 color = vec4(1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = min(color, colors[i]);
		}
	}
	return color;
}

vec4 compositeTaps_multiply(vec4[8] colors) {
	vec4 color = vec4(1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = color * colors[i];
		}
	}
	return color;
}

vec4 compositeTaps_outside(vec4[8] colors) {
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = color * (1.0 - colors[i].a);
		}
	}
	return color;
}

vec4 compositeTaps_over(vec4[8] colors) {
	vec4 color = vec4(0.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = (colors[i] * (1.0 - color.a)) + color;
		}
	}
	return color;
}

vec4 compositeTaps_screen(vec4[8] colors) {
	vec4 color = vec4(0.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = 1.0 - ((1.0 - color) * (1.0 - colors[i]));
		}
	}
	return color;
}

vec4 compositeTaps_subtract(vec4[8] colors) {
	vec4 color = vec4(1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = color - colors[i];
		}
	}
	return color;
}

vec4 compositeTaps_under(vec4[8] colors) {
	vec4 color = vec4(1.0);
	for (int i = 0; i < tapCount; i++) {
		if (getTapState(i)) {
			color = (color * (1.0 - colors[i].a)) + colors[i];
		}
	}
	return color;
}

vec4 compositeTaps(vec4[8] colors) {
	vec4 color = vec4(0.0);
	switch (stepCompMode) {
		case COMP_ADD:
			return compositeTaps_add(colors);
		case COMP_ATOP:
			return compositeTaps_atop(colors);
		case COMP_AVERAGE:
			return compositeTaps_average(colors);
		case COMP_DIFFERENCE:
			return compositeTaps_difference(colors);
		case COMP_INSIDE:
			return compositeTaps_inside(colors);
		case COMP_MAXIMUM:
			return compositeTaps_maximum(colors);
		case COMP_MINIMUM:
			return compositeTaps_minimum(colors);
		case COMP_MULTIPLY:
			return compositeTaps_multiply(colors);
		case COMP_OUTSIDE:
			return compositeTaps_outside(colors);
		case COMP_OVER:
			return compositeTaps_over(colors);
		case COMP_SCREEN:
			return compositeTaps_screen(colors);
		case COMP_SUBTRACT:
			return compositeTaps_subtract(colors);
		case COMP_UNDER:
			return compositeTaps_under(colors);
	}
	return color;
}
