# -*- coding: utf-8 -*-
"""
  run_screening.py generated by WhatsOpt. 
"""
# DO NOT EDIT unless you know what you are doing
# analysis_id: 44

import sys
import numpy as np
import matplotlib.pyplot as plt
from openmdao.api import Problem, SqliteRecorder, CaseReader
from whatsopt.salib_doe_driver import SalibDoeDriver
from SALib.analyze import morris as ma
from SALib.plotting import morris as mp

from sellar import Sellar 


pb = Problem(Sellar())
pb.driver = SalibDoeDriver(n_trajs=10, n_levels=4, grid_step_size=1)
case_recorder_filename = 'sellar_screening.sqlite'        
recorder = SqliteRecorder(case_recorder_filename)
pb.driver.add_recorder(recorder)
pb.model.add_recorder(recorder)
pb.model.nonlinear_solver.add_recorder(recorder)


pb.model.add_design_var('x', lower=0, upper=10)
pb.model.add_design_var('z', lower=0, upper=10)

pb.model.add_objective('obj')


pb.model.add_constraint('g1', upper=0.)
pb.model.add_constraint('g2', upper=0.)

pb.setup()  
pb.run_driver()        

reader = CaseReader(case_recorder_filename)
cases = reader.system_cases.list_cases()
n = len(cases)
data = {'inputs': {}, 'outputs': {} }

data['inputs']['x'] = np.zeros((n,)+(1,))

data['inputs']['z'] = np.zeros((n,)+(2,))


data['outputs']['obj'] = np.zeros((n,)+(1,))

data['outputs']['g1'] = np.zeros((n,)+(1,))

data['outputs']['g2'] = np.zeros((n,)+(1,))


for i, case_id in enumerate(cases):
    case = reader.system_cases.get_case(case_id)

    data['inputs']['x'][i,:] = case.inputs['x']

    data['inputs']['z'][i,:] = case.inputs['z']


    data['outputs']['obj'][i,:] = case.outputs['obj']

    data['outputs']['g1'][i,:] = case.outputs['g1']

    data['outputs']['g2'][i,:] = case.outputs['g2']


salib_pb = pb.driver.get_salib_problem()
inputs = pb.driver.get_cases()


print('*** Output: obj')
output = data['outputs']['obj'].reshape((-1,))
Si = ma.analyze(salib_pb, inputs, output, print_to_console=True)
fig, (ax1, ax2) = plt.subplots(1,2)
fig.suptitle('obj '+'sensitivity')
mp.horizontal_bar_plot(ax1, Si, {})
mp.covariance_plot(ax2, Si, {})


print('*** Output: g1')
output = data['outputs']['g1'].reshape((-1,))
Si = ma.analyze(salib_pb, inputs, output, print_to_console=True)
fig, (ax1, ax2) = plt.subplots(1,2)
fig.suptitle('g1 '+'sensitivity')
mp.horizontal_bar_plot(ax1, Si, {})
mp.covariance_plot(ax2, Si, {})


print('*** Output: g2')
output = data['outputs']['g2'].reshape((-1,))
Si = ma.analyze(salib_pb, inputs, output, print_to_console=True)
fig, (ax1, ax2) = plt.subplots(1,2)
fig.suptitle('g2 '+'sensitivity')
mp.horizontal_bar_plot(ax1, Si, {})
mp.covariance_plot(ax2, Si, {})



plt.show()
