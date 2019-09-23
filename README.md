# Perceptual learning: cortical plasticity and memory
These scripts are part of a study aims to investigate the contributions from the memory system (i.e. the medial temporal lobe) in supporting cortical pasticity.   
Interactions between cortical learning and hippocampal memory functions are critical for acquiring the ability of visual categorization. Importantly, hippocampal pattern separation orthogonalizes neural representations for exemplars in the trained category. Output of the hippocampal pattern separation transmits to cortex and increases distinctiveness of cortical representations for the exemplars. When cortical representations for the exemplars are distinct enough, individuals can categorize novel exemplars at subordinate level for the trained category, which corresponds to a behavioral landmark for expertise in categorization. In contrast, individuals perform basic-level categorization for novel exemplars in other regular categories. Collectively, hippocampal pattern separation is the driving force that diverges originally similar cortical representations for exemplars in a category and this process establishes category expertise in the visual system.

To test the hypothese, the first step is to create category objects for the perceptual learning. I have designed several different sets of parameters for each examplers of two categories (matlab) and tested category learning from these paramters using neural network model (tensorflow, Colab). The set of parameters that gives rise to the best category learning was used to generate pictures of 3D novel objects (POV-Ray). Finally, the object pictures were used to test category learning in humans online (Prolific). 

Here you can find example codes for generating 3D novel objects in POV-Ray and online behavioral tasks, and codes for behavior data analysis. 

## Online_calibraion_tasks/Prolific
Example codes I used to create online behavioral tasks. This is an object discrimination task. Subjects will see a series of objects. His/Her task is to determine whether they are the same or different. 
You can take a look at the example task here: https://web.stanford.edu/~shaofang/Prolific_Calibration_70levels_V317/Menu.html

## stimuli/stimuli_generation_pov_ray
Example codes I used to generate noval 3D objects in POV-Ray. Parts of an object are divided into three feature sets. Each feature contains more than one part of the object, but parts in one feature are manipulated together. Each feature has 70 levels of variations. For example, for parts of one feature, the parts may become larger and pointer from level one to level seventy. 

## Calibration_analysis
An example R markdown file (Prolific_70levels_V317_6pics_2500.md) that I used to analyze behavioral data collected online. Subjects performed an object discrimination task. To understand whether subjects can perceive the differences in objects and whether the perceived differences in objects meet experimental design (POV-Ray), I investigate subjects' discrimination ability (quantified by d-prime) for different features and different levels within each feature. 


