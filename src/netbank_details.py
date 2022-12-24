# this file contains the code for generating netbanking details
# the netbanking table contains the following columns:
# 1. cust_id
# 2. username
# 3. password
# 4. password_exp_date
# 5. password_exp_time
# 6. security_ques

# import libraries
import pandas as pd
import random
from datetime import date, timedelta
from wonderwords import RandomWord
import string
import pickle
from faker.providers.person.en import Provider

PATH='YOUR PATH/data'

class NetBank():
    def __init__(self,n):
        self.n=n # number of users 
        
        # we can also get the questions
        with open(PATH+'/security_questions2.pickle','rb') as f:
            questions=pickle.load(f)
        self.questions=questions
        self.names=list(set(Provider.first_names))
        self.len=len(self.names)

    def gen_exp_datetime(self):
        today= date.today()
        days_to_expiry=random.randrange(730)
        return today +timedelta(days=days_to_expiry)

    def gen_username(self):
        r=RandomWord()
        r_words=[r.word(include_parts_of_speech=["nouns", "adjectives"]) for _ in range(2)]
        username= r_words[0]+random.choice("_")+r_words[1]+str(random.randint(1,10**4))
        return username

    def gen_password(self):
        characters = string.ascii_letters + string.digits + "#$%&^*@"
        password = ''.join(random.choice(characters) for i in range(12))
        return password
        
    def sec_question(self):
        return random.choice(self.questions)
    
    def sec_answer(self):
        return self.names[random.randint(0,self.len-1)]
    
    def gen_details(self):
        net_deats=[]
        for _ in range(self.n):
            username= self.gen_username()
            password= self.gen_password()
            exp=self.gen_exp_datetime()
            ques= self.sec_question()
            answer=self.sec_answer()

            net_deats.append([username,password,exp,ques,answer])
        
        return pd.DataFrame(data=net_deats,columns=[
            'username',
            'password',
            'expiry_date',
            'security_question',
            'security_answer'
        ])

if __name__=='__main__':
    # generating details using function above
    from sys import argv
    n=int(argv[1])
    nb= NetBank(n=n)
    nb_details= nb.gen_details()
    # print(c_df.head(2))

    # save the dataframe
    nb_details=nb_details.sample(frac=1).reset_index(drop=True)
    # print(card_df.head(3))
    nb_details.to_csv(f'{PATH}/table_netbanking_n-{n}.csv',index=False)