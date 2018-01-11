%-------------------------------------------------------
% Learning by gradient descent.
%-------------------------------------------------------
clf; close all; clear; clc;

% make sure the needed folders are available
mkdir('results');
mkdir('../report/figures');

% settings
repetitions = 100;
eta = 0.05;
p = 1000;
q = 3001;
iterations = 20001;

% load the data
load('data/data3.mat');
X = xi';
y = tau';

% fix seed for the random number generator
rng(0);

% solve the basic assignment
base(X, y, repetitions, iterations, eta, p, q);

% try different values for P (amount of training examples)
multiple_ps(X, y, repetitions, iterations, eta, [20, 50, 200, 500, 1000, 2000], q);

% different learning strategies
strategies = {
    lrpfixed(0.05)
    lrpfixed(0.02)
    lrpstep(0.05, 5000, 0.01)
    lrpexp(0.05, 20000, 0.1)
    lrpcycle(0.01, 5000, 0.05)
};
strategies_names = {
    "fixed (0.05)"
    "fixed (0.02)"
    "step"
    "exponential"
    "cycle"
};

% experiments with different learning strategies
multiple_lrp(X, y, repetitions, iterations, p, q, strategies, strategies_names);
