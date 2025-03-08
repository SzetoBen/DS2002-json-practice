import requests
import csv

URL = "https://raw.githubusercontent.com/austin-t-rivera/DS2002-json-practice/0fc909adffe8b13aea33a59af90c38f978bca61d/data/schacon.repos.json"

# Fetch the JSON data
response = requests.get(URL)

data = None

if response.status_code == 200:
    data = response.json()  # Parse JSON
else:
    print(f"Failed to retrieve data. HTTP Status Code: {response.status_code}")

#Write to csv
csv_filename = "chacon.csv"
with open(csv_filename, mode='a', newline='') as file:
    writer = csv.writer(file)
    
    #get only the first 5 items in the json
    for item in data[:5]:
        name = item["name"]
        html_url = item["html_url"]
        updated_at = item["updated_at"]
        visibility = item["visibility"]
        writer.writerow([name, html_url, updated_at, visibility]) #write a new row in csv