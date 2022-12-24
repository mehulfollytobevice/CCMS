# this file contains the code for scraping merchant and merchant type information
# import libraries
import pickle
import requests
from bs4 import BeautifulSoup

# get the list of retail companies
url='https://en.wikipedia.org/wiki/List_of_largest_retail_companies'
PATH='YOUR PATH/data'
page=requests.get(url)

# Now, we parse the HTML content using the bs4 library
soup=BeautifulSoup(page.text, "html.parser")

# get the html
table_html=soup.find_all("tr")[1:]

#iterate over the table
merchant=[]
for i in range(len(table_html)):
    row=table_html[i].find_all('td')
    if row[-1].a.text=="United States": # concentrating only on the companies in US
        merchant.append((row[1].a.text,row[2].text.strip()))

# store pickle information
with open(PATH+'/merchant_info.pickle','wb') as f:
    pickle.dump(merchant,f)