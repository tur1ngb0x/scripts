#!/usr/bin/env python3

def calculate_bmr_tdee(age, gender, height, weight, activity):
    # Convert height from meters to centimeters
    height_cm = height * 100

    # Mifflin-St Jeor Formula
    if gender == 'male':
        bmr_mifflin = 10 * weight + 6.25 * height_cm - 5 * age + 5
    elif gender == 'female':
        bmr_mifflin = 10 * weight + 6.25 * height_cm - 5 * age - 161
    else:
        print("Invalid input.")

    # Revised Harris-Benedict Formula
    if gender == 'male':
        bmr_harris = 88.362 + (13.397 * weight) + (4.799 * height_cm) - (5.677 * age)
    elif gender == 'female':
        bmr_harris = 447.593 + (9.247 * weight) + (3.098 * height_cm) - (4.330 * age)
    else:
        print("Invalid input.")

    # Calculate TDEE (Total Daily Energy Expenditure)
    tdee_mifflin = bmr_mifflin * activity
    tdee_harris = bmr_harris * activity

    return {
        'BMR_Mifflin_St_Jeor': bmr_mifflin,
        'BMR_Harris_Benedict': bmr_harris,
        'TDEE_Mifflin_St_Jeor': tdee_mifflin,
        'TDEE_Harris_Benedict': tdee_harris
    }

# GENDER
while True:
    gender = input("Enter your gender (male, female): ").strip().lower()
    if gender not in ('male', 'female'):
        print("Invalid input.")
    else:
        break

# AGE
while True:
    age = float(input("Enter your age in years (0 < age <= 123): ").strip())
    if not (0 < age <= 123):
        print("Invalid input.")
    else:
        break

# HEIGHT
while True:
    height = float(input("Enter your height in meters (0 < height <= 2.75): ").strip())
    if not (0 < height <= 2.75):
        print("Invalid input.")
    else:
        break

# WEIGHT
while True:
    weight = float(input("Enter your weight in kilograms (0 < weight <= 650): ").strip())
    if not (0 < weight <= 650):
        print("Invalid input.")
    else:
        break

# Predefined activity factors
activity_factors = {
    1.2: "No exercise",
    1.375: "Light exercise",
    1.55: "Moderate exercise",
    1.725: "Heavy exercise",
    1.9: "Extreme exercise"
}

# Display results

print("\nDETAILS")
print(f"Gender: {gender}")
print(f"Age: {age} years")
print(f"Height: {height} meters")
print(f"Weight: {weight} kilograms")

print("\n{:<20} {:<15} {:<15} {:<15} {:<15}".format('Activity', 'BMR-Mifflin', 'BMR-Benedict', 'TDEE-Mifflin', 'TDEE-Benedict'))

# Iterate through each activity factor and print results in table format
for factor, description in activity_factors.items():
    results = calculate_bmr_tdee(age, gender, height, weight, factor)

    print("{:<20} {:<15.2f} {:<15.2f} {:<15.2f} {:<15.2f}".format(
        description,
        results['BMR_Mifflin_St_Jeor'],
        results['BMR_Harris_Benedict'],
        results['TDEE_Mifflin_St_Jeor'],
        results['TDEE_Harris_Benedict']
    ))
