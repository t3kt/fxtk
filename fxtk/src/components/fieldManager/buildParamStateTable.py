# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def onCook(dat: 'DAT'):
	mappedFieldTable = dat.inputs[0]
	dat.clear()
	for i in range(1, mappedFieldTable.numRows):
		par = mappedFieldTable[i, 'targetParam']
		if not par:
			continue
		dat.appendRow([
			par,
			int(bool(mappedFieldTable[i, 'source'].val))
		])
