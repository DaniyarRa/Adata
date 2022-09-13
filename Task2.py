#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd


url = "https://www.goszakup.gov.kz/ru/registry/rqc"
  

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

from bs4 import BeautifulSoup
import urllib.request

html_page = urllib.request.urlopen(url + "?count_record=500&page=1")

soup = BeautifulSoup(html_page, "html.parser")
l = soup.findAll('a')[75:534];
df = pd.DataFrame(columns = ['Наименование организации', 'БИН организации', 'ФИО руководителя', 'ИИН руководителя','Полный адрес организации'])
x = 1
for link in l:
    #print('Link ' + str(link - 74) + ": ", l[link].get('href'))
    while(True):
        try:
            
            table = pd.read_html(link.get('href'))
            
            
            #print(table[0].loc[7][1], table[0].loc[4][1],table[2].loc[2][1], table[2].loc[0][1], table[3].loc[0][2])
            df= pd.concat([df, pd.DataFrame.from_records([{'Наименование организации':table[0].loc[7][1], 'БИН организации':table[0].loc[4][1], 'ФИО руководителя':table[2].loc[2][1], 'ИИН руководителя': table[2].loc[0][1],'Полный адрес организации':table[3].loc[0][2]}])], ignore_index = True)
            
            #print(df.loc[len(df) - 1])
            x = x + 1
            break
        except:
            y = 5

df.to_excel(r'C:\Users\danii\Downloads\parsed_list.xlsx', index = False, header=True)   
print("Sucsesfully finished")        


    
    


# In[ ]:





# In[ ]:




