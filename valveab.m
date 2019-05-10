function varargout = first2(varargin)
% FIRST2 MATLAB code for first2.fig
%      FIRST2, by itself, creates a new FIRST2 or raises the existing
%      singleton*.
%
%      H = FIRST2 returns the handle to a new FIRST2 or the handle to
%      the existing singleton*.
%
%      FIRST2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRST2.M with the given input arguments.
%
%      FIRST2('Property','Value',...) creates a new FIRST2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before first2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to first2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help first2

% Last Modified by GUIDE v2.5 27-Feb-2019 16:58:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @first2_OpeningFcn, ...
                   'gui_OutputFcn',  @first2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before first2 is made visible.
function first2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to first2 (see VARARGIN)

% Choose default command line output for first2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes first2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = first2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fullpathname;
global x;
global org;
global y;
global Fs;
[filename, pathname] = uigetfile({'*.wav'}, 'Select File');
fullpathname = strcat(pathname, filename);
[x, Fs] = audioread(fullpathname);
player = audioplayer(x, Fs);
playblocking(player);
stop(player);
N=length(x)/Fs;
[m,n]=size(x);
dt=1/Fs;
t=dt*(0:m-1)';
 
axes(handles.axes1)
plot(x);
xlabel('Time(s)');
ylabel('Amplitude');
title('Signal Before Denoising');
y = wdenoise(x,10, ...
    'Wavelet', 'db6', ...
    'DenoisingMethod', 'Bayes', ...
    'ThresholdRule', 'Median', ...
    'NoiseEstimate', 'LevelDependent');
 
axes(handles.axes2)
plot(y);
xlabel('Time(s)');
ylabel('Amplitude');
title('Signal After Denoising');

[B_low,A_low] = butter(1,20/250,'low');
homomorphic_envelope = exp(filtfilt(B_low,A_low,log(abs(hilbert(y)))));
[up]=envelope(homomorphic_envelope, 1, 'peak');
org=abs(up);
plot(org);
[xq,yq]=ginput(1);
 
axes(handles.axes3);
plot(org);
axis([0 xq 0 yq]);
xlabel('Time(s)');
ylabel('Amplitude');
title('Homomorphic Envelope');

[p, m, wid, pec]=findpeaks(org);
hen=max(wid);
hen2=min(wid);
hen3=hen-hen2;
[p1, m1, wid1, pec1]=findpeaks(org, 'MinPeakHeight', mean(p), 'MinPeakDistance', hen3 );
axes(handles.axes4);
hold on
plot(org);
axis([0 xq 0 yq]);
plot(m1, p1, 'rv', 'MarkerFaceColor', 'b');
xlabel('Time (s)');
ylabel('Amplitude'); 
title('Peak Detection');
%{
e=fix(p1(1)*10)/10;
e1=fix(p1(2)*10)/10;
if length(p1>2)
    e2=fix(p1(3)*10)/10;
 
    if e~=e1  || e==e2 
        if (e-0.1000)~=e1 || (e1-0.1000)==e2
            third_peaks=0;
            first_peaks = p1(1:2:end);
            second_peaks = p1(2:2:end);
            fp=m1(1:2:end);
            sp=m1(2:2:end);
        else
            first_peaks = p1(1:3:end);
            second_peaks = p1(2:3:end);
            third_peaks = p1(3:3:end);
            fp=m1(1:3:end);
            sp=m1(2:3:end);
            dr=m1(3:3:end);
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
else
    first_peaks = p1(1);
    second_peaks = p1(2);
    fp=m1(1);
    sp=m1(2);
end

 
%plot(m1, p1, 'rs','MarkerFaceColor','g');
if third_peaks==0

    %plot(fp, first_peaks, 'rs','MarkerFaceColor','r');
    %plot(sp, second_peaks, 'rs','MarkerFaceColor','b');
    %legend('PCG Signal', String1, String2);
    %xlabel('Time (s)');
    %ylabel('Amplitude');
    %grid on
    %axis tight
end    
if third_peaks~=0
     
    %plot(dr,third_peaks, 'rv','MarkerFaceColor','g');
    %legend('PCG Signal', String1, String2, String3);
    %xlabel('Time (s)');
    %ylabel('Amplitude');
    
    
end
%}


% --- Executes on button press in predict.
function predict_Callback(hObject, eventdata, handles)
% hObject    handle to predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fullpathname;
global org;
global Fs;
load 'E:\cODE\PHASE2\cnnhund.mat';
[p, name, ext] = fileparts(fullpathname);
%newStr = extractBefore(name,7);
%stft
window=hamming(128);
noverlap=64;
nfft=512;
[S, F, T, P]=spectrogram(org, window, noverlap, nfft, Fs, 'yaxis');
axes(handles.axes5);
P=surf(T, F, 10*log10(P), 'edgecolor', 'none');
axis tight;
view(0, 90);
colormap(hot);
%set(gca, 'FontName', 'Times New Roman', 'FontSize', 14);
set(gca, 'clim' ,[-80, 20]);
xlabel('Time, s');
ylabel('Frequency, Hz');
fig=gca;
frame = getframe(fig);
I = frame.cdata;
I = imresize(I,[500 700]);
%u=rgb2gray(I);
cd E:\classify\
mkdir(name);
rt=strcat('E:\classify\', name);
imwrite(I, strcat(rt,'\' ,name,'.jpg'));
%saveas(gcf,['E:\saved\images\spec' num2str(j) '.png']); %Use to display save as image

%cnn
categories ={'AS', 'MR','MS', name};
trainData = imageDatastore(fullfile('E:\classify', categories(1:3)),  'IncludeSubfolders',true, 'LabelSource', 'foldernames');
testData = imageDatastore(fullfile('E:\classify', categories(4)),  'IncludeSubfolders',true, 'LabelSource', 'foldernames');
YPred=classify(trainedNet,testData,'ExecutionEnvironment','cpu');
YTest = testData.Labels;
cf=string(YPred);

set(handles.edit1,'String', cf);
cr=string(YTest);
Finalabel=strcat(cf, '\' , cr);
%accuracy = sum(YPred == YTest)/numel(YTest);

 
 
 


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','yellow');
end
