import os
import shutil
from tqdm import tqdm

def ReadList(list_file):
    f=open(list_file,"r")
    lines=f.readlines()
    list_sig=[]
    for x in lines:
        if '3 id1' in x:
            list_sig.append(x.rstrip())
    f.close()
    return list_sig

    
root_folder = "./VoxCeleb1/"
data_folder = "./VoxCeleb1_sm_clean/"
selected_signals = ReadList(f"{data_folder}iden_split.txt")
print(len(selected_signals))
print(selected_signals[0])

for signal in tqdm(selected_signals):
    signal = signal[2:]
    src = os.path.join(root_folder, "dev/wav", signal)
    dst = os.path.join(data_folder, "dev/wav", signal)
    # print(src)
    # print(dst)
    if os.path.exists(src):
        if os.path.isdir(src):
            shutil.copytree(src, dst, dirs_exist_ok=True)  # requires Python 3.8+
        else:
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copy(src, dst)
    else:
        print(f"Source not found: {src}")
    # break
