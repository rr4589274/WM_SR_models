# Watermarking Speaker Recognition Models

## SincNet

The code is based on the official [SincNet implementation](https://github.com/mravanelli/SincNet) that we adapted to be able to watermark the model.

### Folder structure

- The `output` folder contains the audio files of the dataset. To run SincNet with TIMIT dataset the TRAIN and TEST folders should be placed inside. We do not include the files of the original dataset in the repository here. Nevertheless, the trigger samples that were created using the 3 watermarking methods reproduced from [Liao et al.](https://doi.org/10.1007/s44267-024-00055-w) are in the folder. The artefacts were created using these triggers.
- `UrbanSound8K` folder should contain the audios from UrbanSound8K dataset -> it is necessary to be able to create 'Unrelated audio' watermark. We preserve the needed structure but do not include the audio samples from the dataset.
- `exp/SincNet_TIMIT/logs` includes our trained models with log files. New trained models will be saved there as well.
- `data_lists` contains the files with the lists of audio samples divided for training and testing:
  - `TIMIT_all.scp`, `TIMIT_labels.npy`, `TIMIT_test.scp`, `TIMIT_train.scp` are the clean files taken from the original SincNet repository. Other files contain the respective trigger samples. The trigger test files, e.g., `TIMIT_test_mfcc_2.0_1.0_300_3000_-3.scp`, contain only unseen by the model trigger samples. The watermark verification is performed using the triggers on which the model is trained, e.g., `TIMIT_train_mfcc_2.0_1.0_300_3000_-3.scp` in this case. However, we still create more triggers and analyze how much the model generalizes on the triggers - the results of which are a work in progress and are not discussed at length in the paper.
  - `TIMIT_finetune_train.scp` and `TIMIT_finetune_test.scp` contain the audio samples for finetuning robustness check. They were created by dividing `TIMIT_test.scp` in a 70% train - 30% test ratio.
- `cfg` folder contains the configurations for model training and robustness checks.
  - `SincNet_TIMIT.cfg` is the original configuration.
  - `SincNet_TIMIT_trig.cfg` adds the trigger parameters, but they can also be changed in the code in `speaker_id_trig.py`.
  - `SincNet_TIMIT_ft.cfg` is configuration for fine-tuning, where we use smaller learning rate, fewer epochs, and more often evaluation of the results. It also contains the respective train and test audio samples lists.
  - `SincNet_TIMIT_eval.cfg` is used for other robustness checks, which can also be changed in the respective `.py` files.

### Model training
- The model with a watermark can be trained via `python speaker_id_trig.py`.
- Imperceptibility metrics SNR and LSD are calculated at the start of the model training for the triggers used in model watermarking. For details, see `speaker_id_trig.py`.

### Robustness evaluation

- Finetuning of the saved models can be executed via `python speaker_id_finetune.py`.
- Weight pruning of the saved models can be executed via `python speaker_id_prunning.py`.
- Robustness checks via data modification attacks can be executed via `python speaker_id_eval_rob_checks.py`.

### Watermark creation

- The Gaussian and Frequency watermarks are created with `create_Gaussian_white_freq_triggers.py`. By default, running it will create both Gaussian and Frequency triggers. One can adapt the parameters inside the file to generate these watermarks differently.
- The Unrelated audio watermark can be created using `create_unrelated_audio_triggers.py`.

## AM-MobileNet

The `data_lists` and `output` folders from SincNet should be copied to AMMobileNet to run the models. Since the original implementation of [AMMobileNet](https://github.com/joaoantoniocn/AM-MobileNet1D) is based on SincNet, the principle of running the models is the same as described above for SincNet.

## AutoSpeech

### VoxCeleb

We use a subset of VoxCeleb in our experiments. After downloading a VoxCeleb1 dataset, run the following 2 scripts to make a subset of it. The first file will copy all speakers from the original VC1 folder with video names, but only up to 5 audio files of each video; and a full test folder. The second script copies all the audio files marked for the testing identification task (technically, these are the ones that are labelled as test partition in the code).

```
./voxceleb_copy5_initial.sh
python copy_test_for_Vox_iden.py
```

### Watermark creation



### Model training

To train ResNet18 with a watermark from scratch:
```
python train_baseline_identification.py --cfg exps/baseline/resnet18_iden.yaml
```

To train ResNet34 with a watermark from scratch:
```
python train_baseline_identification.py --cfg exps/baseline/resnet34_iden.yaml
```

To train the AutoSpeech model with a watermark from scratch: 
```
python train_identification.py --cfg exps/scratch/scratch_iden.yaml --text_arch "Genotype(normal=[('dil_conv_5x5', 1), ('dil_conv_3x3', 0), ('dil_conv_5x5', 0), ('sep_conv_3x3', 1), ('sep_conv_3x3', 1), ('sep_conv_3x3', 2), ('dil_conv_3x3', 2), ('max_pool_3x3', 1)], normal_concat=range(2, 6), reduce=[('max_pool_3x3', 1), ('max_pool_3x3', 0), ('dil_conv_5x5', 2), ('max_pool_3x3', 1), ('dil_conv_5x5', 3), ('dil_conv_3x3', 2), ('dil_conv_5x5', 4), ('dil_conv_5x5', 2)], reduce_concat=range(2, 6))"
```


### Robustness evaluation

Finetuning AutoSpeech models:
```
python train_iden_finetune.py --cfg exps/scratch/scratch_iden.yaml
```
