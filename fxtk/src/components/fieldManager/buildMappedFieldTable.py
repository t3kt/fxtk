def onCook(dat):
	ext.fieldManager.buildMappedFieldTable(
		dat,
		targetTable=dat.inputs[0],
		fieldSourceTable=dat.inputs[1],
		fieldTargetTable=dat.inputs[2])
