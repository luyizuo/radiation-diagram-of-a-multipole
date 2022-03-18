% =========================================================================
%{
task:
    draw radiation diagram of a given farfield.
link:
    get data from "calculate_farfield_of_a_multipole.m"
input:
    I-field.mat
output:
    figure.....
note:
    the location where the multipole is always [0 0 0].

version: 1.0, date: 2020/3/11, author: YiLi Lu
%} 
clc;clear;

% =========================================================================

%% input data

% we'll input matrix type data, otherwise subsequent function "surf" will not run
load I_field

%% data processing ------------------------------------------------

Ix = n(:,:,1).*I;
Iy = n(:,:,2).*I;
Iz = n(:,:,3).*I;

%% draw ----------------------------------------------

figure;

ax=gca;
ax.View=[-20,40];

surface = surf(Ix,Iy,Iz);
surface.FaceColor = [.5 .5 .5];
surface.LineStyle = 'none';


axis equal;
axis tight; 
xlabel('x');
ylabel('y');
zlabel('z');


% 红黄色的搭配
light('position',[-1,0,1],'color','r');
light('position',[-1,-5,1],'color','w');
light('position',[-1,-5,1],'color','y');
lighting gouraud; % 用了插值算法，可以让效果看起来更光滑


% 另一种蓝绿色的搭配
% light('position',[-1,0,1],'color','b');
% light('position',[-1,-5,1],'color','w');
% light('position',[-1,-5,1],'color','g');
% lighting gouraud; 

%% save to the local

saveas(gcf, '1', 'jpg')
% saveas(gcf, '2', 'jpg')





