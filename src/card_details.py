# this file contains the code for generating data for 100 cards
# the card table contains:
# 1. card_num
# 2. valid_thru
# 3. valid_from
# 4. security_num

# import libraries
import pandas as pd
from faker import Faker
import random 
import re

Faker.seed(42)
PATH='/Users/mehuljain/Documents/course_related/IDMP/project/codebase/data'

# function to  generate card_details
def card_details(n=100):

    card_details=[]
    fake=Faker()
    for _ in range(n):
        card_type=random.choice(['visa','mastercard'])
        deats=fake.credit_card_full(card_type=card_type).split('\n')
        card_num=deats[2].split(" ")[0]
        expiry= deats[2].split(" ")[1]
        sec_code=re.sub("(CVC:|CVV:)","",deats[-2]).strip()
        card_details.append([card_num, expiry, sec_code])

    card_df=pd.DataFrame(data=card_details,columns=['card_number','expiry','security_code'])

    return card_df
    
if __name__=="__main__":
    card_df=card_details(n=10)
    card_df=card_df.sample(frac=1).reset_index(drop=True)
    # print(card_df.head(3))
    card_df.to_csv(f'{PATH}/table_card.csv')




