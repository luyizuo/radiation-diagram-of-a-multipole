% =========================================================================
%{
task:
    calculate a multipole's farfield ...
link:
    can sending data to "draw_radiation_diagram_of_a_multipole.m"
input:
    multipole: .....
        for a dipole, multipole = [px; py; pz]
        for a quadruple, multipole = [Qxx Qxy Qxz; Qyx Qyy Qyz; Qzx Qzy Qzz]
output:
    farfield....
note:
    the location where the multipole is always [0 0 0].

version: 1.0, date: 2020/3/11, author: YiLi Lu
%} 
clc;clear;
% =========================================================================
%{
some key variables
    N_theta: the number of sample points of "theta"
    N_phi: the number of sample points of "phi"
    N: the total number of sample points on the sphere
%}
% =========================================================================

%% choose an input

multipole = [1; 0; 0];

% multipole = ones(3,3);

% multipole = [1 0 0;...
%              0 1 1;...
%              0 1 -2];

% multipole = ones(3,3,3);

multipole_class = "electric";
% multipole_class = "magnetic";


%% grid setting

N_theta = 60;
N_phi = 60;
N = N_theta*N_phi; % the total number of sample points on the sphere

theta = linspace(0,pi,N_theta).';
phi = linspace(0,2*pi,N_phi);

nx_2d = sin(theta).*cos(phi); % 2d means it is a matrix form
ny_2d = sin(theta).*sin(phi);
nz_2d = repmat(cos(theta),1,N_phi);

nx = nx_2d(:);
ny = ny_2d(:);
nz = nz_2d(:);
n = [nx ny nz];

%% calcute E-field

if multipole_class == "electric"
    
    % adjust dimensions in preparation for the following matrix operation
    multipole = shiftdim(multipole,-1);
    n_temp = permute(shiftdim(n,-1),[2 1 3]);
    
    % do contraction
    for ii=1:ndims(multipole)-2 % 对于输入X是向量时 for ii=1:0 会自动跳过
        multipole = squeeze(sum(multipole.*n_temp,3)); % 对第三阶进行缩并
    end
    
    % calculate $(n_i n_j - \delta_{ij}) X_j$
    E = n.*sum(multipole.*n,2) - multipole;
    
elseif multipole_class == "magnetic"
    
    temp = permute(multipole.*n_temp,[1 3 2]);
    E = [temp(:,2,3) - temp(:,3,2)...
         temp(:,3,1) - temp(:,1,3)...
         temp(:,1,2) - temp(:,2,1)];
end

%% choose an ouput type

% column type: if output data consists of n [N * 3] and I [N * 1]
% matrix type: if output data consists of I [N_theta * N_phi] and n
% [N_theta * N_phi *3] 


% output_type = "column";
output_type = "matrix";

%% save 

I = sum(E.*conj(E),2);

if output_type == "column"
    save I_field I n
elseif output_type == "matrix"
    
    % turn I to 2-d
    I = reshape(I, N_theta, N_phi);   
    % turn n to 2-d
    n = reshape(n, N_theta, N_phi, 3);

    save I_field I n theta phi
end







