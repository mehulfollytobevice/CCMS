# store the security questions in a pickle file
import pickle 
PATH='YOUR PATH/data'

# list of security questions 
sec_questions=['What was your childhood nickname?',
'What is the name of your favorite childhood friend?',
'What was the name of your first stuffed animal?',
"What is your oldest sibling's middle name?",
'What is the first name of the boy or girl that you first kissed?',
"What is your oldest cousin's first name?",
"What was the name of your first pet?"]

# store the list of questions
with open(PATH+'/security_questions2.pickle','wb') as f:
    pickle.dump(sec_questions,f)