function varargout = sensor_signal(varargin)
% SENSOR_SIGNAL MATLAB code for sensor_signal.fig
%      SENSOR_SIGNAL, by itself, creates a new SENSOR_SIGNAL or raises the existing
%      singleton*.
%
%      H = SENSOR_SIGNAL returns the handle to a new SENSOR_SIGNAL or the handle to
%      the existing singleton*.
%
%      SENSOR_SIGNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SENSOR_SIGNAL.M with the given input arguments.
%
%      SENSOR_SIGNAL('Property','Value',...) creates a new SENSOR_SIGNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sensor_signal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sensor_signal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sensor_signal

% Last Modified by GUIDE v2.5 30-Dec-2022 19:37:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sensor_signal_OpeningFcn, ...
                   'gui_OutputFcn',  @sensor_signal_OutputFcn, ...
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


% --- Executes just before sensor_signal is made visible.
function sensor_signal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sensor_signal (see VARARGIN)

% Choose default command line output for sensor_signal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sensor_signal wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Initialize of global variable
global s;
s = serial('COM1');% assign serial varable 
% --- Outputs from this function are returned to the command line.
function varargout = sensor_signal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Connect_pushbutton.
function Connect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Connect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s; 
portList = get(handles.COMmenu, 'String');% return COM's name of menu
portIndex = get(handles.COMmenu, 'Value');% return COM's value
%set up COM port
port = portList(portIndex, :)
port = char(port);
set (s, 'Port' , port);

baudList = get(handles.BAUDmenu, 'String');% return baudrate's name of menu
baudIndex = get(handles.BAUDmenu, 'Value');% return baudrate's value
%set up baudrate
baud = baudList(baudIndex, :);
baud= char(baud);
baud = str2num(baud);
set (s, 'BaudRate' ,baud );
% When program runs
 s.BytesAvailableFcnMode = 'byte';% Recieved type variable
 s.BytesAvailableFcnCount= 2;%run the function when you recognize 1 byte
% Open COM Port
fopen(s);
% turn on and turn off  The corresponding buttons
set(handles.Connect_pushbutton,'enable','off');
set(handles.Close_pushbutton,'enable','on');
set(handles.COMmenu,'enable','off');
set(handles.BAUDmenu,'enable','off');

i= 0;
data = [];
% Creat Take 200 samples every line graph
while (i<200)
    i=i+1;
    data(i) = fscanf(s,'%d')%reads and converts data from char into number
  	data = [data data(i)];% creat matrix
    drawnow;%Update figure windows and process callbacks
    set(handles.kq,'string', num2str(data(i)));% export steering angle value  
    axes(handles.axes1);%Create axes graph
    plot (data,'g.-','LineWidth', 2);% draw the line graph
    grid on ;%turn on graph net
    axis([0 200 -720 720 ]); %ets scaling for the x- and y-axes
    set(gca, 'ytick', -720:120:720);%setting Tick Mark Locations for y-axes
    xlabel('Time (s)','Fontsize', 16);%X-axis label
    ylabel('Steering Angle (degrees)','Fontsize', 16);%Y-axis label
    title('The line graph shows angle steering over time','Fontsize', 20);%plot title

      end
% --- Executes on button press in Close_pushbutton.
function Close_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Close_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
%close COM Port
fclose(s);
% turn on and turn off  The corresponding buttons
set(handles.Close_pushbutton,'enable','off');
set(handles.Connect_pushbutton,'enable','on');
set(handles.COMmenu,'enable','on');
set(handles.BAUDmenu,'enable','on');


% --- Executes on selection change in COMmenu.
function COMmenu_Callback(hObject, eventdata, handles)
% hObject    handle to COMmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns COMmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from COMmenu



% --- Executes during object creation, after setting all properties.
function COMmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to COMmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BAUDmenu.
function BAUDmenu_Callback(hObject, eventdata, handles)
% hObject    handle to BAUDmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function BAUDmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BAUDmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
if(strcmp(get(s, 'Status'), 'open'))
fclose(s);
end
delete(s);
clear s





function kqangle_Callback(hObject, eventdata, handles)
% hObject    handle to kqangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kqangle as text
%        str2double(get(hObject,'String')) returns contents of kqangle as a double


% --- Executes during object creation, after setting all properties.
function kqangle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kqangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kq_Callback(hObject, eventdata, handles)
% hObject    handle to kq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kq as text
%        str2double(get(hObject,'String')) returns contents of kq as a double


% --- Executes during object creation, after setting all properties.
function kq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
