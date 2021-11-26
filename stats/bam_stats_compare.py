#!/bin/python
result1 = pd.read_csv('./bwa.txt', sep='\t', header=None)
result2 = pd.read_csv('./bwa_2.txt', sep='\t', header=None)

df_index = result1.iloc[:, 0].values
value1 = result1.iloc[:, 1].values
value2 = result2.iloc[:, 1].values
ratio = value1/value2

output = pd.DataFrame(np.c_[value1, value2, ratio], index=df_index, columns=['value1', 'value2', 'ratio'])
output.to_csv('result_sh3.txt', sep='\t')