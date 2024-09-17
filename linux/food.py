#!/usr/bin/env python3

# b_var = brand name of the item
# c_var = coupon code of the item
# d_var = daily cost of the item
# m_var = monthly cost of the item
# p_var = total cost of the item
# q_var = total quantity of the item
# s_var = daily serving size of the item
# t_var = name of the item
# u_var = unit of measurement of the item
# w_var = weekly cost of the item

CURRENCY = '₹'
DAYS_MONTH = 30
DAYS_WEEK = 7
LINE_CHAR = '-'
LINE_LENGTH = 144


def print_line():
    print(f"{LINE_CHAR * LINE_LENGTH}")


def calculate_cost(total_price, total_quantity, serving_size, days=DAYS_WEEK):
    # if total_price == 0 or total_quantity == 0 or serving_size == 0:
    # 	print("Error: total_price, total_quantity, and serving_size must all be greater than zero.")
    # 	print("Action: Exiting...")
    # 	exit()
    daily_cost = (total_price / total_quantity) * serving_size
    weekly_cost = daily_cost * days
    monthly_cost = daily_cost * DAYS_MONTH
    return daily_cost, weekly_cost, monthly_cost


# chicken
t_chicken = 'Chicken Breast'
b_chicken = 'Local Shop'
p_chicken = 320
q_chicken = 1000
s_chicken = 200
u_chicken = 'gm'
d_chicken, w_chicken, m_chicken = calculate_cost(p_chicken, q_chicken, s_chicken)

# whey
t_whey = 'Whey'
b_whey = 'Healthfarm Muscle Whey Blend Double Rich Chocolate'
c_whey = 'PFCHF'
p_whey = 6300
q_whey = 4000
s_whey = 35
u_whey = 'gm'
d_whey, w_whey, m_whey = calculate_cost(p_whey, q_whey, s_whey)

# magnesium
t_magnesium = 'Magnesium'
b_magnesium = 'Carbamide Forte Magnesium Glycinate 2000mg'
p_magnesium = 750
q_magnesium = 120
s_magnesium = 1
u_magnesium = 'u'
d_magnesium, w_magnesium, m_magnesium = calculate_cost(p_magnesium, q_magnesium, s_magnesium)

# omega
t_omega = 'Omega 3'
b_omega = 'MuscleNectar Fish Oil Triple Strength 2500mg'
c_omega = 'CHIRAG10'
p_omega = 1900
q_omega = 240
s_omega = 2
u_omega = 'u'
d_omega, w_omega, m_omega = calculate_cost(p_omega, q_omega, s_omega)

# vitamin d
t_vitd = 'Vitamin D3'
b_vitd = 'Cadila Calcigen 60000IU'
p_vitd = 200
q_vitd = 20
s_vitd = (1 / 7)
u_vitd = 'u'
d_vitd, w_vitd, m_vitd = calculate_cost(p_vitd, q_vitd, s_vitd)

# vitamin b
t_vitb = 'Vitamin B Complex'
b_vitb = 'Pfizer Becosule B Complex'
p_vitb = 50
q_vitb = 20
s_vitb = 1
u_vitb = 'u'
d_vitb, w_vitb, m_vitb = calculate_cost(p_vitb, q_vitb, s_vitb)

# egg
t_egg = 'Whole Eggs'
p_egg = 200
q_egg = 30
s_egg = 4
u_egg = 'u'
d_egg, w_egg, m_egg = calculate_cost(p_egg, q_egg, s_egg)

total_daily_cost = \
    d_chicken + \
    d_egg + \
    d_magnesium + \
    d_omega + \
    d_vitb + \
    d_vitd + \
    d_whey

total_weekly_cost = total_daily_cost * DAYS_WEEK

total_monthly_cost = total_daily_cost * DAYS_MONTH

print(f"")
print_line()
print(f"Item\t\t\tCost\t\tQuantity\tServing\t\tDaily\t\tWeekly\t\tMonthly")
print_line()
print(f"{t_chicken}\t\t{CURRENCY} {p_chicken:.0f}\t\t{q_chicken:.0f} {u_chicken} \t{s_chicken:.0f} {u_chicken}\t\t{CURRENCY} {d_chicken:.2f}\t\t{CURRENCY} {w_chicken:.2f}\t{CURRENCY} {m_chicken:.2f}")
print(f"{t_whey}\t\t\t{CURRENCY} {p_whey:.0f}\t\t{q_whey:.0f} {u_whey}\t\t{s_whey:.0f} {u_whey}\t\t{CURRENCY} {d_whey:.2f}\t\t{CURRENCY} {w_whey:.2f}\t{CURRENCY} {m_whey:.2f}")
print(f"{t_egg}\t\t{CURRENCY} {p_egg:.0f}\t\t{q_egg:.0f} {u_egg}\t\t{s_egg:.0f} {u_egg}\t\t{CURRENCY} {d_egg:.2f}\t\t{CURRENCY} {w_egg:.2f}\t{CURRENCY} {m_egg:.2f}")
print(f"{t_omega}\t\t\t{CURRENCY} {p_omega:.0f}\t\t{q_omega:.0f} {u_omega}\t\t{s_omega:.0f} {u_omega}\t\t{CURRENCY} {d_omega:.2f}\t\t{CURRENCY} {w_omega:.2f}\t{CURRENCY} {m_omega:.2f}")
print(f"{t_magnesium}\t\t{CURRENCY} {p_magnesium:.0f}\t\t{q_magnesium:.0f} {u_magnesium}\t\t{s_magnesium:.0f} {u_magnesium}\t\t{CURRENCY} {d_magnesium:.2f}\t\t{CURRENCY} {w_magnesium:.2f}\t\t{CURRENCY} {m_magnesium:.2f}")
print(f"{t_vitb}\t{CURRENCY} {p_vitb:.0f}\t\t{q_vitb:.0f} {u_vitb}\t\t{s_vitb:.0f} {u_vitb}\t\t{CURRENCY} {d_vitb:.2f}\t\t{CURRENCY} {w_vitb:.2f}\t\t{CURRENCY} {m_vitb:.2f}")
print(f"{t_vitd}\t\t{CURRENCY} {p_vitd:.0f}\t\t{q_vitd:.0f} {u_vitd}\t\t{s_vitd:.2f} {u_vitd}\t\t{CURRENCY} {d_vitd:.2f}\t\t{CURRENCY} {w_vitd:.2f}\t\t{CURRENCY} {m_vitd:.2f}")
print_line()
print(f"Total\t\t\t\t\t\t\t\t\t{CURRENCY} {total_daily_cost:.2f}\t{CURRENCY} {total_weekly_cost:.2f}\t{CURRENCY} {total_monthly_cost:.2f}")
print_line()
# print(f"Daily\t\t{CURRENCY}{total_daily_cost:.2f}\nWeekly\t\t{CURRENCY}{total_weekly_cost:.2f}\nMonthly\t\t{CURRENCY}{total_monthly_cost:.2f}")
print(f"")
