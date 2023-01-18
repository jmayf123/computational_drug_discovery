import pandas as pd
import numpy as np 
import seaborn as sns
import matplotlib.pyplot as plt
from chembl_webresource_client.new_client import new_client
from rdkit import Chem
from rdkit.Chem import Descriptors, Lipinski



#Mann-Whitney U Test for statiscal significance of the distributions, ACTIVE vs INACTIVE compounds
def mannwhitney(descriptor, df, verbose=False):
  # https://machinelearningmastery.com/nonparametric-statistical-significance-tests-in-python/
  from numpy.random import seed
  from numpy.random import randn
  from scipy.stats import mannwhitneyu
# seed the random number generator
  seed(1)
# actives and inactives
  selection = [descriptor, 'bioactivity_class']
  df_selection = df[selection]
  active = df_selection[df_selection['bioactivity_class'] == 'active']
  active = active[descriptor]
  selection = [descriptor, 'bioactivity_class']
  df_selection = df[selection]
  inactive = df_selection[df_selection['bioactivity_class'] == 'inactive']
  inactive = inactive[descriptor]
# compare samples
  stat, p = mannwhitneyu(active, inactive)
  #print('Statistics=%.3f, p=%.3f' % (stat, p))
# interpret
  alpha = 0.05
  if p > alpha:
    interpretation = 'Same distribution (fail to reject H0)'
  else:
    interpretation = 'Different distribution (reject H0)'
  results = pd.DataFrame({'Descriptor':descriptor,
                          'Statistics':stat,
                          'p':p,
                          'alpha':alpha,
                          'Interpretation':interpretation}, index=[0])
  # filename = 'mannwhitneyu_' + descriptor + '.csv'
  # results.to_csv(filename)
  return results

