# Copyright (C) 2014 Swift Navigation Inc.
#
# This source is subject to the license found in the file 'LICENSE' which must
# be be distributed together with this source. All other rights reserved.
#
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.

import numpy as np
cimport numpy as np
cimport observation_c
from libc.string cimport memcpy

cdef class SingleDiff:
  def __init__(self,
               pseudorange,
               carrier_phase,
               doppler,
               np.ndarray[np.double_t, ndim=1, mode="c"] sat_pos, 
               np.ndarray[np.double_t, ndim=1, mode="c"] sat_vel,
               snr,
               prn):
    self.pseudorange = pseudorange
    self.carrier_phase = carrier_phase
    self.doppler = doppler
    self.sat_pos = sat_pos
    self.sat_vel = sat_vel
    self.snr = snr
    self.prn = prn

  def __repr__(self):
    return "<SingleDiff prn=" + str(self.prn) + ", snr=" + str(self.snr) + ">"

  def __dict__(self):
    # Cython doesn't produce dict attributes fothese objects automatically. This
    # flattens out the dict for easy consumption at other sources that can't handle
    # nested arrays.
    return {'pseudorange': self.pseudorange,
            'carrier_phase': self.carrier_phase,
            'doppler': self.doppler,
            'sat_pos_x': self.sat_pos[0],
            'sat_pos_y': self.sat_pos[1],
            'sat_pos_z': self.sat_pos[2],
            'sat_vel_x': self.sat_vel[0],
            'sat_vel_y': self.sat_vel[1],
            'sat_vel_z': self.sat_vel[2],
            'snr': self.snr,
            'prn': self.prn}

  property pseudorange:
    def __get__(self):
        return self.sdiff.pseudorange
    def __set__(self, pseudorange):
        self.sdiff.pseudorange = pseudorange
  
  property carrier_phase:
    def __get__(self):
        return self.sdiff.carrier_phase
    def __set__(self, carrier_phase):
        self.sdiff.carrier_phase = carrier_phase

  property doppler:
    def __get__(self):
        return self.sdiff.doppler
    def __set__(self, doppler):
        self.sdiff.doppler = doppler

  property sat_pos:
    def __get__(self):
      cdef np.ndarray[np.double_t, ndim=1, mode="c"] sat_pos = \
        np.empty(3, dtype=np.double)
      memcpy(&sat_pos[0], self.sdiff.sat_pos, 3 * sizeof(double))
      return sat_pos
    def __set__(self, np.ndarray[np.double_t, ndim=1, mode="c"] sat_pos):
      memcpy(self.sdiff.sat_pos, &sat_pos[0], 3 * sizeof(double))

  property sat_vel:
    def __get__(self):
      cdef np.ndarray[np.double_t, ndim=1, mode="c"] sat_vel = \
        np.empty(3, dtype=np.double)
      memcpy(&sat_vel[0], self.sdiff.sat_vel, 3 * sizeof(double))
      return sat_vel
    def __set__(self, np.ndarray[np.double_t, ndim=1, mode="c"] sat_vel):
      memcpy(self.sdiff.sat_vel, &sat_vel[0], 3 * sizeof(double))

  property snr:
    def __get__(self):
        return self.sdiff.snr
    def __set__(self, snr):
        self.sdiff.snr = snr

  property prn:
    def __get__(self):
      return self.sdiff.prn
    def __set__(self, prn):
      self.sdiff.prn = prn
  