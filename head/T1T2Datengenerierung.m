close all; 
clear;
N=224;
z=0;
% Parameter
M0=1;
t_1=0.02;
T1_scalp =0.324;
T1_csf=4.2;
T1_GM=0.857;
T1_WM=0.583;

M0_xy=1;
t_2=0.02;
T2_scalp=0.070;
T2_csf=1.99;
T2_GM=0.1;
T2_WM=0.08;

for i=1:200                  %Anzahl der Durchläufe x*14
%Anatomie Variationen random
%(rand(1)*(start-ende)+ende);
y_GM = (rand(1)*(-0.04+0.04)+0.04);
x_csf = (rand(1)*(0.1-0.35)+0.35);
y_csf = (rand(1)*(-0.3+0.04)+0.04);
y_WM = (rand(1)*(0.3-0.5)+0.5); 
phi_csf = (rand(1)*(0.1-45)+45); 


% Grauwerte der jeweiligen Elipse nach T1
scalpT1 = (-M0*(1-2*exp(-t_1/T1_scalp)));        % hell
GMT1 = (-M0*(1-2*exp(-t_1/T1_GM))+scalpT1);      % dunkelgrau
CSFT1 = (M0*(1-2*exp(-t_1/T1_csf))-GMT1);        % dunkel 
WMT1 =(- M0*(1-2*exp(-t_1/T1_WM))-GMT1);         % hellgrau

%Grauwerte der jeweiligen Elipse nach T2
scalpT2 = M0_xy*exp(-t_2/T2_scalp);               % hell
GMT2 = M0_xy*exp(-t_2/T2_GM)+scalpT2;            % hellgrau 
CSFT2 = M0_xy*exp(-t_2/T2_csf)+GMT2;             % weiß
WMT2 = M0_xy*exp(-t_2/T2_WM)-GMT2;                % dunkel


%Matrix für Shepp Logan mit Intensitäten für T1
%         A         a        b     x0    y0    phi
%        --------------------------------------------
T1    = [ scalpT1   .69   .92      0     0     0          % scalp
          GMT1      .6624 .8740    0    y_GM   0          % GM
          CSFT1     .1100 .3100  x_csf  y_csf -phi_csf    % CSF
          CSFT1     .1600 .4100 -x_csf  y_csf  phi_csf    % CSF
          WMT1      .2100 .2500    0    y_WM    0];       % WM
         
 
%Matrix für Shepp Logan mit Intensitäten für T2 
%         A           a     b     x0    y0     phi
%        --------------------------------------------
T2    = [ scalpT2   .69    .92     0       0     0          % scalp
          GMT2      .6624 .8740    0      y_GM   0          % GM
          CSFT2     .1100 .3100   x_csf   y_csf -phi_csf    % CSF
          CSFT2     .1600 .4100  -x_csf   y_csf  phi_csf    % CSF
          WMT2      .2100 .2500    0      y_WM   0];        % WM

z= z+1;
figure(1);
PhantomT1 = phantom(T1,N);
PhantomT1b= PhantomT1*.223;
%imshow(PhantomT1b)
imwrite(PhantomT1b,sprintf('T1.%d.jpg',z),"jpg") 

figure(2);
PhantomT2= phantom(T2,N);
PhantomT2b = PhantomT2*.223;
%imshow(PhantomT2b)
imwrite(PhantomT2b,sprintf('T2.%d.jpg',z),"jpg") 

%Rotation
z= z+1;
tform = randomAffine2d('Rotation',[-45 45]); 
outputView = affineOutputView(size(PhantomT1b),tform);
imAugmentedRot = imwarp(PhantomT1b,tform,'OutputView',outputView);  
imwrite(imAugmentedRot,sprintf('T1.%d.jpg',z),"jpg") 

tform = randomAffine2d('Rotation',[-45 45]); 
outputView = affineOutputView(size(PhantomT2b),tform);
imAugmentedRot = imwarp(PhantomT2b,tform,'OutputView',outputView);  
imwrite(imAugmentedRot,sprintf('T2.%d.jpg',z),"jpg") 

%Translation
z= z+1;
tform = randomAffine2d('XTranslation',[-5 5],'YTranslation',[-5 5]);
outputView = affineOutputView(size(PhantomT1b),tform);
imAugmentedTrans = imwarp(PhantomT1b,tform,'OutputView',outputView);
imwrite(imAugmentedTrans,sprintf('T1.%d.jpg',z),"jpg") 

tform = randomAffine2d('XTranslation',[-5 5],'YTranslation',[-5 5]);
outputView = affineOutputView(size(PhantomT2b),tform);
imAugmentedTrans = imwarp(PhantomT2b,tform,'OutputView',outputView);
imwrite(imAugmentedTrans,sprintf('T2.%d.jpg',z),"jpg") 

%Scale
z= z+1;
tform = randomAffine2d('Scale',[0.5,1.2]);
outputView = affineOutputView(size(PhantomT1b),tform);
imAugmentedScale = imwarp(PhantomT1b,tform,'OutputView',outputView);
imwrite(imAugmentedScale,sprintf('T1.%d.jpg',z),"jpg") 

tform = randomAffine2d('Scale',[0.5,1.2]);
outputView = affineOutputView(size(PhantomT2b),tform);
imAugmentedScale = imwarp(PhantomT2b,tform,'OutputView',outputView);
imwrite(imAugmentedScale,sprintf('T2.%d.jpg',z),"jpg") 

%Reflection
z= z+1;
tform = randomAffine2d('XReflection',true,'YReflection',true);
outputView = affineOutputView(size(PhantomT1b),tform);
imAugmentedReflection = imwarp(PhantomT1b,tform,'OutputView',outputView);
imwrite(imAugmentedReflection,sprintf('T1.%d.jpg',z),"jpg") 

tform = randomAffine2d('XReflection',true,'YReflection',true);
outputView = affineOutputView(size(PhantomT2b),tform);
imAugmentedReflection = imwarp(PhantomT2b,tform,'OutputView',outputView);
imwrite(imAugmentedReflection,sprintf('T2.%d.jpg',z),"jpg") 

%Shear
z= z+1;
tform = randomAffine2d('XShear',[-10 10]); 
outputView = affineOutputView(size(PhantomT1b),tform); 
imAugmentedShear = imwarp(PhantomT1b,tform,'OutputView',outputView);
imwrite(imAugmentedShear,sprintf('T1.%d.jpg',z),"jpg") 

tform = randomAffine2d('XShear',[-10 10]); 
outputView = affineOutputView(size(PhantomT2b),tform); 
imAugmentedShear = imwarp(PhantomT2b,tform,'OutputView',outputView);
imwrite(imAugmentedShear,sprintf('T2.%d.jpg',z),"jpg") 

%Rauschen
z= z+1;
imAugmentedNoise = imnoise(PhantomT1b,'gaussian',0.01);
imwrite(imAugmentedNoise,sprintf('T1.%d.jpg',z),"jpg")

imAugmentedNoise = imnoise(PhantomT2b,'gaussian',0.01);
imwrite(imAugmentedNoise,sprintf('T2.%d.jpg',z),"jpg")
end