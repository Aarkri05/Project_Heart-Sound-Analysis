%tic
%loading audio file
mats='C:\Users\Aarthi\Desktop\Data-Heart\normal__106_1306776721273_C2.wav';
[x, Fs]=audioread(mats);
plas=audioplayer(x, Fs);
playblocking(plas);
N = length(x)/Fs;
t = 0:N/(length(x)):N-1/length(x);
Fnorm =120/(Fs/2);

%applying filter
df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
grpdelay(df,2048,Fs)
D = mean(grpdelay(df));
y = filter(df,[x; zeros(D,1)]);

%playing the signal after filtering
pla=audioplayer(y, Fs);
playblocking(pla);
y = y(D+1:end); 


%plotting the signal before and after fltering
figure
plot(t,x,t,y,'linewidth',1.5);
title('Filtered Waveforms');
xlabel('Time (s)')
legend('Original Noisy Signal','Filtered Signal');
grid on
axis tight

[B_low,A_low] = butter(1,20/250,'low');
homomorphic_envelope = exp(filtfilt(B_low,A_low,log(abs(hilbert(y)))));
%plot(y);
%hold on;
figure
grid on
plot(homomorphic_envelope,'r');
legend('Original Signal','Homomorphic Envelope')
plot(homomorphic_envelope,'r');
axis tight

mer=(mean(homomorphic_envelope))*0.8;
values=(homomorphic_envelope>mer);
figure
hold on
grid on
plot(homomorphic_envelope,'r');
plot(values, 'b');
axis tight


peakee=homomorphic_envelope(values);
mini=min(peakee);
maxi=max(peakee);
meane=mean(peakee);
[p1]=findpeaks(homomorphic_envelope);
fe=min(p1);
fer=median(p1);
fest=mean(p1);
res=max(p1);
feature1=length(p1(:,1));
tmp1=p1(:,1);
tmp1(1)=[ ];
tmp2=p1(:,1);
tmp2(length(p1(:,1)))=[ ];
distance=tmp1-tmp2;
posi=distance>=0;
posit=abs(distance);
rety = mean(posit);
retc = std(posit);
retm=median(posit);
dict = {{'db6',1},{'wpsym4',1},'dct','sin','cos'};
mpdict = wmpdictionary(length(distance), 'lstcpt', dict);
[yfit,r,coeff,iopt,qual] = wmpalg('BMP', distance, mpdict, 'typeplot',...
    'movie','stepplot',5);
avgw=mean(coeff);
sdw=std(coeff);
tes=rms(homomorphic_envelope);

%rte=real(distance);
[peaks, mins]=findpeaks(homomorphic_envelope, Fs,  'MinPeakHeight', meane, 'MinPeakDistance', retc);
[peak1, loc1]=findpeaks(homomorphic_envelope, Fs, 'MinPeakHeight', meane , 'MinPeakDistance',retc);
locs1=(peaks>(maxi/2) & peaks<maxi);
locs2=(peak1>meane & peak1<((meane*3)-0.02));
figure
hold on
plot(t, homomorphic_envelope);
plot(mins(locs1), peaks(locs1), 'rs','MarkerFaceColor','g');
plot(loc1(locs2), peak1(locs2), 'rv','MarkerFaceColor','b');
legend('PCG Signal', 'S1', 'S2');
grid on
axis tight


%mfcc
Tw = 20;                % analysis frame duration (ms)
Ts = 15;                % analysis frame shift (ms)
alpha = 0.97;           % preemphasis coefficient
M = 10;                 % number of filterbank channels 
C = 12;                 % number of cepstral coefficients
L = 20;                 % cepstral sine lifter parameter
LF = 100;               % lower frequency limit (Hz)
HF = 1000;              % upper frequency limit (Hz)
wav_file = mats;  % input audio filename


    % Read speech samples, sampling rate and precision from file
[ speech, fs ] = audioread( wav_file );


    % Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] =mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );


    % Generate data needed for plotting 
[ Nw, NF ] = size( frames );                % frame length and number of frames
time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames 
time = [ 0:length(speech)-1 ]/fs;           % time vector (s) for signal samples 
logFBEs = 20*log10( FBEs );                 % compute log FBEs for plotting
logFBEs_floor = max(logFBEs(:))-50;         % get logFBE floor 
logFBEs( logFBEs<logFBEs_floor ) = logFBEs_floor; % limit logFBE dynamic range


    % Generate plots
figure('Position', [30 30 800 600], 'PaperPositionMode', 'auto', ... 
              'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' ); 
subplot( 311 );
plot( time, speech, 'k' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Time (s)' ); 
ylabel( 'Amplitude' );
title( 'heart waveform'); 

subplot( 312 );
imagesc( time_frames, [1:M], logFBEs ); 
axis( 'xy' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Time (s)' ); 
ylabel( 'Channel index' ); 
title( 'Log (mel) filterbank energies'); 

subplot( 313 );
imagesc( time_frames, [1:C], MFCCs(2:end,:) ); % HTK's TARGETKIND: MFCC
%imagesc( time_frames, [1:C+1], MFCCs );       % HTK's TARGETKIND: MFCC_0
axis( 'xy' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Time (s)' ); 
ylabel( 'Cepstrum index' );
title( 'Mel frequency cepstrum' );

    % Set color map to grayscale
colormap( 1-colormap('gray') ); 

avgfea=mean(FBEs);
stdfea=std(FBEs);
avgcoef=mean(coeff);
stdcoef=std(coeff);
avgmfcc=mean(MFCCs);
avgmfcc=avgmfcc';
mfccd=mean(avgmfcc);
wer=MFCCs>=0;
Data=MFCCs(wer);
Dats=Data';
fun=@meandata;
[Selection , SelectionValue]=Swarm(Dats,20,60,100,fun);
%indicator=1;
MinimizedData=Dats(:,Selection);
disp('Optimized value');
disp(SelectionValue);

tabl=table(avgcoef, mer, logFBEs_floor, rety, sdw, retm, retc, tes, mfccd, res);
%writetable(tabl, 'myout.xlsx');
%[trainedClassifier, validationAccuracy] = svmtrain(tabl);

%tale = readtable('C:\Users\Aarthi\Desktop\Data-Heart\features.xls');


%{
yfitt=eightyfour.predictFcn(tabl);
if yfitt==-1
    figure 
    plot(t, y);
    title("Abnormal")
    
    %disp("Abnormal");
else
    figure 
    plot(t, y);
    title("Normal")
    %disp("Normal");
end
%}
