import sys
import datetime
import math

#input
lines = input().splitlines()


#read input files
commands = []
for line in lines:
    commands.append(line.split(" "))

#initialize everything
person = client()
storage_A1 = storage("storage_A1", "A", 0.01, 0.0005, True)
storage_A2 = storage("storage_A2", "A", 0.001, 0.01, True)
storage_B1 = storage("storage_B1", "B", 0.01, 0.001, False)
storage_B2 = storage("storage_B2", "B", 0.0001, 0.5, False)
storages = {"storage_A1" : storage_A1, "storage_A2" : storage_A2, 
"storage_B1" : storage_B1, "storage_B2": storage_B2}
storages_set = {storage_A1, storage_A2, storage_B1, storage_B2}

#function
upload = upload_class()
delete = delete_class()
update = update_class()
agg = aggregates(storages_set)

#Put the action
for command in commands:
    if command[1] == "UPLOAD":
        curr_storage = storages[command[2]]
        filesize = int(command[4])/1000
        if upload.validate(curr_storage, person, command[3], filesize):
            upload.upload_file(curr_storage, command[3], filesize)
            agg.calculate_overall_fee()
            print("UPLOAD: {} {} {}".format(
                agg.overall_storage_fee, agg.overall_update_fee, agg.overall_usage_fee
            ))
        else:
            print(upload.output) 

    if command[1] == "DELETE":
        curr_storage = storages[command[2]]
        filesize = int(command[4])/1000
        if delete.validate(curr_storage, person, command[3]):
            delete.delete_file(curr_storage, command[3])
            agg.calculate_overall_fee()
            print("DELETE: {} {} {}".format(
                agg.overall_storage_fee, agg.overall_update_fee, agg.overall_usage_fee
            ))
        else:
            print(delete.output)
    
    if command[1] == "UPDATE":
        curr_storage = storages[command[2]]
        filesize = int(command[4])/1000
        if update.validate(curr_storage, person, command[3], filesize):
            update.upload_file(curr_storage, command[3], filesize)
            agg.calculate_overall_fee()
            print("UPDATE: {} {} {}".format(
                agg.overall_storage_fee, agg.overall_update_fee, agg.overall_usage_fee
            ))
        else:
            print(update.output)

    if command[1] == "UPGRADE":
        if person.status is True:
            print("UPGRADE: user is already on the paid plan")
        else:
            person.status = True
            print("UPGRADE: accepted")

    if command[1] == "CALC":
        agg.update_month()
        print(agg.output)

    else:
        pass


#function to calculate time
def calculate_passed_time(date1, date2):
    # Convert the input strings to datetime objects
    d1 = datetime.datetime.strptime(date1, '%Y-%m-%dT%H:%M')
    d2 = datetime.datetime.strptime(date2, '%Y-%m-%dT%H:%M')
    # Check if date1 is after date2
    if d1 > d2:
        # If it is, swap the two datetime objects
        d1, d2 = d2, d1
    # Calculate the difference between the two datetime objects in minutes
    delta = d2 - d1
    minutes = int(delta.total_seconds() / 60)
    return minutes

class aggregates:
    def __init__(self, data_set):
        self.data_set = data_set
        self.output = "Ready"
        self.overall_storage_fee = 0.
        self.overall_update_fee = 0.
        self.overall_usage_fee = 0.
    
    def update_month(self):
        storage_used = []
        for data in self.data_set:
            storage_used.append(data.size)
            data.update_fee = 0.
            data.stor_fee = 0.
            data.usage_fee = 0.
        self.output = "CALC: [{} {} {} {}] {} {} {}".format(
            storage_used[0]*1000, storage_used[1]*1000, storage_used[2]*1000, storage_used[3]*1000, self.overall_storage_fee, self.overall_update_fee, 
            self.overall_usage_fee
        )
        self.overall_storage_fee = 0.
        self.overall_update_fee = 0.
        self.overall_usage_fee = 0.
    
    def calculate_overall_fee(self):
        self.overall_storage_fee = 0.
        self.overall_update_fee = 0.
        self.overall_usage_fee = 0.

        for data in self.data_set:
            self.overall_update_fee += data.update_fee
            self.overall_storage_fee += data.stor_fee
            self.overall_usage_fee += data.usage_fee
        
        self.overall_update_fee = math.ceil(self.overall_update_fee)
        self.overall_storage_fee = math.ceil(self.overall_storage_fee)
        self.overall_usage_fee = math.ceil(self.overall_usage_fee)
    


class storage:
    def __init__(self, name, type_storage, stor_bill, update_bill, free):
        self.name = name
        self.type_storage = type_storage
        self.stor_bill = stor_bill
        self.update_bill = update_bill
        self.free = free
        self.stor_fee = 0.
        self.update_fee = 0.
        self.usage_fee = 0.
        self.files = dict()
        self.size = 0
        self.max_size = 0
        self.initial_time = None
        self.curr_time = None
    
    def calculate_stor_fee(self, filesize):
        max_size = max(self.size + int(filesize), self.max_size)
        return max_size * self.stor_bill
    
    def update_max_size(self):
        self.max_size = max(self.size, self.max_size)
    
    def update_time(self, time):
        self.current_time = time

        #initalize initial time
        if self.initial_time is None:
            self.initial_time = time
            return 
        
        #reset if passed one month
        diff_time = calculate_passed_time(self.initial_time, self.current_time)
        if diff_time >= 44640:
            self.update_fee = 0.
            self.initial_time = time
        
        return
        

    

class upload_class:
    def __init__(self):
        self.output = "Ready"
        pass
    
    def upload_file(self, storage, filename, filesize):

        #calculate update bill
        update_fee = int(filesize) * storage.update_bill
        storage.update_fee += update_fee

        #calculate storage fee first
        storage.stor_fee = storage.calculate_stor_fee(filesize)
        
        #update everything
        storage.size += int(filesize)
        storage.usage_fee = self.usage_fee(storage, filesize)
        storage.update_max_size()
        storage.files.update({filename: int(filesize)})
        self.output = "UPLOAD: " + str(math.ceil(storage.stor_fee)) + " " + str(math.ceil(update_fee)) + " " + str(math.ceil(storage.usage_fee))

    def usage_fee(self, storage, filesize):
        stor_fee = storage.calculate_stor_fee(filesize)
        update_fee = storage.update_fee + (storage.update_bill * int(filesize))
        return max(0, stor_fee + update_fee - 1000)

    def validate(self, storage, client, filename, filesize):
        #First case
        if not storage.free:
            if not client.status:
                self.output = "UPLOAD: this storage location is not available on the free plan"
                return False

        #second case
        if filename in storage.files.keys():
            self.output = "UPLOAD: file already exists"

        #third case
        usage_fee = self.usage_fee(storage, filesize)
        if not client.status and usage_fee > 0:
            self.output = "UPLOAD: free plan fee limit exceeded"
            return False
        
        #execute
        return True

class delete_class:
    def __init__(self):
        self.output = "Ready"
        pass

    def usage_fee(self, storage, filename):
        update_fee = storage.update_fee + (storage.update_bill * storage.files[filename])
        return max(0, update_fee + storage.stor_fee - 1000)


    def delete_file(self, storage, filename):
        #filesize
        filesize = storage.files[filename]
        #calculate update fee
        update_fee = int(filesize) * self.update_bill
        storage.update_fee += update_fee

        #update everything
        storage.size -= int(filesize)
        storage.usage_fee = self.usage_fee(storage, filename)
        storage.files.remove(filename)
        self.output = "DELETE: " + str(math.ceil(storage.stor_fee)) + " " + str(math.ceil(update_fee)) + " " + str(math.ceil(storage.usage_fee))
        
    def validate(self, storage, client, filename):
        #First case
        if not storage.free:
            if not client.status:
                self.output = "DELETE: this storage location is not available on the free plan"
                return False

        #second case
        if filename not in storage.files.keys():
            self.output = "DELETE: file does not exist"

        #third case
        usage_fee = self.usage_fee(storage, filename)
        if not client.status and usage_fee > 0:
            self.output = "DELETE: free plan fee limit exceeded"
            return False
        
        return True

class update_class:
    def __init__(self):
        self.output = "Ready"
        pass

    def usage_fee(self, storage, filename, filesize):
        #calculate kinds of size
        size_to_pay = storage.files[filename] + int(filesize)
        curr_size = storage.size - storage.files[filename] + int(filesize)

        #calculate fee
        update_fee = size_to_pay * storage.update_bill
        stor_fee = max(curr_size, storage.max_size) * storage.stor_bill
        return max(0, update_fee + stor_fee - 1000)

    def validate(self, storage, client, filename, filesize):
        #First case
        if not storage.free:
            if not client.status:
                self.output = "UPDATE: this storage location is not available on the free plan"
                return False

        #second case
        if filename not in storage.files.keys():
            self.output = "UPDATE: file does not exist"

        #third case
        usage_fee = self.usage_fee(storage, filesize)
        if not client.status and usage_fee > 0:
            self.output = "UPDATE: free plan fee limit exceeded"
            return False
        
        return True
    
    def update_file(self, storage, filename, filesize):
        #calculate kinds of size
        size_to_pay = storage.files[filename] + int(filesize)
        size = int(filesize) - storage.files[filename]

        #calculate storege fee and update fee
        storage.stor_fee = storage.calculate_stor_fee(size)
        update_fee = size_to_pay * storage.update_bill
        storage.update_fee += update_fee
        storage.usage_fee = self.usage_fee(storage, filename, filesize)

        #update everything
        storage.size += size
        storage.update_max_size()
        storage.files[filename] = int(filesize)
        self.output = "UPDATE: " + str(math.ceil(storage.stor_fee)) + " " + str(math.ceil(update_fee)) + " " + str(math.ceil(storage.usage_fee))




class client:
    def __init__(self, status = False):
        self.status = status



