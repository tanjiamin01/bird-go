import matplotlib.pyplot as plt
import csv

def datenormalisation(date):
    datels = date.split('-')
    day_nrmlsed = 1 if int(datels[2][:3]) < 16 else 2
    mth = int(datels[1])
    nmrlsed = day_nrmlsed*mth
    #nmrlsed_scr = (avg/year_occr[datels[2][:4]])
    return nmrlsed

data = {}

with open('eBirdClean.csv', mode='r', encoding='utf-8') as csv_file:
  csv_reader = csv.reader(csv_file, delimiter=',')
  n=0
  for row in csv_reader:
    try:
      dm = datenormalisation(row[8])
    except:
      n += 1
      continue
    if dm in data:
      data[dm] += 1
    else:
      data[dm] = 1

plt.bar(list(data.keys()), data.values())
plt.show()