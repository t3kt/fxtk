def onPulse(par):
	o = parent()
	o.par.Inputrange1 = op('analyzeMin').sample(x=0,y=0)[0]
	o.par.Inputrange2 = op('analyzeMax').sample(x=0,y=0)[0]
	