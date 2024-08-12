#!/usr/bin/env python3

# p_var = total cost of the item
# q_var = total quantity of the item
# s_var = daily serving size of the item
# d_var = daily cost of the item
# w_var = weekly cost of the item
# m_var = monthly cost of the item

DAYS_WEEK = 7
DAYS_MONTH = 30

def separator():
	print(f"{'-' * 128}")

def calculate_cost(price, quantity, serving_size, days=DAYS_WEEK):
	daily_cost = (price / quantity) * serving_size
	weekly_cost = daily_cost * days
	monthly_cost = daily_cost * DAYS_MONTH
	return daily_cost, weekly_cost, monthly_cost

# chicken breast
p_chicken = 320
q_chicken = 1
s_chicken = 0.25
d_chicken, w_chicken, m_chicken = calculate_cost(p_chicken, q_chicken, s_chicken)

# whey protein
p_whey = 5880
q_whey = 4
s_whey = 0.035
d_whey, w_whey, m_whey = calculate_cost(p_whey, q_whey, s_whey)

# magnesium
p_magnesium = 749
q_magnesium = 120
s_magnesium = 1
d_magnesium, w_magnesium, m_magnesium = calculate_cost(p_magnesium, q_magnesium, s_magnesium)

# omega
p_omega = 1829
q_omega = 240
s_omega = 2
d_omega, w_omega, m_omega = calculate_cost(p_omega, q_omega, s_omega)

# vitamin d
p_vitd = 67
q_vitd = 4
s_vitd = (1 / 7)
d_vitd, w_vitd, m_vitd = calculate_cost(p_vitd, q_vitd, s_vitd)

# vitamin b
p_vitb = 52
q_vitb = 20
s_vitb = 1
d_vitb, w_vitb, m_vitb = calculate_cost(p_vitb, q_vitb, s_vitb)

# egg
p_egg = 200
q_egg = 30
s_egg = 3
d_egg, w_egg, m_egg = calculate_cost(p_egg, q_egg, s_egg)

t_daily = \
	d_chicken + \
	d_egg + \
	d_magnesium + \
	d_omega + \
	d_vitb + \
	d_vitd + \
	d_whey

t_weekly = t_daily * DAYS_WEEK

t_monthly = t_daily * DAYS_MONTH

separator()
print(f"Item\t\tCost\t\tQuantity\tServing\t\tDaily Cost\tWeekly Cost\tMonthly Cost")
separator()
print(f"Chicken\t\tINR {p_chicken:.0f}\t\t{q_chicken:.0f} kg\t\t{s_chicken*1000:.0f} gm\t\tINR {d_chicken:.2f}\tINR {w_chicken:.2f}\tINR {m_chicken:.2f}")
print(f"Whey\t\tINR {p_whey:.0f}\t{q_whey:.0f} kg\t\t{s_whey*1000:.0f} gm\t\tINR {d_whey:.2f}\tINR {w_whey:.2f}\tINR {m_whey:.2f}")
# print(f"Egg\t\tINR {p_egg:.0f}\t\t{q_egg:.0f} pieces\t{s_egg:.0f} pieces\tINR {d_egg:.2f}\tINR {w_egg:.2f}\tINR {m_egg:.2f}")
print(f"Omega\t\tINR {p_omega:.0f}\t{q_omega:.0f} capsules\t{s_omega:.0f} capsules\tINR {d_omega:.2f}\tINR {w_omega:.2f}\tINR {m_omega:.2f}")
print(f"Magnesium\tINR {p_magnesium:.0f}\t\t{q_magnesium:.0f} capsules\t{s_magnesium:.0f} capsules\tINR {d_magnesium:.2f}\tINR {w_magnesium:.2f}\tINR {m_magnesium:.2f}")
print(f"VitB\t\tINR {p_vitb:.0f}\t\t{q_vitb:.0f} capsules\t{s_vitb:.0f} capsule\tINR {d_vitb:.2f}\tINR {w_vitb:.2f}\tINR {m_vitb:.2f}")
print(f"VitD\t\tINR {p_vitd:.0f}\t\t{q_vitd:.0f} capsules\t{s_vitd:.2f} capsule\tINR {d_vitd:.2f}\tINR {w_vitd:.2f}\tINR {m_vitd:.2f}")
separator()
print(f"Total\t\t\t\t\t\t\t\tINR {t_daily:.2f}\tINR {t_weekly:.2f}\tINR {t_monthly:.2f}")
separator()
