# This file contains the code for generating customer details
# the customer table contains the following columns:
# 1. cust_id
# 2. name
# 3. email
# 4. phone number
# 5. address
# 6. city
# 7. state
# 8. zip 
# 9 country


# import libraries
import pandas as pd
from faker import Faker
import random
from random_address import real_random_address

Faker.seed(42)
PATH='YOUR PATH/data'

# function to generate phone number
# borrowed from stack overflow:
# https://stackoverflow.com/questions/26226801/making-random-phone-number-xxx-xxx-xxxx
def phn():
    n = '0000000000'
    while '9' in n[3:6] or n[3:6]=='000' or n[6]==n[7]==n[8]==n[9]:
        n = str(random.randint(10**9, 10**10-1))
    return n[:3] + '-' + n[3:6] + '-' + n[6:]


# function to  generate customer details
def customer_details(n=100):
    """
    This function returns randomly generated customer details in the form of a dataframe
    :param n: this is the number of card details to generate
    :return: the customer details in the form of a dataframe
    """
    # initialize faker object
    cust_details=[]
    fake=Faker()
    email_providers=['@gmail.com','@yahoo.com','@hotmail.com']

    # generating all the details
    for i in range(n):
        deats=fake.simple_profile()
        name= deats['name'].split(" ")
        if len(name)>2:
            fname=name[0]+" "+name[1]
            sname=name[-1]
        else:
            fname=name[0]
            sname=name[-1]
        email=name[0].lower()+name[-1].lower()+str(random.randint(1,10**3))\
            +email_providers[random.randint(0,len(email_providers)-1)]
        phone=phn()
        full_address=real_random_address()
        address= full_address['address1']+ " " +full_address['address2']
        try:
            city= full_address['city'] #sometimes city is not available
        except:
            city='BOS'
        state=full_address['state']
        zip= full_address['postalCode']
        cust_details.append([i+1,fname,sname, email, phone, address, city, state, zip])

    cust_df= pd.DataFrame(data=cust_details,
                        columns=[
                            'cust_id',
                            'first_name',
                            'last_name',
                            'email',
                            'phone',
                            'address',
                            'city',
                            'state',
                            'zip'
                        ])
    
    return cust_df


if __name__=="__main__":
    
    # generating details using function above
    from sys import argv
    n=int(argv[1])
    c_df= customer_details(n=n)
    # print(c_df.head(2))

    # save the dataframe
    # c_df=c_df.sample(frac=1).reset_index(drop=True)
    # print(card_df.head(3))
    c_df.to_csv(f'{PATH}/table_customer_n-{n}.csv',index=False)
