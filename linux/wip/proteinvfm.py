#!/usr/bin/env python3

# Input data as a list of dictionaries with shorter keys
data = [
    {"brand": "A", "weight": 1000, "cost": 3000, "ratio": 75},
    {"brand": "B", "weight": 2270, "cost": 6434, "ratio": 80},
]

# Calculate ProteinPerINR for each entry and add it to the dictionary
for item in data:
    weight = item["weight"]
    ratio = item["ratio"]
    cost = item["cost"]

    vfm = (weight * ratio) / cost
    item["vfm"] = round(vfm, 2)

# Define the column headers with the original names for output
headers = ["Brand", "Weight", "Cost", "Ratio", "Protein Per INR"]

# Print the headers
print("\t".join(headers))

# Print the data rows using the new shorter keys
for item in data:
    row = [
        item["brand"],
        item["weight"],
        item["cost"],
        item["ratio"],
        item["vfm"],
    ]
    print("\t".join(map(str, row)))
