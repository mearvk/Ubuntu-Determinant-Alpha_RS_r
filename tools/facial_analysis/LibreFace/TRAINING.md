# 🏋️ Training LibreFace Models

[← Back to README](README.md)

This document covers training the underlying AU intensity, AU detection, and facial
expression recognition models from scratch in Python. If you just want to *run* LibreFace
for inference, see the [Usage section](README.md#usage) in the main README instead.

## 📑 Table of Contents

- [Setup](#setup)
- [Facial Landmark/Mesh Detection and Alignment](#facial-landmarkmesh-detection-and-alignment)
- [AU Intensity Estimation](#au-intensity-estimation)
- [AU Detection](#au-detection)
- [Facial Expression Recognition](#facial-expression-recognition)
- [Configure](#configure)

## ⚙️ Setup

Clone repo:

```
git clone https://github.com/ihp-lab/LibreFace.git
cd LibreFace
```

The code is tested with Python == 3.7, PyTorch == 1.10.1 and CUDA == 11.3 on NVIDIA GeForce RTX 3090. We recommend you to use [anaconda](https://www.anaconda.com/) to manage dependencies. You may need to change the torch and cuda version in the `requirements.txt` according to your computer.

```
conda create -n libreface python=3.7
conda install pytorch==1.10.0 torchvision==0.11.0 torchaudio==0.10.0 cudatoolkit=11.3 -c pytorch -c conda-forge
conda activate libreface
pip install -r requirements.txt
```

## 🧭 Facial Landmark/Mesh Detection and Alignment

As described in our paper, we first pre-process the input image by mediapipe to obatain facial landmark and mesh. The detected landmark are used to calculate the corresponding positions of the eyes and mouth in the image. We finally use these positions to align the images and center the face area.

To process the image, simpy run following commad:

```jsx
python detect_mediapipe.py
```

## 📈 AU Intensity Estimation

### 🎞️ DISFA

Download the [DISFA](http://mohammadmahoor.com/disfa/) dataset from the official website here. Please be reminded that the original format of the dataset are video sequences, you need to manually process them into image frames.

Download the original video provided by DISFA. Extract it and put it under the folder `data/DISFA`.

Preprocess the images by previous mediapipe script and you should get a dataset folder like below:

```
data
├── DISFA
│ ├── images
│ ├── landmarks
│ └── aligned_images
├── BP4D
├── AffectNet
└── RAF-DB
```

### 🏃 Training/Inference

```
cd AU_Recognition
bash train.sh
bash inference.sh
```

## 🔍 AU Detection

### 🎞️ BP4D

Download the [BP4D](https://www.cs.binghamton.edu/~lijun/Research/3DFE/3DFE_Analysis.html) dataset from the official website. Extract it and put it under the folder `data/BP4D`.

Preprocess the images by previous mediapipe script and you should get a dataset folder like below:

```
data
├── DISFA
│ ├── images
│ ├── landmarks
│ └── aligned_images
├── BP4D
│ ├── images
│ ├── landmarks
│ └── aligned_images
├── AffectNet
└── RAF-DB
```

### 🏃 Training/Inference

```
cd AU_Detection
bash train.sh
bash inference.sh
```

## 😀 Facial Expression Recognition

### 🎞️ AffectNet

Download the [AffectNet](http://mohammadmahoor.com/affectnet/) dataset from the official website. Extract it and put it under the folder `data/AffectNet`.

Preprocess the images by previous mediapipe script and you should get a dataset folder like below:

```
data
├── DISFA
│ ├── images
│ ├── landmarks
│ └── aligned_images
├── BP4D
│ ├── images
│ ├── landmarks
│ └── aligned_images
├── AffectNet
│ ├── images
│ ├── landmarks
│ └── aligned_images
└── RAF-DB
```

### 🏃 Training/Inference

```
cd Facial_Expression_Recognition
bash train.sh
bash inference.sh
```

## 🔧 Configure

There are several options of flags at the beginning of each train/inference files. Several key options are explained below. Other options are self-explanatory in the codes. Before running our codes, you may need to change the `device`, `data_root` , `ckpt_path` , `data` and `fold`.

- `ckpt_path` A relative or absolute folder path for writing checkpoints.
- `data_root` The path to your dataset on your local machine.
- `device` Specify cuda or cpu.
- `data` Dataset to be used. ["DSIFA","BP4D","AffectNet","RAF-DB"]
- `fold` We use five-fold cross-validation to report performance on DISFA and three-fold cross-validation on BP4D. ["0","1","2","3","4"]
- `train_csv` Training csv file to be parsed.
- `test_csv` Testing csv file to be parsed.
- `fm_distillation` Use feature matching distillation for training.
