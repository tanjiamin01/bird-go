import csv
import json

birdy = [['Egretta sacra', 'Pacific Reef Heron', 2, 0.500001911772415, 1.39666666666, 103.88], ['Cacomantis merulinus', 'Plaintive Cuckoo', 2, 0.50390625, 1.39666666666, 103.88], ['Tachybaptus ruficollis', 'Little Grebe', 3, 0.9418202638626099, 1.39666666666, 103.88], ['Tringa nebularia', 'Common Greenshank', 1, 0.13212, 1.39666666666, 103.72], ['Tringa totanus', 'Common Redshank', 1, 0.06298828125, 1.39666666666, 103.72], ['Motacilla tschutschensis', 'Eastern Yellow Wagtail', 1, 0.0001220703125, 1.39666666666, 103.72], ['Tachybaptus ruficollis', 'Little Grebe', 3, 0.03149417042732239, 1.33666666666, 103.72], ['Egretta sacra', 'Pacific Reef Heron', 2, 0.017822265625, 1.33666666666, 103.72], ['Cacomantis merulinus', 'Plaintive Cuckoo', 2, 0.0628090356476605, 1.33666666666, 103.72], ['Cuculus micropterus', 'Indian Cuckoo', 2, 0.8911743292119354, 1.33666666666, 103.88], ['Gracula religiosa', 'Common Hill Myna', 2, 0.9142514476552606, 1.33666666666, 103.88], ['Dicrurus annectens', 'Crow-billed Drongo', 2, 0.93605059501715, 1.33666666666, 103.88]]

def toJSON(row, count):

    rating = 0
    for bird in birdy:
        if row[2]==bird[0]:
            rating = bird[2]
            break

    results = {}
    results["address"] = row[7]
    results["id"] = str(count+1)
    results["image"] = str(rating)
    results["lat"] = float(row[3])
    results["lng"] = float(row[4])
    results["name"] = row[1] + "; " + row[2]
    results["phone"] = "+65"
    results["region"] = "asia-pacific"

    return results, count+1

with open('eBirdClean_OCT21.csv', encoding="ISO-8859-1") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')

    with open("sample.json", "w") as outfile:

        offices = []
        location = {}

        count = 1
        for row in csv_reader:

            # is this location already represented
            flag = 0
            for pin in offices:
                if (row[7] == pin["address"]):
                    flag = 1

            # if location is not represented
            if flag == 0:
                dct, count = toJSON(row, count)
                offices.append(dct)


        json.dump(offices, outfile)
        location["offices"] = offices

