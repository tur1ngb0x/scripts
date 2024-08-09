#!/usr/bin/env python3

Week = 7
Month = 30
RoundOff = 2

# item_name = (total_price / total_quantity) * (daily_serving)

ChickenBreast = (320.0 / 1.0) * (0.25)
Creatine = (1212.0 / 0.50) * (0.003)
Magnesium = (749.0 / 120.0) * (1.0)
Omega3 = (1829.0 / 240.0) * (2.0)
VitaminB = (52.0 / 20.0) * (1.0)
VitaminD = (67.0 / 4.0) * (1.0 / 7.0)
WheyProtein = (5880.0 / 4.0) * (0.07)
WholeEgg = (180.0 / 30.0) * (3.0)

Daily = round(ChickenBreast + Creatine + Magnesium + Omega3 + VitaminB + VitaminD + WheyProtein + WholeEgg ,RoundOff)
Weekly = Daily * Week
Monthly = Daily * Month

print(f"---------------------------------------")
print(f"Item Name\tDaily Cost")
print(f"---------------------------------------")
print(f"ChickenBreast\tINR {ChickenBreast:.2f}")
print(f"Creatine\tINR {Creatine:.2f}")
print(f"Magnesium\tINR {Magnesium:.2f}")
print(f"Omega3\t\tINR {Omega3:.2f}")
print(f"VitaminB\tINR {VitaminB:.2f}")
print(f"VitaminD3\tINR {VitaminD:.2f}")
print(f"WheyProtein\tINR {WheyProtein:.2f}")
print(f"WholeEgg\tINR {WholeEgg:.2f}")
print(f"---------------------------------------")
print(f"Total Daily\tINR {Daily}")
print(f"Total Weekly\tINR {Weekly}")
print(f"Total Monthly\tINR {Monthly}")
print(f"---------------------------------------")
