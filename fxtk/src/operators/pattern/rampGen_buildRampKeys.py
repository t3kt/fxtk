# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

remap = tdu.remap

def onCook(dat: 'scriptDAT'):
	dat.clear()
	dat.appendRow(['pos', 'r', 'g', 'b', 'a'])
	m = parent()
	startColor = [m.par.Startcolorr, m.par.Startcolorg, m.par.Startcolorb, m.par.Startcolora]
	endColor = [m.par.Endcolorr, m.par.Endcolorg, m.par.Endcolorb, m.par.Endcolora]
	if m.par.Reverse:
		startColor, endColor = endColor, startColor
	mode = m.par.Keymode.eval()
	if mode == 'simple':
		dat.appendRow([0] + startColor)
		dat.appendRow([1] + endColor)
		return
	if m.par.Midowncolor:
		midColor = [m.par.Midcolorr, m.par.Midcolorg, m.par.Midcolorb, m.par.Midcolora]
	else:
		ratio = m.par.Midcolorratio
		midColor = [
			remap(ratio, 0, 1, startColor[i], endColor[i])
			for i in range(4)
		]
	midPos = m.par.Midpos
	dat.appendRow([0] + startColor)
	if mode == 'midpoint':
		dat.appendRow([midPos] + midColor)
	elif mode == 'midbar':
		midWidth = m.par.Midwidth / 2
		midFade = m.par.Midfadewidth / 2
		dat.appendRow([midPos - midWidth - midFade] + startColor)
		dat.appendRow([midPos - midWidth] + midColor)
		dat.appendRow([midPos + midWidth] + midColor)
		dat.appendRow([midPos + midWidth + midFade] + endColor)
	dat.appendRow([1] + endColor)

