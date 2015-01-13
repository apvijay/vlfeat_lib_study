% Author : Vijay Rengarajan
% Date   : Jan 13, 2015
%
% Implementation of kmeans++ initial centres choosing.

% Sacred debts
clc;
clear all;
close all;

% Generate random 2D points
dim = 2;
numPts = 5000;
data = rand(dim, numPts);

idx = ceil(rand(1) * numPts);
centres(:,1) = data(:,idx);

numClusters = 12;
for j = 2:numClusters
    for i = 1:numPts
        % Squared istance from all chosen centres so far 
        dist_all = sum((repmat(data(:,i),1,size(centres,2)) - centres(:,:)).^2,1);
        % Choose the minimum distance = D^2(x)
        dist_pts(i) = min(dist_all);
    end
    % Probability distribution of D^2(x)
    dist_pts = dist_pts / sum(dist_pts);
    
    % Choose a point from uniform rand distribution, and map to the desired
    % distribution.
    p_cumsum = cumsum(dist_pts);
    idx = find(rand < [p_cumsum(1:end)],1);
    
    centres(:,j) = data(:,idx);
    size(centres);
end

% Plot figure
figure;
hold on;
scatter(data(1,:),data(2,:),48,[0.2 0.2 0.2],'d','filled');
for j = 1:numClusters
    scatter(centres(1,j),centres(2,j),64,'r','o','filled');
end