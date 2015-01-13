% Author : Vijay Rengarajan
% Date   : Jan 13, 2015
%
% Study the options available to perform k-means using VLFeat
% library (http://www.vlfeat.org/). 

% Sacred debts
clc;
clear all;
close all;

% Generate random 2D points
dim = 2;
numPts = 10000;
data = rand(dim, numPts);

numClusters = 20;

% Run k-means
tic
[centres, assigns] = vl_kmeans(data, numClusters);
toc

% Plot figure
figure;
hold on;
for i = 1:numClusters
    [~, idx] = find(assigns == i);
    colour = rand(1,3);
    colour = colour / sum(colour);
    scatter(data(1,idx),data(2,idx),48,colour,'d','filled');
    scatter(centres(1,i),centres(2,i),64,'y','o','filled');
end

% Run k-means with kmeans++ init
tic
[centres, assigns] = vl_kmeans(data, numClusters, 'Initialization', 'plusplus') ;
toc

% Plot figure
figure;
hold on;
for i = 1:numClusters
    [~, idx] = find(assigns == i);
    colour = rand(1,3);
    colour = colour / sum(colour);
    scatter(data(1,idx),data(2,idx),48,colour,'d','filled');
    scatter(centres(1,i),centres(2,i),64,'y','o','filled');
end