# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *
	from .fxtkBuilder import FxtkBuilder
	ext.fxtkBuilder = FxtkBuilder(COMP())

def onCreateBuilder(info: dict):
	return ext.fxtkBuilder.createBuilder(info)
