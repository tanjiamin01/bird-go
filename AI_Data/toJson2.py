import csv
import json

birdy = [['Egretta sacra', 'Pacific Reef Heron', 2, 0.500001911772415, 1.39666666666, 103.88, 1], ['Cacomantis merulinus', 'Plaintive Cuckoo', 2, 0.50390625, 1.39666666666, 103.88, 1], ['Tachybaptus ruficollis', 'Little Grebe', 3, 0.9418202638626099, 1.39666666666, 103.88, 1], ['Tringa nebularia', 'Common Greenshank', 1, 0.005, 1.39666666666, 103.72, 2], ['Tringa totanus', 'Common Redshank', 1, 0.06298828125, 1.39666666666, 103.72, 2], ['Motacilla tschutschensis', 'Eastern Yellow Wagtail', 1, 0.0001220703125, 1.39666666666, 103.72, 2], ['Tachybaptus ruficollis', 'Little Grebe', 3, 0.03149417042732239, 1.33666666666, 103.72, 3], ['Egretta sacra', 'Pacific Reef Heron', 2, 0.017822265625, 1.33666666666, 103.72, 3], ['Cacomantis merulinus', 'Plaintive Cuckoo', 2, 0.0628090356476605, 1.33666666666, 103.72, 3], ['Cuculus micropterus', 'Indian Cuckoo', 2, 0.8911743292119354, 1.33666666666, 103.88, 4], ['Gracula religiosa', 'Common Hill Myna', 2, 0.9142514476552606, 1.33666666666, 103.88, 4], ['Dicrurus annectens', 'Crow-billed Drongo', 2, 0.93605059501715, 1.33666666666, 103.88, 4]]

def toJSON(row):

    results = {}
    results["name"] = row[1]+"; "+row[0]
    results["rarity"] = row[2]
    results["quadPred"] = row[3]
    results["lat"] = row[4]
    results["lng"] = row[5]
    results["quad"] = row[6]

    return results

offices = []
location = {}

for bird in birdy:
    dct = toJSON(bird)
    offices.append(dct)

with open("predMax3.json", "w") as outfile:
    json.dump(offices, outfile)

