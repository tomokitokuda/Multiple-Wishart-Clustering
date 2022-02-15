## Multiple Wishart clustering based on nonparametric mixture models

This algorithm performs multiple-clustering for correlation matrices as follows:

- Optimally divides correlation matrix into several views. In each view, both objects and nodes are clustered.
- Automatically infers the number of views and clusters.

See more details in the relevant paper <https://www.sciencedirect.com/science/article/pii/S0893608021002124>


### Folders and files
- *funcClustering*  
       Relevant files for Wishart clustering
- *funcClassification*  
       Relevant files for classification of a new data 
- *demo1.m for clustering*, *demo2.m for classification of a new data*  
       Examples of the algorithm

### Main function: *funcClustering/runMultipleWishart.m*
#### Input:
 - X: p x p x N (p x p correlation matrices with sample size N)
 - param: setting for parameters. If it is omitted, the default setting is provided.  

#### Note
 - No missing entries are allowed for data X.
 - Each instance of correlation matrix in X must be positive definite.  

#### Output:
- Estimates of view/cluster memberships

See more details in *runMultipleWishart.m*

### Summary function: *funcClustering/summaryModel.m*
#### Input:
- Object yielded by *runMultipleWishart.m*
#### Output:
- View memberships
- Object cluster memberships
- Feature cluster memberships

See more details in *summaryModel.m*

### References
- Tokuda, T., Yamashita, O., & Yoshimoto, J. (2021). Multiple clustering for identifying subject clusters 
and brain sub-networks using functional connectivity matrices without vectorization. 
Neural Networks, 142, 269-287. doi.org/10.1016/j.neunet.2021.05.016
- Tokuda, T., Yamashita, O., Sakai, Y., & Yoshimoto, J. (2021). Clustering of Multiple Psychiatric Disorders 
Using Functional Connectivity in the Data-Driven Brain Subnetwork. 
Frontiers in Psychiatry, 1428. doi.org/10.3389/fpsyt.2021.683280

 
### Authors
**Tomoki Tokuda** <t-tokuda@atr.jp> (1),
**Okito Yamashita** <oyamashi@atr.jp> (1, 2),
**Junichiro Yoshimoto** <jun-y@atr.jp> (1, 3)  
1. Advanced Telecommunications Research Institute International, Japan  
2. Center for Advanced Intelligence Project (AIP), RIKEN, Japan
3. Nara Institute of Science and Technology, Japan

### Acknowledgments
This research was (partially) conducted as a contract project
supported by Japan Agency for Medical Research and Development (AMED) under Grant Number JP20dm0307002 (TT),
JP20dm0307008 (JY, TT), JP20dm0307009 (OY), JP20dm0107096 (JY).
