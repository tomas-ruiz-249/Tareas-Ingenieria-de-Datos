import csv
from datetime import datetime

#3,4,5,7

def main():
    file = open('data.csv')
    reader = csv.reader(file)
    total_passenger_count = [0,0,0]
    stops = {'Main Street' : 0, 'Park Avenue' : 1, 'Elm Road': 2}
    header = True
    for row in reader:
        if header:
            header = False;
            continue
        departure = row[3]
        arrival = row[4]
        passenger_count = row[5]
        bus_stop = row[7]

        print(total_passenger_count)
        departure = datetime.strptime(departure, '%H:%M %p')
        arrival = datetime.strptime(arrival, '%H:%M %p')

        if(departure <= arrival and arrival < datetime.strptime('12:00 PM', '%H:%M %p')):
            total_passenger_count[stops[bus_stop]] += 1

    max_index = 0
    max = 0
    for i in range(len(total_passenger_count)):
        if total_passenger_count[i] > max:
            max = total_passenger_count[i] 
            max_index = i
    indexes = {v: k for k, v in stops.items()}
    print(f'La parada de bus más transitada antes de las 12PM es {indexes[max_index]}')




if __name__ == '__main__':
    main()
