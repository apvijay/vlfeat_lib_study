% Author : Vijay Rengarajan
% Date   : Jan 8, 2015
%
% Study the options available to perform SIFT on images using VLFeat
% library (http://www.vlfeat.org/). I'm on a terrible mood now after a
% breakup.

% Sacred debts
clc;
clear all;
close all;

% I will first try commands available in http://www.vlfeat.org/overview/sift.html

% Read an image
img_col = imread('img/bird_cage_rs.png');
figure(1);
imshow(img_col);

% vl_sift function takes a grayscale image of type single
img = single(rgb2gray(img_col));

% Use vl_sift command to compute keypoints and descriptors
% Each feature is a column in kp and dsc. 
% kp(1:2) = feature point location col,row = x,y
% kp(3) = scale (sigma), kp(4) = orientation (-pi to pi radians)
% Each dsc column is descriptor at a particular keypoint location of length
% 128, corresponding to magnitudes in one of the eight orientations of one
% of the cells in 4x4 region. Refer Lowe.
time_start = tic;
[kp, dsc] = vl_sift(img);
time_end = toc(time_start);
fprintf('Time taken to determine all descriptors: %.4f seconds\n',time_end);

% Visualise a subset of feature keypoints (location, scale and orientation)
sel = randperm(size(kp,2),50);
h1 = vl_plotframe(kp(:,sel));
set(h1,'color','g','LineWidth',2);

% Visualise feature descriptors
h2 = vl_plotsiftdescriptor(dsc(:,sel), kp(:,sel));
set(h2,'color','y');

%% Custom keypoint
figure(2);
imshow(img_col);

% Determine descriptor at custom location, scale, and orientation
kp_cust = [414;291;10;-pi/8];
time_start = tic;
[~, dsc_cust] = vl_sift(img, 'frames', kp_cust);
time_end = toc(time_start);
fprintf('Time taken to determine one descriptor: %.4f seconds\n',time_end);

% Visualise the custom feature descriptor
h3 = vl_plotsiftdescriptor(dsc_cust, kp_cust);
set(h3,'color','y','LineWidth',2);

%% Thresholds

% Ignore features which have abs(DOG) less than peak_thresh
peak_thresh = [0:1:30];
num_kp = zeros(1,numel(peak_thresh),'uint16');
count = 1;
for thresh = peak_thresh
    [kp, dsc] = vl_sift(img, 'PeakThresh', thresh);
    num_kp(count) = size(kp,2);
    count = count + 1;
end
figure(3); hold on;
plot(peak_thresh, num_kp,'b');


% Ignore features which have curvature(DOG) greater than edge_thresh
% Poorly defined peaks of DOF will have large principal curvature
edge_thresh = [1:1:30];
num_kp = zeros(1,numel(edge_thresh),'uint16');
count = 1;
for thresh = edge_thresh
    [kp, dsc] = vl_sift(img, 'EdgeThresh', thresh);
    num_kp(count) = size(kp,2);
    count = count + 1;
end
plot(edge_thresh, num_kp, 'r');
title('Number of features vs. Thresholds of DOG');
xlabel('Threshold value');
ylabel('Number of features');
legend('DOG peak threshold', 'DOG edge threshold');