import pandas as pd
import numpy as np
import seaborn as sns
import glob
from padelpy import padeldescriptor, from_smiles
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.feature_selection import VarianceThreshold

def make_ml_df(df3):

    df3_selection = df3[['canonical_smiles', 'molecule_chembl_id']]
    df3_selection.to_csv('python_notebooks/data/molecule.smi', sep='\t', index=False, header=False)

    xml_files = glob.glob("python_notebooks/data/xml_files/*.xml")
    xml_files.sort()

    FP_list = ['AtomPairs2DCount',
                'AtomPairs2D',
                'EState',
                'CDKextended',
                'CDK',
                'CDKgraphonly',
                'KlekotaRothCount',
                'KlekotaRoth',
                'MACCS',
                'PubChem',
                'SubstructureCount',
                'Substructure']

    fp = dict(zip(FP_list, xml_files))

    fingerprint = 'PubChem'

    fingerprint_output_file = ''.join(['python_notebooks/data/PubChem_fingerprints/',fingerprint,'.csv']) #Substructure.csv
    fingerprint_descriptortypes = fp[fingerprint]

    padeldescriptor(mol_dir='python_notebooks/data/molecule.smi', 
                    d_file=fingerprint_output_file, 
                    descriptortypes= fingerprint_descriptortypes,
                    detectaromaticity=True,
                    standardizenitro=True,
                    standardizetautomers=True,
                    threads=2,
                    removesalt=True,
                    log=True,
                    fingerprints=True)

    fingerprint = 'PubChem'
    fingerprint_output_file = ''.join(['python_notebooks/data/PubChem_fingerprints/',fingerprint,'.csv']) 

    descriptors = pd.read_csv(fingerprint_output_file)

    df_ml = pd.concat([descriptors, df3['pIC50']], axis=1).dropna()

    # Y = df_ml['pIC50']
    # X = df_ml.drop(['Name','pIC50'], axis=1)
    # selection = VarianceThreshold(threshold=(.8 * (1 - .8)))    
    # X = selection.fit_transform(X)
    # X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)
    # model = RandomForestRegressor(n_estimators=100)
    # model.fit(X_train, Y_train)
    # r2 = model.score(X_test, Y_test)

    return(df_ml)