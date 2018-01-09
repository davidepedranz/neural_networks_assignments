clear; close all; clc;

load('data/data3.mat');
X = xi';
y = tau';

X_mean = mean(X);
X_std = std(X);
X_sk = skewness(X);
X_kur = kurtosis(X);

for i = 1 : size(X, 2)
    fprintf('X(%d)\tmean=%.3f\tstd=%.3f\tsk=%.3f\tkur=%.3f\n', ...
        i, X_mean(i), X_std(i), X_sk(i), X_kur(i));
end

 fprintf('y\tmean=%.3f\tstd=%.3f\tsk=%.3f\tkur=%.3f\n', ...
     mean(y), std(y), skewness(y), kurtosis(y));
 