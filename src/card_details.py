# this file contains the code for generating data for n cards
# the card table contains:
# 1. card_num
# 2. expiry
# 3. security_num
# 4. geographical location  (address where the card was registered)
# 5. 

# import libraries
import pandas as pd
import numpy as np
from faker import Faker
import datetime
from dateutil.relativedelta import relativedelta
import random 
import re

Faker.seed(42)
PATH='YOUR PATH/data'

# function to generate card_details
def card_details(n=100, random_state=42):
    """
    This function returns randomly generated card details in the form of a dataframe
    :param n: this is the number of card details to generate
    :param random_state: random seed value 
    :return: the card details in the form of a dataframe
    """
    # setting the random state
    np.random.seed(random_state)

    card_details=[]
    fake=Faker()
    for _ in range(n):
        card_type=random.choice(['visa','mastercard'])
        deats=fake.credit_card_full(card_type=card_type).split('\n')
        card_num=deats[2].split(" ")[0]
        expiry= deats[2].split(" ")[1]
        expiry=datetime.datetime.strptime(expiry,'%m/%y')
        valid_from=expiry-relativedelta(years=10)
        sec_code=str(re.sub("(CVC:|CVV:)","",deats[-2]).strip())
        x_customer_id = np.random.uniform(0,100)
        y_customer_id = np.random.uniform(0,100)
        mean_amount = round(np.random.uniform(5,100),2) # Arbitrary (but sensible) value 
        std_amount = round(mean_amount/2,2) # Arbitrary (but sensible) value
        mean_nb_tx_per_day = round(np.random.uniform(0,4),2) # Arbitrary (but sensible) value 
        
        card_details.append([card_num,valid_from,expiry, sec_code,
                            x_customer_id,y_customer_id, mean_amount,
                            std_amount, mean_nb_tx_per_day])


    #return dataframe filled with card details  
    card_df=pd.DataFrame(data=card_details,columns=['card_number','valid_from','expiry','security_code',
                                                    'x-coordinate','y-coordinate','mean_amount',
                                                    'std_amount','mean_nb_tx_per_day'])
    return card_df
    
if __name__=="__main__":
    from sys import argv
    n=int(argv[1])
    card_df=card_details(n=n)
    card_df=card_df.sample(frac=1).reset_index(drop=True)
    # print(card_df.head(3))
    card_df.to_csv(f'{PATH}/table_card_n-{n}.csv',index=False)




