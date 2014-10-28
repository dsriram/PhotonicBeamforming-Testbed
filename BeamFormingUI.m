function varargout = BeamFormingUI(varargin)
% BEAMFORMINGUI MATLAB code for BeamFormingUI.fig
%      BEAMFORMINGUI, by itself, creates a new BEAMFORMINGUI or raises the existing
%      singleton*.
%
%      H = BEAMFORMINGUI returns the handle to a new BEAMFORMINGUI or the handle to
%      the existing singleton*.
%
%      BEAMFORMINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMFORMINGUI.M with the given input arguments.
%
%      BEAMFORMINGUI('Property','Value',...) creates a new BEAMFORMINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BeamFormingUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BeamFormingUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BeamFormingUI

% Last Modified by GUIDE v2.5 13-Oct-2014 15:59:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BeamFormingUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BeamFormingUI_OutputFcn, ...
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

% --- Executes just before BeamFormingUI is made visible.
function BeamFormingUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BeamFormingUI (see VARARGIN)

% Choose default command line output for BeamFormingUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%str =  varargin{1}
% This sets up the initial plot - only do when we are invisible
% so window can get raised using BeamFormingUI.
amps = varargin{1};
freq = varargin{2};
delay = varargin{3};
beamFormData = struct('ampPlot',amps,'freq',freq,'delay',delay);
handles.beamFormData = beamFormData;
guidata(hObject,handles);
size(amps)
set(handles.text2,'String',strcat(num2str(beamFormData.freq(6)/1e9),' GHz'));
set(handles.axes1,'FontSize',8)
contour(reshape(amps(1,6,:,:),201,201)',20);
contourcbar;
hold on;
scatter([100-0.25 100+0.25],[100 100],'k*');
hold off;
grid on;
set(handles.timeSliderText,'String',strcat('Time: ',num2str(1*2e-10/1e-12),' picoseconds'));
set(handles.inputDelay,'String',strcat('Delay: ',num2str(delay(1)/1e-9),' nanoseconds'));

% UIWAIT makes BeamFormingUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BeamFormingUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bfdata = handles.beamFormData;
amps = bfdata.ampPlot;
f = round(get(handles.slider2,'Value'))+1;
t = round(get(hObject,'Value'))+1;
axes(handles.axes1);
cla;
set(handles.axes1,'FontSize',8)
contour(reshape(amps(t,f,:,:),201,201)',20);
contourcbar;
hold on;
scatter([100-0.25 100+0.25],[100 100],'k*');
hold off;
grid on;
set(handles.timeSliderText,'String',strcat('Time: ',num2str(t*2e-10/1e-12),' picoseconds'));
set(handles.inputDelay,'String',strcat('Delay: ',num2str(bfdata.delay(t)/1e-9),' nanoseconds'));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',0);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%freq axis
bfdata = handles.beamFormData;
amps = bfdata.ampPlot;
t = round(get(handles.slider1,'Value'))+1;
f = round(get(hObject,'Value'))+1;
set(handles.text2,'String',strcat(num2str(bfdata.freq(f)/1e9),' GHz'));
axes(handles.axes1);
cla;
set(handles.axes1,'FontSize',8)
contour(reshape(amps(t,f,:,:),201,201)',20);
contourcbar;
hold on;
scatter([100-0.25 100+0.25],[100 100],'k*');
hold off;
grid on;

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',5);
