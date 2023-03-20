from typing import Optional

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

class FieldManager:
	def __init__(self, ownerComp: 'COMP'):
		self.ownerComp = ownerComp

	def _targetTable(self) -> 'DAT':
		return self.ownerComp.op('targetTable')

	def _host(self) -> 'Optional[COMP]':
		return self.ownerComp.par.Hostop.eval()

	def Setuphostparams(self, _=None):
		host = self._host()
		if not host:
			return
		n = int(self.ownerComp.par.Fieldcount)
		targetTable = self._targetTable()
		targetNames = ['none']
		targetLabels = ['None']
		for r in range(1, targetTable.numRows):
			targetNames.append(targetTable[r, 'name'].val)
			targetLabels.append(targetTable[r, 'label'].val)
		maxPerPage = 4
		pagesByName = {
			page.name: page
			for page in host.customPages
		}
		for i in range(1, n+1):
			if n <= maxPerPage:
				pageName = 'Fields'
			else:
				low = int((i - 1) / maxPerPage) + 1
				pageName = f'Fields {low}-{low + maxPerPage - 1}'
			page = pagesByName.get(pageName)
			if not page:
				page = host.appendCustomPage(pageName)
				pagesByName[pageName] = page
			par = page.appendMenu(f'Fieldtarget{i}', label=f'Target {i}')[0]
			par.menuNames = targetNames
			par.menuLabels = targetLabels
			par.default = 'none'
			par.startSection = True
			par = page.appendOP(f'Fieldsource{i}', label=f'Source {i}')[0]
			par.enableExpr = f"me.par.Fieldtarget{i} != 'none'"

	def buildMappedFieldTable(
			self, dat: 'DAT',
			fieldSourceTable: 'DAT',
			fieldTargetTable: 'DAT'):
		dat.clear()
		dat.appendRow(['target', 'source', 'dataType'])
		host = self._host()
		if not host:
			return
		targetTable = self._targetTable()
		if targetTable.numRows < 2 or fieldSourceTable.numRows < 2:
			return
		sourcesByTarget = {}
		for i in range(1, fieldSourceTable.numRows):
			tgt = fieldTargetTable[i, 'value'].val
			if tgt == 'none':
				continue
			src = op(fieldSourceTable[i, 'value'])
			if not src:
				continue
			if tgt in sourcesByTarget:
				host.addError(f'Multiple fields assigned to {targetTable[tgt, "label"] or tgt}')
				continue
			sourcesByTarget[tgt] = src
		for i in range(1, targetTable.numRows):
			tgt = targetTable[i, 'name'].val
			src = sourcesByTarget.get(tgt)
			src = self._resolveSource(src)
			if src:
				dat.appendRow([tgt, src, targetTable[tgt, 'dataType']])
			else:
				dat.appendRow([tgt, '', ''])

	def _resolveSource(self, src: 'Optional[OP]') -> 'Optional[OP]':
		if not src:
			return None
		if src.isTOP:
			return src
		if src.isCOMP:
			for name in ('video_out', 'out1'):
				o = src.op(name)
				if o and o.isTOP:
					return o
			for conn in src.outputConnectors:
				if conn.outOP and conn.outOP.isTOP:
					return conn.outOP
		host = self._host()
		if host:
			host.addError(f'Invalid field source: {src}')
