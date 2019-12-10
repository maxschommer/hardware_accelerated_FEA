import numpy as np
import matplotlib.pyplot as plt
from res import t_profile

t_profile = np.asarray(t_profile)
t_max = np.max(t_profile)
t_min = np.min(t_profile)


fig= plt.figure()

axes= fig.add_axes([0.1,0.1,0.8,0.8])

for t in t_profile:
    axes.plot(t)
    axes.set_ylim([t_min,t_max])
    plt.xlabel("Position")
    plt.ylabel("Temperature")
    plt.pause(.05)

    plt.cla()