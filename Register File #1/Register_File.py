import siliconcompiler                    # import python package

chip = siliconcompiler.Chip('Register_File')  # create chip object
chip.input('Register_File.v')                 # define list of source files
chip.clock('clk', period=10)              # define clock speed of design
chip.load_target('skywater130_demo')      # load predefined technology and flow target
chip.set('option', 'remote', True)        # run remote in the cloud
chip.run()                                # run compilation of design and target
chip.summary()                            # print results summary
chip.show()
