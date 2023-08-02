function varargout = GuigiaotiepSerielPot(varargin)
% GUIGIAOTIEPSERIELPOT MATLAB code for GuigiaotiepSerielPot.fig
%      GUIGIAOTIEPSERIELPOT, by itself, creates a new GUIGIAOTIEPSERIELPOT or raises the existing
%      singleton*.
%
%      H = GUIGIAOTIEPSERIELPOT returns the handle to a new GUIGIAOTIEPSERIELPOT or the handle to
%      the existing singleton*.
%
%      GUIGIAOTIEPSERIELPOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIGIAOTIEPSERIELPOT.M with the given input arguments.
%
%      GUIGIAOTIEPSERIELPOT('Property','Value',...) creates a new GUIGIAOTIEPSERIELPOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuigiaotiepSerielPot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuigiaotiepSerielPot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuigiaotiepSerielPot

% Last Modified by GUIDE v2.5 30-Dec-2022 19:17:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuigiaotiepSerielPot_OpeningFcn, ...
                   'gui_OutputFcn',  @GuigiaotiepSerielPot_OutputFcn, ...
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


% --- Executes just before GuigiaotiepSerielPot is made visible.
function GuigiaotiepSerielPot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuigiaotiepSerielPot (see VARARGIN)

% Choose default command line output for GuigiaotiepSerielPot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuigiaotiepSerielPot wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global s;
s = serial('COM1');



% --- Outputs from this function are returned to the command line.
function varargout = GuigiaotiepSerielPot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in btnClose.
function btnClose_Callback(hObject, eventdata, handles)
% hObject    handle to btnClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fclose(s);
set(handles.btnOpen,'Enable','on');
set(handles.btnClose,'Enable','off');
set(handles.pumPorts,'Enable','on');
set(handles.pumBaudRates,'Enable','on');



% --- Executes on button press in btnOpen.
function btnOpen_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
% s= seriel('COM1');
portList= get(handles.pumPorts,'String');
portIndex= get(handles.pumPorts,'Value');
port = portList(portIndex,:);
port = char(port);
set(s,'Port',port);

brList=  get(handles.pumBaudRates,'String');
brIndex=  get(handles.pumBaudRates,'Value');
br = brList(brIndex,:);
br= char(br);
br = str2num(br);
set(s,'BaudRate',br);

 s.BytesAvailableFcnMode = 'byte';
 s.BytesAvailableFcnCount= 2;
s.BytesAvailableFcn = {@mycallback, handles};%



fopen(s);
set(handles.btnOpen,'Enable','off');
set(handles.btnClose,'Enable','on');
set(handles.pumPorts,'Enable','off');
set(handles.pumBaudRates,'Enable','off');




% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
if(strcmp(get(s,'Status'),'open'))
fclose(s);
end
delete(s);
clear s;


% --- Executes on selection change in pumPorts.
function pumPorts_Callback(hObject, eventdata, handles)
% hObject    handle to pumPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumPorts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumPorts


% --- Executes during object creation, after setting all properties.
function pumPorts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pumBaudRates.
function pumBaudRates_Callback(hObject, eventdata, handles)
% hObject    handle to pumBaudRates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumBaudRates contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumBaudRates


% --- Executes during object creation, after setting all properties.
function pumBaudRates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumBaudRates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function mycallback(obj, event, handles)  
global s;
data = fread(s,1)
