close all; 
clear;
% Parameter
N=224;                 %Größe des Bildes
z=0;                   %Variable für Bildnummerierung
y=0;
%Relaxationszeiten T1
M0 = 1.5;
TR_1 = 0.400;            % TR kurz 300-600ms
TE_1 = 0.001;            % sehr kurzes TE <20ms damit e^(TE/T2) gg 1 geht
%Relaxationszeiten T2
TR_2 = 5;              % Langes TR damit Mz für alle gleich TR>2000ms
TE_2 = 0.125;            % TE 75-125ms länger für größere Unterschiede
% 

for i=1:10000            % Anzahl der Durchläufe pro Durchlauf 1xT1 und 1xT2 
%Relaxationszeiten T1 mit Zufallszahl aus Wertebereich
%Zufallszahl = (rand(1)*(start-ende)+ende);
T1_scalp = (rand(1)*(0.26-0.33)+0.33);  %0.324;
T1_Bone = 0.533;        % (rand(1)*(0.-0.)+0.;
T1_csf= (rand(1)*(2.4-3)+3.0);        % 4.2;
T1_GM= (rand(1)*(0.92-1.08)+1.08);        % 0.857;
T1_WM= (rand(1)*(0.66-0.79)+0.79);        % 0.583;
%Relaxationszeiten T2 mit Zufallszahl aus Wertebereich
T2_scalp= (rand(1)*(0.048-0.084)+0.084);      %  0.070; 
T2_Bone =0.05;        % (rand(1)*(0.-0.)+0.;
T2_csf= 0.280;     % 1.99;  
T2_GM=(rand(1)*(0.11-0.114)+0.114);       % 0.1;
T2_WM= (rand(1)*(0.072-0.092)+0.092);      % 0.08; 


%Anatomie Variationen -->random Ellipsen Position
%Zufallszahl = (rand(1)*(start-ende)+ende);
y_GM = (rand(1)*(-0.04-0.04)+0.04);
x_csf = (rand(1)*(0.1-0.35)+0.35);
y_csf = (rand(1)*(-0.3-0.04)+0.04);
y_WM = (rand(1)*(0.3-0.5)+0.5); 
phi_csf = (rand(1)*(0.1-45)+45); 
%y_Tum = (rand(1)*(-0.65-1)+1);
%x_Tum = (rand(1)*(-0.08-0.08)+0.08);

%Verï¿½nderung der TE und TR zeiten  % https://www.tandfonline.com/doi/pdf/10.1080/02841859409173306
TR_1 = (rand(1)*(0.400-0.600)+0.600); 
TE_1 = (rand(1)*(0.018-0.024)+0.0240);
TE_2 = (rand(1)*(0.075-0.080)+0.080);
TR_2 = 5;%rand(1)*(1.8-2.500)+2.5);

% InTRnsität der jeweiligen Elipse nach T1-Relaxation Blochsche-GL
% Mz=M0*(1-exp(-TR/T1)*exp(-TE/T2)
scalpT1 = (M0*(1-exp(-TR_1/T1_scalp))*exp(-TE_1/T2_scalp)); 
BoneT1 = (M0*(1-exp(-TR_1/T1_Bone))*exp(-TE_1/T2_Bone)); 
GMT1 = (M0*(1-exp(-TR_1/T1_GM))*exp(-TE_1/T2_GM));        
CSFT1 =( M0*(1-exp(-TR_1/T1_csf))*exp(-TE_1/T2_csf));        
WMT1 = (M0*(1-exp(-TR_1/T1_WM))*exp(-TE_1/T2_WM));  
%TumT1 = (M0*(1-exp(-TR_1/T1_Tum))*exp(-TE_1/T2_Tum));

% Intensität der jeweiligen Elipse nach T2-Relaxation Blochsche-GL
% Mxy=-M0*exp(-t/T2)*sin(w0*t)
scalpT2 = M0*(1-exp(-TR_2/T1_scalp))*exp(-TE_2/T2_scalp);  
BoneT2 = M0*(1-exp(-TR_2/T1_Bone))*exp(-TE_2/T2_Bone);  
GMT2 = M0*(1-exp(-TR_2/T1_GM))*exp(-TE_2/T2_GM);            
CSFT2 = M0*(1-exp(-TR_2/T1_csf))*exp(-TE_2/T2_csf);            
WMT2 = M0*(1-exp(-TR_2/T1_WM))*exp(-TE_2/T2_WM);                
%TumT2 = M0*(1-exp(-TR_2/T1_Tum))*exp(-TE_2/T2_Tum);

%Ellipsengröße random
Scalpa = .72;
Scalpb = .95;
Bonea =(rand(1)*(0.67-0.7)+0.7);
Boneb =(rand(1)*(0.92-0.94)+0.94);
CSFa0 =(rand(1)*(0.64-0.66)+0.66);
CFSb0 =(rand(1)*(0.89-0.915)+0.92);
GMa = (rand(1)*(0.5-0.63)+0.63);
GMb = (rand(1)*(0.84-0.875)+0.875);
CSFa1 = (rand(1)*(0.05-0.21)+0.2);
CSFa2 =  (rand(1)*(0.05-0.21)+0.2);
CSFb1 = (rand(1)*(0.1-0.33)+0.45);
CSFb2 = (rand(1)*(0.1-0.33)+0.45);
WMa = (rand(1)*(0.05-0.4)+0.4);
WMb = (rand(1)*(0.05-0.4)+0.4);
%Tuma = (rand(1)*(.0230-0.1380)+0.1380);
%Tumb = (rand(1)*(.0230-0.1380)+0.1380);

%SNR Random 
SNRT1 = (rand(1)*(40-100)+100);


%Matrix für Shepp Logan mit InTRnsitäTRn für T1
%         A         a        b     x0    y0    phi
%        --------------------------------------------
T1    = [ scalpT1   Scalpa Scalpb 0     0     0          % scalp
          BoneT1    Bonea  Boneb  0     0     0         %Bone
          CSFT1     CSFa0  CFSb0  0     0     0         %CSF
          GMT1      GMa    GMb    0    y_GM   0          % GM
          CSFT1     CSFa1 CSFb1  x_csf  y_csf -phi_csf    % CSF
          CSFT1     CSFa2 CSFb2 -x_csf  y_csf  phi_csf    % CSF
          WMT1      WMa    WMb    0    y_WM    0 ];      % WM
         %TumT1      Tuma   Tumb  x_Tum y_Tum   0];            %Tumor

         
z= z+1;
%figure(1);
PhantomT1 = phantom1(T1,N);
%imshow(PhantomT1)
%imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg") 


%Rotation
%z= z+1;
tform = randomAffine2d('Rotation',[-15 15]); 
outputView = affineOutputView(size(PhantomT1),tform);
PhantomT1 = imwarp(PhantomT1,tform,'OutputView',outputView);  
%imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg") 

%Translation
%z= z+1;
tform = randomAffine2d('XTranslation',[-5 5],'YTranslation',[-5 5]);
outputView = affineOutputView(size(PhantomT1),tform);
PhantomT1 = imwarp(PhantomT1,tform,'OutputView',outputView);
%imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg") 


%Scale
%z= z+1;
tform = randomAffine2d('Scale',[0.5,1.2]);
outputView = affineOutputView(size(PhantomT1),tform);
PhantomT1 = imwarp(PhantomT1,tform,'OutputView',outputView);
%imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg") 

%Reflection
%z= z+1;
tform = randomAffine2d('XReflection',true,'YReflection',true);
outputView = affineOutputView(size(PhantomT1),tform);
PhantomT1 = imwarp(PhantomT1,tform,'OutputView',outputView);
%imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg") 

%Shear
%z= z+1;
tform = randomAffine2d('XShear',[-10 10]); 
outputView = affineOutputView(size(PhantomT1),tform); 
PhantomT1 = imwarp(PhantomT1,tform,'OutputView',outputView);
%imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg") 

%Rauschen
%z= z+1;
PhantomT1 = awgn(PhantomT1,SNRT1);         % SNR 
imwrite(PhantomT1,sprintf('T1_%d.jpg',z),"jpg")




end

% for i=1:10              % Anzahl der Durchläufe pro Durchlauf 1xT1 und 1xT2 
% 
% %Relaxationszeiten T2 mit Zufallszahl aus Wertebereich
% T2_scalp= (rand(1)*(0.048-0.084)+0.084);      %  0.070; 
% T2_Bone =0.05;        % (rand(1)*(0.-0.)+0.;
% T2_csf= 0.280;     % 1.99;  
% T2_GM=(rand(1)*(0.11-0.114)+0.114);       % 0.1;
% T2_WM= (rand(1)*(0.072-0.092)+0.092);      % 0.08; 
% 
% %Relaxationszeiten T1 mit Zufallszahl aus Wertebereich
% %Zufallszahl = (rand(1)*(start-ende)+ende);
% T1_scalp = (rand(1)*(0.26-0.33)+0.33);  %0.324;
% T1_Bone = 0.533;        % (rand(1)*(0.-0.)+0.;
% T1_csf= (rand(1)*(2.4-3)+3.0);        % 4.2;
% T1_GM= (rand(1)*(0.92-1.08)+1.08);        % 0.857;
% T1_WM= (rand(1)*(0.66-0.79)+0.79);        % 0.583;
% 
% %Anatomie Variationen -->random Ellipsen Position
% %Zufallszahl = (rand(1)*(start-ende)+ende);
% y_GM = (rand(1)*(-0.04-0.04)+0.04);
% x_csf = (rand(1)*(0.1-0.35)+0.35);
% y_csf = (rand(1)*(-0.3-0.04)+0.04);
% y_WM = (rand(1)*(0.3-0.5)+0.5); 
% phi_csf = (rand(1)*(0.1-45)+45); 
% %y_Tum = (rand(1)*(-0.65-1)+1);
% %x_Tum = (rand(1)*(-0.08-0.08)+0.08);
% 
% %Verï¿½nderung der TE und TR zeiten  % https://www.tandfonline.com/doi/pdf/10.1080/02841859409173306
% TR_1 = (rand(1)*(0.400-0.600)+0.600); 
% TE_1 = (rand(1)*(0.018-0.024)+0.0240);
% TE_2 = (rand(1)*(0.075-0.080)+0.080);
% TR_2 = 5;%rand(1)*(1.8-2.500)+2.5);
% 
% 
% % Intensität der jeweiligen Elipse nach T2-Relaxation Blochsche-GL
% % Mxy=-M0*exp(-t/T2)*sin(w0*t)
% scalpT2 = M0*(1-exp(-TR_2/T1_scalp))*exp(-TE_2/T2_scalp);  
% BoneT2 = M0*(1-exp(-TR_2/T1_Bone))*exp(-TE_2/T2_Bone);  
% GMT2 = M0*(1-exp(-TR_2/T1_GM))*exp(-TE_2/T2_GM);            
% CSFT2 = M0*(1-exp(-TR_2/T1_csf))*exp(-TE_2/T2_csf);            
% WMT2 = M0*(1-exp(-TR_2/T1_WM))*exp(-TE_2/T2_WM);                
% %TumT2 = M0*(1-exp(-TR_2/T1_Tum))*exp(-TE_2/T2_Tum);
% 
% %Ellipsengröße random
% Scalpa = .72;
% Scalpb = .95;
% Bonea =(rand(1)*(0.67-0.7)+0.7);
% Boneb =(rand(1)*(0.92-0.94)+0.94);
% CSFa0 =(rand(1)*(0.64-0.66)+0.66);
% CFSb0 =(rand(1)*(0.89-0.915)+0.92);
% GMa = (rand(1)*(0.5-0.63)+0.63);
% GMb = (rand(1)*(0.84-0.875)+0.875);
% CSFa1 = (rand(1)*(0.05-0.21)+0.2);
% CSFa2 =  (rand(1)*(0.05-0.21)+0.2);
% CSFb1 = (rand(1)*(0.1-0.33)+0.45);
% CSFb2 = (rand(1)*(0.1-0.33)+0.45);
% WMa = (rand(1)*(0.05-0.4)+0.4);
% WMb = (rand(1)*(0.05-0.4)+0.4);
% %Tuma = (rand(1)*(.0230-0.1380)+0.1380);
% %Tumb = (rand(1)*(.0230-0.1380)+0.1380);
% 
% %SNR Random 
% SNRT2 = (rand(1)*(30-100)+100);
%  
% %Matrix für Shepp Logan mit InTRnsitäTRn für T2 
% %         A           a     b     x0    y0     phi
% %        --------------------------------------------
% T2    = [ scalpT2   Scalpa Scalpb  0       0     0          % scalp
%           BoneT2    Bonea  Boneb   0       0     0         %Bone
%           CSFT2     CSFa0  CFSb0   0       0     0         %CSF
%           GMT2      GMa    GMb     0      y_GM   0          % GM
%           CSFT2     CSFa1 CSFb1   x_csf   y_csf -phi_csf    % CSF
%           CSFT2     CSFa2 CSFb2  -x_csf   y_csf  phi_csf    % CSF
%           WMT2      WMa    WMb     0      y_WM   0];       % WM
%           %TumT2      Tuma   Tumb  x_Tum y_Tum   0];            %Tumor
%          
% y= y+1;
% 
% %figure(2);
% PhantomT2 = phantom1(T2,N);
% %imshow(PhantomT2)
% %imwrite(PhantomT2,sprintf('T2_%d.jpg',z),"jpg") 
% 
% %Rotation
% 
% tform = randomAffine2d('Rotation',[-15 15]); 
% outputView = affineOutputView(size(PhantomT2),tform);
% PhantomT2 = imwarp(PhantomT2,tform,'OutputView',outputView);  
% %imwrite(PhantomT2,sprintf('T2_%d.jpg',z),"jpg") 
% 
% %Translation
% 
% tform = randomAffine2d('XTranslation',[-5 5],'YTranslation',[-5 5]);
% outputView = affineOutputView(size(PhantomT2),tform);
% PhantomT2 = imwarp(PhantomT2,tform,'OutputView',outputView);
% %imwrite(PhantomT2,sprintf('T2_%d.jpg',z),"jpg") 
% 
% %Scale
% 
% tform = randomAffine2d('Scale',[0.5,1.2]);
% outputView = affineOutputView(size(PhantomT2),tform);
% PhantomT2 = imwarp(PhantomT2,tform,'OutputView',outputView);
% %imwrite(PhantomT2,sprintf('T2_%d.jpg',z),"jpg") 
% 
% %Reflection
% 
% tform = randomAffine2d('XReflection',true,'YReflection',true);
% outputView = affineOutputView(size(PhantomT2),tform);
% PhantomT2 = imwarp(PhantomT2,tform,'OutputView',outputView);
% %imwrite(PhantomT2,sprintf('T2_%d.jpg',z),"jpg") 
% 
% %Shear
% 
% tform = randomAffine2d('XShear',[-10 10]); 
% outputView = affineOutputView(size(PhantomT2),tform); 
% PhantomT2 = imwarp(PhantomT2,tform,'OutputView',outputView);
% %imwrite(PhantomT2,sprintf('T2_%d.jpg',z),"jpg") 
% 
% %Rauschen
% 
% PhantomT2 = awgn(PhantomT2,SNRT2);        % SNR
% imwrite(PhantomT2,sprintf('T2_%d.jpg',y),"jpg")
% 
% figure(2)
% imshow(PhantomT2)
% 
% 
% end