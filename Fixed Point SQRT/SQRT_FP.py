import siliconcompiler

chip = siliconcompiler.Chip('SQRT_FP')
chip.input('SQRT_FP.v')
chip.clock('clk', preiod = 10)
chip.load_target('skywater130_demo')
chip.set('option','remote',True)
chip.run()
chip.summary()