# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def onCook(dat):
	mappedFieldTable = dat.inputs[0]
	dat.clear()
	for i in range(1, mappedFieldTable.numRows):
		tgt = mappedFieldTable[i, 'target']
		srcI = mappedFieldTable[i, 'sourceIndex']
		if not srcI or not tgt:
			continue
		# dat.appendRow([f'#define HAS_INPUT_{tgt}'])
		dataType = mappedFieldTable[i, 'dataType'].val
		expr = _typeExprs.get(dataType)
		if not expr:
			raise Exception(f'Unsupported field data type: {dataType}')
		dat.appendRow([f'#define INPUT_{tgt}(uv)', expr.replace('$', str(srcI))])

_typeExprs = {
	'float': 'float(texture(sTD2DInputs[$], uv).x)',
	'vec2': 'vec2(texture(sTD2DInputs[$], uv).xy)',
	'vec3': 'vec3(texture(sTD2DInputs[$], uv).xyz)',
	'vec4': 'vec4(texture(sTD2DInputs[$], uv))',
}

