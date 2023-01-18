import pandas as pd
import numpy as np 
from chembl_webresource_client.new_client import new_client
from rdkit import Chem
from rdkit.Chem import Descriptors, Lipinski

# Target search function
def target_search(target_name):
    target = new_client.target
    res = target.filter(pref_name__icontains = target_name)
    if len(res) > 200: #Prevents large df from taking too long to load in the app
        raise ValueError('Search Target too broad, Try Another Search Term.')
    else:
        targets = pd.DataFrame(res)
        selection = ['organism', 'pref_name', 'target_chembl_id', 'target_type']
        return(targets[selection]) #Returns a df of targets matching your search term

#Bioactivty data after getting target selection   
def get_bioactivities_data(target_chembl_ID):
    activity = new_client.activity
    res = activity.filter(target_chembl_id=target_chembl_ID).filter(standard_type="IC50").only(['molecule_chembl_id','canonical_smiles','standard_value', 'standard_type'])
    df = pd.DataFrame(res) #Set a limit for now, take too long to compute over 500 activities [0:500]
    df['standard_value'] = df['standard_value'].astype(float)
    
    conditions = [
        (df['standard_value'] >= 10000),
        (df['standard_value'] <= 1000)
    ]
    choices = ['inactive', 'active']
    df['bioactivity_class'] = np.select(conditions, choices, default = 'intermediate')
    return(df)

# Inspired by: https://codeocean.com/explore/capsules?query=tag:data-curation
# Linpinksi Descriptor calculator
def lipinski(smiles, verbose=False):

    moldata= []
    for elem in smiles:
        mol=Chem.MolFromSmiles(elem) 
        moldata.append(mol)
       
    baseData= np.arange(1,1)
    i=0  
    for mol in moldata:        
       
        desc_MolWt = Descriptors.MolWt(mol)
        desc_MolLogP = Descriptors.MolLogP(mol)
        desc_NumHDonors = Lipinski.NumHDonors(mol)
        desc_NumHAcceptors = Lipinski.NumHAcceptors(mol)
           
        row = np.array([desc_MolWt,
                        desc_MolLogP,
                        desc_NumHDonors,
                        desc_NumHAcceptors])   
    
        if(i==0):
            baseData=row
        else:
            baseData=np.vstack([baseData, row])
        i=i+1      
    
    columnNames=["MW","LogP","NumHDonors","NumHAcceptors"]   
    descriptors = pd.DataFrame(data=baseData,columns=columnNames)
    
    return descriptors
    
#Converting IC50 to pIC50
def pIC50(input):
    pIC50 = []

    for i in input['standard_value_norm']:
        molar = i*(10**-9) # Converts nM to M
        pIC50.append(-np.log10(molar))

    input['pIC50'] = pIC50
    x = input.drop('standard_value_norm', 1)
        
    return x

# Normalizing standard Values
def norm_value(input):
    norm = []

    for i in input['standard_value']:
        if i > 100000000:
          i = 100000000
        norm.append(i)

    input['standard_value_norm'] = norm
    x = input.drop('standard_value', 1)
        
    return x