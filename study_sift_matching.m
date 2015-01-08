% Author : Vijay Rengarajan
% Date   : Jan 8, 2015
%
% Study the options available to perform SIFT matching between two images
% using VLFeat library (http://www.vlfeat.org/).

% Sacred debts
clc;
clear all;
close all;

% I will first try commands available in http://www.vlfeat.org/overview/sift.html

% Read images
img1_col = imread('img/bird_cage.png');
img2_col = imread('img/bird_cage_rs.png');
% figure(1);
% imshow(img_col);

% vl_sift function takes a grayscale image of type single
img1 = single(rgb2gray(img1_col));
img2 = single(rgb2gray(img2_col));

% Determine keypoints and descriptors
[kp1, dsc1] = vl_sift(img1) ;
[kp2, dsc2] = vl_sift(img2) ;

% Match the descriptors 
% Each column of matches has the indices of the dsc1 (taken randomly?) and
% matched dsc2. Score is a row vector of scores of each match in matches.
[matches, scores] = vl_ubcmatch(dsc1, dsc2);

% Sort the matches based on scores (high to low)
[~, perm] = sort(scores, 'descend');
matches = matches(:, perm);
scores = scores(perm);

% Concat images and display side by side
figure(1); clf;
axis image off;
imagesc(cat(2, img1_col, img2_col));

% Display top matches
num_matches = 50;
col1 = kp1(1, matches(1,1:num_matches));
row1 = kp1(2, matches(1,1:num_matches));
col2 = kp2(1, matches(2,1:num_matches)) + size(img2,2); % Image 2 is on the right
row2 = kp2(2, matches(2,1:num_matches));

% Draw line between the matched coordinates
hold on;
h = line([col1;col2], [row1;row2]);
set(h, 'LineWidth', 2, 'Color', 'b');