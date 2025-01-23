def calculate_bmr(gender, age, height, weight):
    if gender.lower() == 'male':
        # Mifflin-St Jeor equation for men
        return 10 * weight + 6.25 * height - 5 * age + 5
    elif gender.lower() == 'female':
        # Mifflin-St Jeor equation for women
        return 10 * weight + 6.25 * height - 5 * age - 161
    else:
        return None

def calculate_tdee(bmr, activity_level):
    activity_multiplier = {
        'Sedentary': 1.2,
        'Light': 1.375,
        'Moderate': 1.55,
        'Active': 1.725,
        'Athlete': 1.9
    }
    return bmr * activity_multiplier.get(activity_level.lower(), 1.2)

def calculate_macros(tdee, weight):
    protein = 2.0 * weight  # grams of protein per kg of body weight
    fat = 1.0 * weight  # grams of fat per kg of body weight
    carb = (tdee - (protein * 4 + fat * 9)) / 4  # subtracting protein and fat calories
    return protein, fat, carb

def calculate_fiber(tdee):
    # 1.5g of fiber per 100 calories
    return (tdee / 100) * 1.5

def calculate_fiber_ratio(fiber):
    soluble_fiber = 0.33 * fiber # 1/3 of the total fiber is soluble
    insoluble_fiber = fiber - soluble_fiber  # The remaining 2/3 is insoluble
    return soluble_fiber, insoluble_fiber

def calculate_fat_distribution(fat):
    # Calculate saturated and unsaturated fat
    saturated_fat = 0.10 * fat  # 5% of total fat
    unsaturated_fat = fat - saturated_fat # remaining 0.66 is unsaturated
    return saturated_fat, unsaturated_fat

def calculate_goal(tdee, goal):
    goal_mapping = {
        '1': 'lose_0.25',
        '2': 'lose_0.5',
        '3': 'maintain',
        '4': 'gain_0.25',
        '5': 'gain_0.5'
    }
    goal_adjustment = {
        'lose_0.25': -250,
        'lose_0.5': -500,
        'maintain': 0,
        'gain_0.25': 250,
        'gain_0.5': 500
    }
    return tdee + goal_adjustment.get(goal_mapping.get(goal, 'maintain'), 0)

def main():
    # Ask the user for input
    gender = input("Male/Female: ")
    age = int(input("Age: "))
    height = float(input("Height: "))
    weight = float(input("Weight: "))
    activity_level = input("Sedentary, Light, Moderate, Active, Athlete): ")

    # Calculate BMR and TDEE
    bmr = calculate_bmr(gender, age, height, weight)
    if bmr is None:
        print("Invalid gender input. Please enter 'male' or 'female'.")
        return
    tdee = calculate_tdee(bmr, activity_level)

    # Ask the user for their goal
    print("\nWhat is your goal?")
    print("1. Lose 0.25 kg per week")
    print("2. Lose 0.5 kg per week")
    print("3. Maintain weight")
    print("4. Gain 0.25 kg per week")
    print("5. Gain 0.5 kg per week")
    goal_choice = input("Enter the number corresponding to your goal: ")

    # Calculate macros and other nutritional values
    adjusted_tdee = calculate_goal(tdee, goal_choice)
    protein, fat, carbs = calculate_macros(adjusted_tdee, weight)
    fiber = calculate_fiber(adjusted_tdee)
    soluble_fiber, insoluble_fiber = calculate_fiber_ratio(fiber)
    saturated_fat, unsaturated_fat = calculate_fat_distribution(fat)

    # Output the results
    print(f"\nEnergy:")
    print(f"  * BMR: {bmr:.2f} kcal/day")
    print(f"  * TDEE: {adjusted_tdee:.2f} kcal/day")
    print(f"")
    print(f"Carbohydrates: {carbs:.2f} grams")
    print(f"")
    print(f"Protein: {protein:.2f} grams")
    print(f"")
    print(f"Fat: {fat:.2f} grams")
    print(f"  * Saturated Fat: {saturated_fat:.2f} grams")
    print(f"  * Unsaturated Fat: {unsaturated_fat:.2f} grams")
    print(f"")
    print(f"Total Fiber: {fiber:.2f} grams")
    print(f"  * Soluble Fiber: {soluble_fiber:.2f} grams")
    print(f"  * Insoluble Fiber: {insoluble_fiber:.2f} grams")

if __name__ == "__main__":
    main()
