# Installing Tensorflow GPU
- Create a conda virtual environment with python<3.10
- Activate virtual environment and install cuDNN and CUDA \
`conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0`
- Install tensorflow<2.11 \
`python -m pip install "tensorflow<2.11"`
- Test GPU availability \
`python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"`
- Link to the dataset used in the project \
`https://www.kaggle.com/datasets/wobotintelligence/face-mask-detection-dataset?resource=download`