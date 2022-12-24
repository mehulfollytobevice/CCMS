from bs4 import BeautifulSoup
import requests
import re
import lxml
import pickle

PATH='YOUR PATH/data'

# get html from the website and convert into bs object
url='https://sites.google.com/site/pwordsecuritykate/home/list-of-ideas-security-questions'
page=requests.get(url)
soup=BeautifulSoup(page.text, "html.parser")
req_text=soup.find_all("p")[0]
# print(str(req_text))

# formatting and cleaning the output
questions=re.sub(r'(<p>|</p>)','',str(req_text)).split('<br/>')
questions=[
    re.sub(r'\n','',ques).strip() for ques in questions
][:-1]

# print(questions)

# save the list of security questions
with open(PATH+'/security_questions.pickle','wb') as f:
    pickle.dump(questions,f)