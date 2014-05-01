#ifndef _multilayerperceptron_H_
#define _multilayerperceptron_H_

struct Neuron {
  double  x;
  double  e;
  double* w;
  double* dw;
  double* wsave;
};

struct Layer {
  int     nNumNeurons;
  Neuron* pNeurons;
};

class MultiLayerPerceptron {

  int    nNumLayers;
  Layer* pLayers;

  double dMSE;
  double dMAE;

  void RandomWeights();

  void SetInputSignal (double* input);
  void GetOutputSignal(double* output);

  void SaveWeights();
  void RestoreWeights();

  void PropagateSignal();
  void ComputeOutputError(double* target);
  void BackPropagateError();
  void AdjustWeights();

  void Simulate(double* input, double* output, double* target, bool training);


public:

  double dEta;
  double dAlpha;
  double dGain;
  double dAvgTestError;
  
  MultiLayerPerceptron(int nl, int npl[]);
  ~MultiLayerPerceptron();

  int Train(const char* fnames);
  int Test (const char* fname);
  int Evaluate();

  void Run(const char* fname, const int& maxiter);

};

#endif
