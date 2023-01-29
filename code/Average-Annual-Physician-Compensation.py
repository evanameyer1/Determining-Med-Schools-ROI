import csv
title = "Average Annual Physician Compensation (by Specialty)"
list1 ="""Plastic Surgery $576K 
Orthopedics $557K
Cardiology $490K
Otolaryngology $469K
Urology $461K
Gastroenterology $453K
Dermatology $438K
Radiology $437K
Ophthalmology $417K
Oncology $411K
Anesthesiology $405K
Surgery, General $402K
Emergency Medicine $373K
Critical Care $369K
Pulmonary Medicine $353K
Ob/Gyn $336K 
Pathology $334K
Nephrology $329K
Physical Medicine & Rehabilitation $322K
Neurology $301K
Allergy & Immunology $298K
Rheumatology $289K
Psychiatry $287K
Internal Medicine $264K
Infectious Diseases $260K
Diabetes & Endocrinology $257K
Family Medicine $255K
Pediatrics $244K
Public Health & Preventive Medicine $243K"""

list2= sorted(list(list1.split("\n")))
print(list2)
dict1 = []
for i in range(len(list2)):
    id = i + 1
    thing = list(list2[i].split(' $'))
    name = thing[0]
    salary = thing[1]
    dict1.append({'SpecialtyId' : id, 'Specialty' : name, 'AVGSalary' : salary})
print(dict1)

with open('Physicial_data_2022.csv', mode = 'w') as csvfile:
    fieldnames = dict1[0].keys()
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames,lineterminator = '\n')

    writer.writeheader()
    for things in dict1:
        writer.writerow(things)
