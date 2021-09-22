import csv

birdy = "Mixornis gularis";
data = []

with open('eBird_SG_1986-2020.csv', encoding='utf-8') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        if (row[2] == birdy):
            data.append(row)

with open('test.csv', mode='w') as testfile:
    writer = csv.writer(testfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    for row in data:
        writer.writerow(row)
