# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from infraBuild import BuildTaskContext
	from _stubs import *

context = args[0]  # type: BuildTaskContext

def runStage(stage: int):
	if stage == 0:
		context.log('Processing libraryIndex')
		o = op('libraryIndex')
		context.detachTox(o)
		context.disableCloning(o)
		context.queueCall(lambda: runStage(stage + 1))
	elif stage == 1:
		context.log('Processing palette')
		o = op('libraryPalette')
		context.detachTox(o)
		context.disableCloning(o)
		context.runBuildScript(op('libraryPalette/BUILD'), thenRun=lambda: runStage(stage + 1))
	else:
		context.finishTask()

runStage(0)
