# -*- coding: utf-8 -*-
"""
  disc1.py generated by WhatsOpt. 
"""
from disc1_base import Disc1Base

class Disc1(Disc1Base):
    """ An OpenMDAO component to encapsulate Disc1 discipline """
		
    def compute(self, inputs, outputs):
        """ Disc1 computation """
        z1 = inputs['z'][0]
        z2 = inputs['z'][1]
        x = inputs['x']
        y2 = inputs['y2']
        outputs['y1'] = z1**2 + z2 + x - 0.2*y2   

				
        
