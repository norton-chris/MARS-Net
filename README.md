# MARS-Net
Deep learning-based segmentation pipeline for profiling cellular morphodynamics from multiple types of live cell microscopy  
To learn more about MARS-Net, read the [paper](https://www.biorxiv.org/content/10.1101/191858v3)

![MARS-Net Logo](/assets/NARS-Net_logo.png)

## Run Demo
You can quickly one of our segment live cell movie using the demo in Google Colab:
* hi  
<!-- end of the list -->
To test our pipeline from the scratch, the user needs to crop images, and train the models before running inference on trained models which can take several hours.  
So this allows users to segment using trained MARS-Net and U-Net on our live cell movies to see that the MARS-Net is better than U-Net.

## Software Requirements
MARS-Net pipeline has been tested on Ubuntu 16.04
* Please download MATLAB 2019b
    * Other versions might work but we didn't test our pipeline on other versions.
* [Correspondence Algorithm](https://github.com/davidstutz/extended-berkeley-segmentation-benchmark) developed by University of California Berkeley Segmentation Benchmark for F1, precision and recall evaluation.
    * Doesn’t work on Windows OS because it was compiled for Linux
* [Windowing and Protrusion package](https://github.com/DanuserLab/Windowing-Protrusion) developed by Gaudenz Danuser lab (UT Southwestern) for Morphoydynamics profiling.  
* For training and segmenting the cell boundary, Python v3.6.8, TensorFlow (v1.15 or v2.3), and Keras v2.3.1 .  
    * Tensorflow v2.3 on RTX Titan GPU with CUDA 10.1
    * Tensorflow v1.15 on GTX 1080Ti GPU with CUDA 10.0 

## Pipeline
The pipeline consists of label tool, segmentation modeling, and morphodynamics profiling.    
There is no installation procedure except for downloading or installing the software requirements

* Before running the pipeline, please specify the following parameters in UserParams.py
    * strategy_type
    * dataset_folders
    * img_folders
    * mask_folders
    * frame_list
    * dataset_names 
    * model_names 
    * REPEAT_MAX

### Label Tool
Tool to facilitate labelling raw images semi-automatically
In the folder label_tool folder
1. To determine hysteresis thresholding for canny detector and kernel size for blurring
    * python explore_edge_extraction_user_params.py
    * Compare results in generated_explore_edge folder
1. Edge extraction Step
    * Python extract_edge.py 
1. Manual Fix Step
    * The generated edges in generated_edge folder, connect fragmented edges and delete the wrong edges
    * We used [ImageJ](https://imagej.nih.gov/ij/download.html) or [GIMP](https://www.gimp.org/) for manual fix after overlaying edge over the original image
1. Post processing step to fill the extracted edges
    * python segment_edge.py will save results in generated_segmentation folder


### Segmentation Model Training and Prediction
To train the deep learning model from scratch and segment the live cell movie, 
* To crop patches, run
    * crop/crop_augment_split.py
* To Train, run
    * models/train_mars.py
* To segment live cell movie, run
    * models/prediction.py

### Evaluation
To replicate the evaluation results such as bar graphs, line graphs, bubble plots, and violin plots,
In evaluation folder,  
Before running code, please install [Correspondence Algorithm](https://github.com/davidstutz/extended-berkeley-segmentation-benchmark)  
* Edit parameters in evaluation/GlobalConfig.m
    * prediction_path_list
    * display_names
    * frame_list
    * root_path
    * img_root_path
* To evaluate F1, precision and recall 
    * evaluation/evaluation_f1/Evaluation_f1.m
* To draw edge evolution, run
    * evaluation/evaluation_f1/run_overlap_compare.m
* To draw violin plot, run
    * evaluation/violin_compare.m  
<!-- end of the list -->

To replicate SEG-Grad-CAM results, run
* SegGradCAM/main.py


### Morphodynamics
* Download [Windowing and Protrusion package](https://github.com/DanuserLab/Windowing-Protrusion)
* Add directory and sub directory of the downloaded package to the MATLAB path 
* Type movieSelectorGUI in the command window in MATLAB
* Create new movie and perform windowing on the segmented movie from the previous step.
* For details, refer to their Github page.