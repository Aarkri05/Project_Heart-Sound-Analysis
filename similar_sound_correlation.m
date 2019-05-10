mats='E:\saml\New_MS_188.wav';
[x, Fs]=audioread(mats);
N=length(x)/Fs;
 
[m,n]=size(x);
dt=1/Fs;
ta=dt*(0:m-1)';
idx = ta<=7;
x = x(idx) ;
aud_folder ='E:\saml';
auds = fullfile(aud_folder, '*.wav');
maF = dir(auds);
k=length(maF);
for d=1:k
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
    [C1,lag1] = xcorr(x,xe);        
   
    [~,I] = max(abs(C1));
    SampleDiff = lag1(I);
    timeDiff = SampleDiff/Fs;
   
    if(SampleDiff & timeDiff)~=0
        delaye = finddelay(x,xe);
        if delaye>0
            s1 = alignsignals(xe,x);
            [C1,lag1] = xcorr(x,s1);
            [~,I] = max(abs(C1));
            SampleDiff = lag1(I);
            timeDiff = SampleDiff/Fs;
            tab(d,:)=table(d, SampleDiff, timeDiff);
        end    
    end
     tab(d,:)=table(d, SampleDiff, timeDiff);
end

for g=1:width(tab)
  %fprintf('\nHere is column #%d, named %s\n', g, tab.Properties.VariableNames{g})
  tim = tab(:, g);
end

row=tim.timeDiff<=0.0050 & tim.timeDiff>0.0001;
values=tim.timeDiff(row);
b=tab(tab.timeDiff==values,:);
t=b.d(1);
maft= fullfile( maF(t).name);
acq = fullfile(aud_folder, maF(t).name);
[p, name, ext] = fileparts(acq);
exe=xlsread('E:\saml\simi.xlsx');
d=exe(t);
if d==1
    disp("The given sound therefore belongs to AS sound");
elseif d==2
    disp("The given sound therefore belongs to  MS sound ");
else
    disp("The given sound therefore belongs to  MS sound ");
end    
 
    
    


