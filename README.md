# Perceptual learning: cortical plasticity and memory
These scripts are for a study aims to investigate the contributions from the memory system (i.e. the medial temporal lobe) in supporting cortical pasticity.   
Interactions between cortical learning and hippocampal memory functions are critical for acquiring the ability of visual categorization. Importantly, hippocampal pattern separation orthogonalizes neural representations for exemplars in the trained category. Output of the hippocampal pattern separation transmits to cortex and increases distinctiveness of cortical representations for the exemplars. When cortical representations for the exemplars are distinct enough, individuals can categorize novel exemplars at subordinate level for the trained category, which corresponds to a behavioral landmark for expertise in categorization. In contrast, individuals perform basic-level categorization for novel exemplars in other regular categories. Collectively, hippocampal pattern separation is the driving force that diverges originally similar cortical representations for exemplars in a category and this process establishes category expertise in the visual system.

To test the hypothese, the first step is to create category objects for the perceptual learning. I have designed several different sets of parameters for each examplers of two categories (matlab) and tested category learning from these paramters using neural network model (tensorflow, Colab). The set of parameters that gives rise to the best category learning was used to generate pictures of 3D novel objects (POV-Ray). Finally, the object pictures were used to test category learning in humans (online; Prolific). 

Here you can find example codes for generating 3D novel objects in POV-Ray, online behavioral tasks, and behavior data analysis. 

## stimuli/stimuli_generation_pov_ray
Example codes I used to generate noval 3D objects in POV-Ray. Parts of an object are divided into three feature sets. Each feature contains more than one part of the object, but parts in same feature change together according to the experimental manipulation. Each feature has 70 levels of variations. For example, for parts belong to one feature (e.g., protrusions on top of the main body), the parts will become larger and pointer from level one to level seventy. 

## Neural_network
An example script (Colab) I used to test designed parameters. Inputs are parameters defining each object's features. The model is trained to identify two categories of objects based on their features. 

## Online_calibraion_tasks/Prolific
Example codes I used to create online behavioral tasks. This is an object discrimination task. Subjects will see a series of objects. His/Her task is to determine whether they are the same or different. 
An example task: https://web.stanford.edu/~shaofang/Prolific_Calibration_70levels_V317/Menu.html

## Calibration_analysis
An example R markdown file (Prolific_70levels_V317_6pics_2500.md) that I used to analyze behavioral data collected online. In the online task, subjects performed an object discrimination task. To understand whether subjects can perceive the differences in objects and whether the perceived differences among objects change linearly with experimental design (i.e., the input parameters tested by neural network). I investigate subjects' discrimination ability (quantified by d-prime) for different features and different levels of each feature. 



