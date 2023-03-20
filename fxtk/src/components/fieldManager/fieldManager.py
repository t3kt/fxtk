from typing import Optional

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

class FieldManager:
	def __init__(self, ownerComp: 'COMP'):
		self.ownerComp = ownerComp

	def _host(self) -> 'Optional[COMP]':
		return self.ownerComp.par.Hostop.eval()

	def Setuphostparams(self, _=None):
		host = self._host()
		if not host:
			return
		n = int(self.ownerComp.par.Fieldcount)
		targetTable = self.ownerComp.op('targetTable')  # type: DAT
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
				low = (int((i - 1) / maxPerPage) * maxPerPage) + 1
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
			targetTable: 'DAT',
			fieldSourceTable: 'DAT',
			fieldTargetTable: 'DAT'):
		dat.clear()
		dat.appendRow(['target', 'source', 'dataType', 'sourceIndex', 'targetParam'])
		host = self._host()
		if not host:
			return
		if targetTable.numRows < 2 or fieldSourceTable.numRows < 2:
			return
		sourceAndIndexByTarget = {}
		for i in range(0, fieldSourceTable.numRows):
			tgt = fieldTargetTable[i, 1].val
			if tgt == 'none':
				continue
			src = op(fieldSourceTable[i, 1])
			if not src:
				continue
			if tgt in sourceAndIndexByTarget:
				host.addError(f'Multiple fields assigned to {targetTable[tgt, "label"] or tgt}')
				continue
			sourceAndIndexByTarget[tgt] = (src, tdu.digits(fieldSourceTable[i, 0].val))
		for i in range(1, targetTable.numRows):
			tgt = targetTable[i, 'name'].val
			src, srcIndex = sourceAndIndexByTarget.get(tgt) or (None, None)
			src = self._resolveSource(src)
			dat.appendRow([
				tgt,
				src or '',
				targetTable[tgt, 'dataType'],
				srcIndex or '',
				targetTable[tgt, 'targetParam']])

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
