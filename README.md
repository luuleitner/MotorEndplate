# Motor endplate detection using ultrafast ultrasound imaging
[![GitHub stars](https://img.shields.io/github/stars/luuleitner/deepMTJ?label=Stars&style=social)](https://github.com/luuleitner/MotorEndplate)
[![GitHub forks](https://img.shields.io/github/forks/luuleitner/deepMTJ?label=Fork&style=social)](https://github.com/luuleitner/MotorEndplate)
<br>
[![License: GPLv3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses)
[![GitHub contributors](https://img.shields.io/badge/Contributions-Welcome-brightgreen)](https://github.com/luuleitner/MotorEndplate)
[![Twitter Follow](https://img.shields.io/twitter/follow/luuleitner?label=Follow&style=social)](https://twitter.com/luuleitner)


***"do, ut des"...if we could assist you with this code please cite our work:***
```
@inproceedings{Leitner2020,
   title={{Detection of Motor Endplates in Deep and Pennate Skeletal Muscles in-vivo using Ultrafast Ultrasound},
   author={Christoph Leitner and Sergei Vostrikov and Harald Penasso and Pascal A. Hager and Andrea Cossettini and Luca Benini and Christian Baumgartner},
   booktitle={in Proc. of the IEEE International Ultrasonic Symposium},
   venue={Las Vegas,USA},
   publisher={IEEE},
   month=09,
   year={2020}  
}
```

# Repository Structure

The `#deepMTJ` repository contains:

### 1. ANNOTATE your video data
`mtj_tracking/label` folder contains the video annotation tool: start `main.py`

### 2. TRAIN your own network with our backbones
`mtj_tracking/train` folder contains the network training and evaluation: start `train.py` for `VGG-Attention-3` model and `train_resnet.py` for the `ResNet50` model.

### 3. PREDICT muscle tendon junctions in your own video data with our trained networks
The `mtj_tracking/predict` folder contains an easy to use prediction script (minimal Python knowledge needed to get it running). G to `main.py`, add your data paths and start your predictions...

This script reads your provided AVI-Video Files and returns the annotated frames (downscaled AVI-videos) as well as the X,Y-coordinates of the muscle tendon junction (csv-File). 

#### Video Dataset
The high frame rate ultrasound recording (540 MB) can be downloaded from: [google drive](https://drive.google.com). The provided dataset (`IUSContraction.avi`) is licensed under a [Creative Commons Attribution 4.0 International License](https://github.com/luuleitner/MotorEndplate/blob/master/LICENSE_Datasets).

[![CC BY 4.0](https://i.creativecommons.org/l/by/4.0/88x31.png)](http://creativecommons.org/licenses/by/4.0/)

### Add-On's
- `examples` folder with all result plots and figures of the IEEE-IUS 2020 publication in high resolution.

# Getting Started


# License

This program is free software and licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/luuleitner/deepMTJ/blob/master/LICENSE) file for details.

