%loading and playing the audio file
mats='E:\saved\srithi1.wav';
%mats='E:\saved\ampli1.wav';
[x, Fs]=audioread(mats);
%sample = [1,4*Fs];
%clear x Fs;
%[x,Fs] = audioread(mats,sample);

%pla=audioplayer(x, Fs);
%playblocking(pla);
%Fs=Fs/2;
ctff=450;
N = length(x)/Fs;
t = 0:N/(length(x)):N-1/length(x);

y = wdenoise(x,10, ...
    'Wavelet', 'db6', ...
    'DenoisingMethod', 'Bayes', ...
    'ThresholdRule', 'Median', ...
    'NoiseEstimate', 'LevelDependent');

pla=audioplayer(y, Fs);
playblocking(pla);

figure
hold on 
plot(x);
plot(y);
title('Filtered Waveforms');
xlabel('Time (s)');
ylabel('Amplitude');




[B_low,A_low] = butter(1,70/120,'low');
homomorphic_envelope = exp(filtfilt(B_low,A_low,log(abs(hilbert(y)))));

figure
grid on
plot(homomorphic_envelope,'r');
title('Homomorphic Envelope');
xlabel('Time (s)');
ylabel('Amplitude');
axis tight

y=y/max(abs(y))+eps; 
 
en=-y.^2.*log(y.^2); 
 
W=round(Fs*0.03); 
c=0; 
for k=round(W/2):length(y)-round(W/2) 
    c=c+1; 
    u(c)=sum(en(k-round(W/2)+1:k+round(W/2)))/W; 
end 
 
u=0.9*u*max(y)/max(u);

[up, lo]=envelope(u, 2, 'peak');
res=abs(up);
ret=length(res);
   
figure
plot(res);
[tes, mes]=findpeaks(res);
[p, m, wid, pec]=findpeaks(res, 'MinPeakHeight', mean(tes));
hen=max(wid);
hen2=min(wid);
hen3=hen-hen2;
[p1, m1, wid1, pec1]=findpeaks(res, 'MinPeakHeight', mean(tes), 'MinPeakDistance', hen3 );
figure
hold on
plot(res);if ret>10000
    res=res(1:8000)
   
end
plot(m1, p1, 'rv', 'MarkerFaceColor', 'b');
xlabel('Time (s)');
ylabel('Amplitude');

e=fix(p1(1)*10)/10;
e1=fix(p1(2)*10)/10;
e2=fix(p1(3)*10)/10;
e3=fix(p1(4)*10)/10;

if e==e2 || e1==e3
    third_peaks=0;
    first_peaks = p1(1:2:end);
    second_peaks = p1(2:2:end);

end    
if e~=e2 || e1~=e3
    if (e-0.1000)==e2 || (e1-0.1000)==e3
        third_peaks=0;
        first_peaks = p1(1:2:end);
        second_peaks = p1(2:2:end);
    else
        first_peaks = p1(1:3:end);
        second_peaks = p1(2:3:end);
        third_peaks = p1(3:3:end);
    end 
end    

on=first_peaks(1);
tw=second_peaks(1);
hr=third_peaks(1);
ret=[on tw];
[v, in]=max(ret);
on=fix(on*10)/10;
tw=fix(tw*10)/10;
hr=fix(hr*10)/10;

if in==1
    first_peaks=first_peaks;
    second_peaks=second_peaks;
    fp=m1(1:2:end);
    sp=m1(2:2:end);
    
else
    temp=first_peaks;
    first_peaks=second_peaks;
    second_peaks=temp;
    fp=m1(2:2:end);
    sp=m1(1:2:end);
    
end


if third_peaks==0
    if on>tw
        String1='S1';
        String2='S2';
    else
        String1='S2';
        String2='S1';
        String3='S3';
    end
end  


if third_peaks~=0
    if on>tw
        if on>hr
            String1='S1';
            if tw>hr
                String2='S2';
                String3='S3';
            else
                String2='S3';
                String3='S2';
            end
        end
    end    
end


if third_peaks~=0
    if tw>on
        if tw>hr
            String2='S1';
            if on>hr
                String1='S2';
                String3='S3';
            else
                String1='S3';
                String3='S2';
            end
        end
    end    
end


figure
hold on
plot(res);
%plot(m1, p1, 'rs','MarkerFaceColor','g');
if third_peaks==0
    
    plot(fp, first_peaks, 'rs','MarkerFaceColor','r');
    plot(sp, second_peaks, 'rs','MarkerFaceColor','b');
    legend('PCG Signal', 'S1', 'S2');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on
    axis tight
end    
if third_peaks~=0
    plot(m1(3:3:end),third_peaks, 'rv','MarkerFaceColor','g');
    legend('PCG Signal', 'S1', 'S2', 'S3');
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    
end




