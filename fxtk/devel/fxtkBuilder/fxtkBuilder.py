from infraBuild import Builder
from infraCommon import Action
from typing import Callable, Optional

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *
	from _typeAliases import *
	from libraryTools.libraryTools import LibraryTools

	# noinspection PyTypeHints
	iop.libraryTools = LibraryTools(COMP())  # type: Union[LibraryTools, COMP]

class FxtkBuilder:
	def __init__(self, ownerComp: 'COMP'):
		self.ownerComp = ownerComp

	def createBuilder(self, info: dict):
		buildManager = info['buildManager']
		log = info['log']
		updateStatus = info['updateStatus']

		context = iop.libraryTools.GetLibraryContext()
		name = context.libraryName
		if not name:
			return
		srcTox = 'fxtk/src/fxtk.tox'
		return _FxtkBuilderImpl(
			log=log,
			updateStatus=updateStatus,
			libraryName=name,
			sourceToxPath=srcTox,
		)

	def Openwindow(self, _=None):
		self.ownerComp.op('window').par.winopen.pulse()

class _FxtkBuilderImpl(Builder):
	def __init__(
			self,
			log: Optional[Callable[[str], None]],
			updateStatus: Callable[[str], None],
			libraryName: str,
			sourceToxPath: str,
	):
		super().__init__(
			log=log,
			updateStatus=updateStatus,
			libraryName=libraryName,
			sourceToxPath=sourceToxPath,
			buildDirPath='build/',
			paneName='infraBuildPane',
		)

	def runBuildStage(self, stage: int, thenRun: Callable):
		continueAction = Action(self.runBuildStage, [stage + 1, thenRun])
		library = self.getLibraryRoot()
		if stage == 0:
			self.context.detachAllFileSyncDats(library)
			self.queueCall(continueAction)
		elif stage == 1:
			# TODO: clear old docs?
			self._updateLibraryInfo(library)
			self.context.detachTox(library.op('libraryMeta'))
			self.context.disableCloning(library.op('libraryMeta'))
			self.queueCall(continueAction)
		elif stage == 2:
			# TODO: update library image?
			self.processPackages(continueAction)
		elif stage == 3:
			self.context.lockBuildLockOps(library)
			self.queueCall(continueAction)
		elif stage == 4:
			self.context.detachTox(library.op('tools'))
			self.context.runBuildScript(library.op('tools/BUILD'), continueAction)
		elif stage == 5:
			self.context.removeBuildExcludeOps(library)
			self.queueCall(continueAction)
		elif stage == 6:
			try:
				library.op('components').destroy()
			except:
				pass
			self.queueCall(continueAction)
		elif stage == 7:
			self.finalizeLibraryPars()
			self.queueCall(continueAction)
		elif stage == 8:
			self.exportLibraryTox()
			self.context.closeNetworkPane()
			self.queueCall(thenRun)
		else:
			self.queueCall(thenRun)

	def _updateLibraryInfo(self, library: COMP):
		pass

	def processCompImpl(self, comp: 'COMP', thenRun: Callable):
		# TODO: showCustomOnly?
		iop.libraryTools.UpdateComponentMetadata(comp)
		# TODO: update comp params
		self._updateComponentParams(comp)
		self.context.resetCustomPars(comp)
		# TODO: lock buildLock pars

		for o in comp.findChildren(type=COMP, maxDepth=0):
			self.context.detachTox(o)
			self.context.disableCloning(o)
		iop.libraryTools.UpdateComponentMetadata(comp)
		# TODO: process sub components
		# TODO: update op image
		# TODO: set comp color
		# TODO: process docs

		self.queueCall(thenRun)

	def _updateComponentParams(self, comp: 'COMP'):
		self.log(f'Updating component params {comp}')
		comp.par.enablecloning = False
		comp.par.reloadtoxonstart.expr = ''
		comp.par.reloadtoxonstart.val = False
		comp.par.reloadcustom.expr = ''
		comp.par.reloadcustom.val = False
		comp.par.reloadbuiltin.expr = ''
		comp.par.reloadbuiltin.val = False
