from datetime import date, datetime, time

# Constants
aircraft_ac_map = {
    'a319': 40,
    'a320': 45
}

def datetime_from_military(time_str):
    return datetime.strptime(time_str, '%H%M')


# Inputs
aircraft = 'a320'
scheduled_arrival = datetime_from_military('1200')
actual_arrival =  datetime_from_military('1210')
scheduled_departure = datetime_from_military('1240')
actual_departure = datetime_from_military('1310')
ac_type = True
crew_change = True

# Math
ac_type_val = aircraft_ac_map[aircraft]
crew_change_val = 5 if crew_change else 0

allowed_ground_time_hr = (ac_type_val + crew_change_val) // 60
allowed_ground_time_min = (ac_type_val + crew_change_val) % 60
allowed_ground_time = datetime_from_military('{:02d}{}'.format(allowed_ground_time_hr, allowed_ground_time_min))
actual_ground_time = scheduled_departure - scheduled_arrival

if scheduled_departure == scheduled_arrival:
    raise Exception('no delay')
elif scheduled_departure < scheduled_arrival:
    raise Exception('check yo math')

delay_time_0x = actual_arrival - scheduled_arrival
total_delay_time = actual_departure - scheduled_departure
delay_time = total_delay_time - delay_time_0x

delay_time_09 = allowed_ground_time - actual_ground_time

print('delay time 0x:', delay_time_0x)
print('delay time:', delay_time)
print('total delay time:', total_delay_time)
print('delay time 09:', delay_time_09)
