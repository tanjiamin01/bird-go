with open('test.txt')as f:
    lines = f.readlines()

data = []

for line in lines:
    line = int(line)
    data.append(line)

#print(data)

import matplotlib.pyplot as plt
plt.hist(data, bins = 24)
plt.show()