# Results Summary

Both models, the architecture made from scratch and the one from the Tensorflow/Keras implementation, with the same configuration, achieve the same validation performance, resulting in **90% accuracy**. 

## Work Done
I created Neural Network with two layers as we only have a few observations and a few dimensions (features). The first layer has 64 neurons using ReLU as the activation function, while the last layer uses Sigmoid with only one neuron. I decided to use Sigmoid since it is a binary problem; nonetheless, I created a Neural Network class that works similarly to the famous frameworks (Tensorflow/Pytorch). As visible, the class includes many methods, which depending on the parameters we want to pass, we can adjust its use. Besides the Sigmoid or ReLu activation functions, I added the capability of using TanH and Softmax (for multilabel problems).

# Implementation Description:
For this work, I created two classes, one for layers and the other for the Neural Network architecture that works similarly to an API (like Keras and Pytorch).

- **Layer class**: This class initializes its weights and bias using a standard random distribution. Additionally, this class contains methods for selecting what activation function we want to pass through, a method for the forward propagation step, and another for the backward propagation step. The layer class can work with the most used activation functions: ReLU, Tanh, Softmax, and Sigmoid.

- **Neural Network class (NN)**: This is the class of the Neural Network architecture. This class receives what architecture we want to implement, what lost function, the metric, and the learning rate (by default, I defined a list in which the object randomly selects one at the initialization time). In addition, this class has multiple methods:
- *Predict* (simple forward propagation), 
- *Train* (where we set how many training epochs to use), 
- *Loss* (for now contains two different kinds, CrossEntropy for multiclass problems and BinaryCrossEntropy for binary problems),
- *Accuracy* (metric).

# Experiment settings:

- *Neural Network Architecture:* 2 layers (Multilayer perceptron):
    - 1st layer: 64 neurons; activation function: ReLU.
    - 2nd layer: 1 neuron; activation function: Sigmoid.
- *Weights Initialization method:* Used normal standard distribution weights.
- Epochs: 50 epochs
- *Loss Function:* Binary Crossentropy
- *Learning rate:* Random sampled from a pool of possible learning rates ([0.001, 0.002, 0.0015])
- Metric: Accuracy
- *Scaled features:* True (Method: Standard scaling)
- *Train/Test Split setting:* 80% of our data set is for training and 20% for testing.