import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Activation, Dense, Flatten, Dropout
from tensorflow.keras.optimizers import Adam
import numpy as np
import csv
from tensorflow.keras.utils import to_categorical
import csv
import numpy as np

#NOTE TO BRYAN: PLS USE PYTORCH KERAS IS CHEATING

middle = [1.22,103.48]
no_of_results = 1854
avg = 6837
year_occr = {'1986': 191, '1987': 1245, '1988': 1547, '1989': 1726, '1990': 1597, '1991': 229, '1992': 1651, '1993': 501, '1994': 1748, '1995': 1258, '1996': 828, '1997': 1558, '1998': 1114, '1999': 931, '2000': 2096, '2001': 2146, '2002': 2882, '2003': 2942, '2004': 2791, '2005': 4465, '2006': 3748, '2007': 5854, '2008': 7237, '2009': 7553, '2010': 7764, '2011': 6368, '2012': 7116, '2013': 5981, '2014': 7394, '2015': 10451, '2016': 19962, '2017': 24573, '2018': 31379, '2019': 30284, '2020': 30181}


def quadrants(x,y):
    if x > middle[0]:
        if y > middle[1]:
            return 1
        else:
            return 2
    else:
        if y> middle[1]:
            return 4
        else:
            return 3

def datenormalisation(date):
    datels = date.split('/')
    day_nrmlsed = 1 if int(datels[0]) < 16 else 2
    mth = int(datels[1])
    nmrlsed = day_nrmlsed*mth
    nmrlsed_scr = (avg/year_occr[datels[2][:4]])
    return nmrlsed, nmrlsed_scr



with open('test.csv', encoding='latin-1') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')

    X = np.zeros((1536, 2))
    X_test = np.zeros((no_of_results-1536, 2))

    row_count = 0
    for row in csv_reader:
        if row_count%2 != 0:
            row_count += 1
            continue
        if row_count < 3072:
            #rowdata = []
            loc = quadrants(float(row[3]),float(row[4])) # location
            X[int(row_count/2), 0] = loc

            #row.append(row[5]) # no of occur
            date,score = datenormalisation(row[8])
            X[int(row_count/2), 1] = date
            #row.append(date)
            #row.append(score)

        else:
            loc = quadrants(float(row[3]), float(row[4]))  # location
            X_test[int((row_count-3072)/2), 0] = loc

            # row.append(row[5]) # no of occur
            date, score = datenormalisation(row[8])
            X_test[int((row_count-3072)/2), 1] = date

        row_count+=1

Y = np.ones(1536)
Y_test = np.ones(no_of_results-1536)
print("row count =", row_count)

train_dataset = tf.data.Dataset.from_tensor_slices((X,Y)).batch(1)
val_dataset = tf.data.Dataset.from_tensor_slices((X_test,Y_test)).batch(1)


'''
--------------------------------------------
Training the model
--------------------------------------------
'''

print('Started training...')

from tensorflow.keras.callbacks import EarlyStopping
early_stopping_monitor = EarlyStopping(monitor='val_loss', patience = 2)


model = Sequential([
        Flatten(input_shape = (2,1) ),
        Dense(units = 47, activation = 'tanh'),
        Dense(units = 1, activation = 'softmax')
        ])


model.compile(optimizer = Adam(learning_rate = 0.0001),
              loss='categorical_crossentropy',
              metrics=['accuracy'])


model.fit(x = train_dataset,
          batch_size = 1,
          epochs = 99999,
          shuffle = False,  # Already set to true
          verbose = 2,  # See amount of output messages, 2 = highest, 0 = lowest
          validation_data = val_dataset,
          callbacks = [early_stopping_monitor]
          )


import os.path
if os.path.isfile('test.h5') is False:
    model.save('test.h5')