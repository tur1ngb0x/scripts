#!/usr/bin/env python3

# AGE
while True:
    age = float(input("Enter your age in years: ").strip())
    if not (0 < age <= 123):
        print("Invalid input.")
    else:
        break

# HEIGHT
while True:
    height = float(input("Enter your height in meters: ").strip())
    if not (0 < height <= 2.75):
        print("Invalid input.")
    else:
        break

# WEIGHT
while True:
    weight = float(input("Enter your weight in kilograms: ").strip())
    if not (0 < weight <= 650):
        print("Invalid input.")
    else:
        break

# ACTIVITY FACTOR
activity_factors = {
    1.2: "No exercise",
    1.375: "Light exercise",
    1.55: "Moderate exercise",
    1.725: "Heavy exercise",
    1.9: "Extreme exercise"
}

# BMR AND TDEE CALCULATION FOR MALE
print("\n\n\n")
print("----------------------------------------------------------------------------------------")
print(f"Male, {age} years, {height} m, {weight} kilograms")
print("----------------------------------------------------------------------------------------")
print("{:<20} {:<15} {:<15} {:<15} {:<15}".format('Activity', 'BMR-Mifflin', 'BMR-Benedict', 'TDEE-Mifflin', 'TDEE-Benedict'))

height_cm = height * 100

for factor, description in activity_factors.items():
    # BMR MIFFLIN-ST JEOR FORMULA FOR MALE
    bmr_mifflin = (10 * weight) + (6.25 * height_cm) - (5 * age) + 5

    # BMR REVISED HARRIS-BENEDICT FORMULA FOR MALE
    bmr_harris = 88.362 + (13.397 * weight) + (4.799 * height_cm) - (5.677 * age)

    # CALCULATE TDEE (TOTAL DAILY ENERGY EXPENDITURE) FOR MALE
    tdee_mifflin = bmr_mifflin * factor
    tdee_harris = bmr_harris * factor

    print("{:<20} {:<15.2f} {:<15.2f} {:<15.2f} {:<15.2f}".format(
        description,
        bmr_mifflin,
        bmr_harris,
        tdee_mifflin,
        tdee_harris
    ))
print("----------------------------------------------------------------------------------------")

# BMR AND TDEE CALCULATION FOR FEMALE
print("\n\n\n")
print("----------------------------------------------------------------------------------------")
print(f"Female, {age} years, {height} m, {weight} kilograms")
print("----------------------------------------------------------------------------------------")
print("{:<20} {:<15} {:<15} {:<15} {:<15}".format('Activity', 'BMR-Mifflin', 'BMR-Benedict', 'TDEE-Mifflin', 'TDEE-Benedict'))

for factor, description in activity_factors.items():
    # BMR MIFFLIN-ST JEOR FORMULA FOR FEMALE
    bmr_mifflin = (10 * weight) + (6.25 * height_cm) - (5 * age) - 161

    # BMR REVISED HARRIS-BENEDICT FORMULA FOR FEMALE
    bmr_harris = 447.593 + (9.247 * weight) + (3.098 * height_cm) - (4.330 * age)

    # CALCULATE TDEE (TOTAL DAILY ENERGY EXPENDITURE) FOR FEMALE
    tdee_mifflin = bmr_mifflin * factor
    tdee_harris = bmr_harris * factor

    print("{:<20} {:<15.2f} {:<15.2f} {:<15.2f} {:<15.2f}".format(
        description,
        bmr_mifflin,
        bmr_harris,
        tdee_mifflin,
        tdee_harris
    ))
print("----------------------------------------------------------------------------------------")
print("\n\n\n")
