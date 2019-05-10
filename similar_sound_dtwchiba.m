mats='C:\Users\Aarthi\Desktop\out\Data\phy\a0002.wav';
[x, Fs]=audioread(mats);
N=length(x)/Fs;
[m,n]=size(x);
dt=1/Fs;
t=dt*(0:m-1)';
idx = t<=7;
x = x(idx) ;
t=t(idx);
aud_folder ='C:\Users\Aarthi\Desktop\out\Data\phy';
auds = fullfile(aud_folder, '*.wav');
maF = dir(auds);
k=length(maF);
for d=1:10
    maft= fullfile( maF(d).name);
    acq_fn = fullfile(aud_folder, maF(d).name);
        %disp(acq_fn);
    [xe, Fse]=audioread(maft);
    N1=length(xe)/Fse;
    [me,ne]=size(xe);
    dt=1/Fse;
    tw=dt*(0:me-1)';
    idx = tw<=7;
    xe = xe(idx) ;
    tw=tw(idx);
    [r, e]=dynamicTimeWarpingSakoeChiba(x,xe,1:); 
    tab(d,:)=table(d, r);


end
for g=1:width(tab)
  tim = tab(:, g);
end
%row=tim.r;
A = table2array(tim);
As=sort(A);
Ds=As(2);
Dsr=round(Ds);
if Dsr>2.5000
    String1="No similar sounds are found";
else    
    row1=tim.r>0.0000 & tim.r<=1.9000;
%treal=row(row1);
    valu=tim.r(row1);
    for v=1:length(valu)
        tabs(v,:)=find(tim.r==valu(v));
    end


    exe=xlsread('C:\Users\Aarthi\Desktop\out\Data\phy\ref.xls');
    for ber=1:length(tabs)
        das(ber,:)=exe(tabs(ber));
        ac(ber,:) = fullfile(aud_folder, maF(tabs(ber)).name);
    end
    traw=table(das,ac);   
    repe=mode(traw.das);
    disp("Similar Files are");
    disp(ac);
    if repe==1
        String1='Normal';
        disp(String1);
    else
        String1='Abnormal';
         disp(String1);
    end   
end


 


