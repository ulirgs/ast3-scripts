#!/usr/bin/env python
# coding: utf-8
#-----------------------------------------------------------------------
# NAME:
#   altsun365
# PURPOSE:
#   To give the sun and moon's position in the horizontal coordinate
#system during 1 year
#
# USAGE:
#   python altsun365.py YEAR
#   e.g. python altsun365.py 2016
#
# INPUTS:
#   YEAR: the number of year, e.g. 2017
#
# OUTPUTS:
#   YEAR_altsun365.dat: it has these columns：
#   #DJD, sunAz, sunAlt ,moonAz ,moonAlt, moon Phase
#   (units: day, degree, degree , degree , degree, percent)
#   DJD is the Dublin Julian Day, which is the JD − 2415020. 
#
# OPTIONAL INPUTS:
#
# COMMENTS:
# 
# PROCEDURES DEPENDS:
#   python-ephem, python-numpy
#   add Domea info to the file cities.py
#
# REVISION HISTORY:
#   29-Jan-2016 Written by weipeng
#-----------------------------------------------------------------------


import time  # time
from math import *  # fabs
import math  # math
import numpy as np
import ephem  # astronomy
import sys

year=sys.argv[1]

pi = math.pi
t3 = np.arange(365 * 24. *60.) / (24. *60.) + \
    float(ephem.Date(str(year)+'/1/1 0:0:0'))  # 约化儒略日MJD

mPhase = []
sunAlt = []
sunAz = []
moonAlt= []
moonAz= []
mPhase = []
#tstr = []

cityObs = ephem.city("Domea")

for n in range(0, len(t3)):
    cityObs.date = ephem.Date(t3[n])
    # the zenith Ra and Dec at local time
    domeaRa = float(cityObs.sidereal_time())
    domeaDec = float(cityObs.lat)
    domeaRaAng = domeaRa * 360. / (2 * pi)
    domeaDecAng = domeaDec * 360. / (2 * pi)
    sun, moon = ephem.Sun(), ephem.Moon()

    sun.compute(cityObs)
    moon.compute(cityObs)

    mRa = float(moon.ra)
    mDec = float(moon.dec)
    sunRa = float(sun.ra)
    sunDec = float(sun.dec)
    mPhase.append(moon.phase / 100)
    sunAlt.append(float(sun.alt) * 360. / (2. * pi))
    sunAz.append(float(sun.az) * 360. / (2. * pi))
    moonAlt.append(float(moon.alt) * 360. / (2. * pi))
    moonAz.append(float(moon.az) * 360. / (2. * pi))
#    tstr.append("%21s" % (cityObs.date))

# compute the angle between the zenith and the Moon
# sZM = ephem.separation((domeaRa, domeaDec), (mRa, mDec))

out = np.column_stack((t3, sunAz, sunAlt ,moonAz ,moonAlt, mPhase))
np.savetxt("./"+year+"_altsun365.dat", out, delimiter="\t", fmt=("%s"))
