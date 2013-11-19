%/**************************************************************************/

%Modified by Miguel Rivas, Meka Robotics
%Modification Notes:
%Exit the program with Ctrl+C
%If the script doesn't run, do "a = instrfind; delete(a)" then unplug &
%replug the Arduino.


%Modifications to takktile_matlab.m provided by TakkTile
%@file takktile_matlab.m
%@author Yaroslav Tenzer
%@license BSD

%Matlab example to capture data from the Arduino which is connected to the TakkTile Strip sensor

%This is a library for the TakkTile Strip sensor
%----> http://www.takktile.com/product:takkstrip

%@section HISTORY

%v1.0 - First release by Yaroslav Tenzer

%@section NOTES
% inspired partially by the code of Erin, the RobotGrrl 
% from http://robotgrrl.com/blog/2010/01/15/arduino-to-matlab-read-in-sensor-data/
%/**************************************************************************/

clear all; close all;
i=0;
drawIndex = linspace(1,100);
drawData1 = zeros(1,100); drawData2 = zeros(1,100); drawData3 = zeros(1,100); drawData4 = zeros(1,100); drawData5 = zeros(1,100);
drawData6 = zeros(1,100); drawData7 = zeros(1,100); drawData8 = zeros(1,100); drawData9 = zeros(1,100); drawData10 = zeros(1,100);
drawData11 = zeros(1,100); drawData12 = zeros(1,100); drawData13 = zeros(1,100); drawData14 = zeros(1,100); drawData15 = zeros(1,100);
drawData16 = zeros(1,100); drawData17 = zeros(1,100); drawData18 = zeros(1,100); drawData19 = zeros(1,100); drawData20 = zeros(1,100);
% figure
s = serial('COM11'); % for windows
% s = serial('/dev/ttyACM0'); % for ubuntu

set(s,'Baudrate',115200);
set(s,'DataBits', 8);
set(s,'StopBits', 1);
fopen(s)
s.ReadAsyncMode = 'continuous';

% Start asynchronous reading
readasync(s);
% figure;
% hold on; 
%%

try
    
% while i<300
while (1)
        tline1 = fscanf(s, '%s');
        ss=tline1(2:end-1); % remove the outside brackets

        tline1(tline1(:)=='[')=[];
        tline1(tline1(:)==']')=[];
        bb=str2num(tline1);
        
        if i==10
            bb0=bb;
        end

        
        if i>10

        cc = bb0 - bb;
        
            
        % write nums into a text file with time stamp
         dlmwrite('data.txt', [clock num1 num2 num3 num4 num5],'-append', 'delimiter', '\t', 'newline', 'pc')
%        dlmwrite('20130819_calib_4_2.txt', [clock cc],'-append', 'delimiter', '\t', 'newline', 'pc')
    
            
        drawData1 = [drawData1(2:end) cc(1)];
        drawData2 = [drawData2(2:end) cc(2)];
        drawData3 = [drawData3(2:end) cc(3)];
        drawData4 = [drawData4(2:end) cc(4)];
        drawData5 = [drawData5(2:end) cc(5)];
        drawData6 = [drawData6(2:end) cc(6)];
        drawData7 = [drawData7(2:end) cc(7)];
        drawData8 = [drawData8(2:end) cc(8)];
        drawData9 = [drawData9(2:end) cc(9)];
        drawData10 = [drawData10(2:end) cc(10)];
        drawData11 = [drawData11(2:end) cc(11)];
        drawData12 = [drawData12(2:end) cc(12)];
        drawData13 = [drawData13(2:end) cc(13)];
        drawData14 = [drawData14(2:end) cc(14)];
        drawData15 = [drawData15(2:end) cc(15)];
        drawData16 = [drawData16(2:end) cc(16)];
        drawData17 = [drawData17(2:end) cc(17)];
        drawData18 = [drawData18(2:end) cc(18)];
        drawData19 = [drawData19(2:end) cc(19)];
        drawData20 = [drawData20(2:end) cc(20)];
        [drawData1(1) drawData2(1) drawData3(1) drawData4(1) drawData5(1)]

        subplot(4,1,1)
        plot(drawIndex, drawData1, drawIndex, drawData2, drawIndex, drawData3, drawIndex, drawData4, drawIndex, drawData5)
%         axis([0 100 -10 10])
        subplot(4,1,2)
        plot(drawIndex, drawData6, drawIndex, drawData7, drawIndex, drawData8, drawIndex, drawData9, drawIndex, drawData10)
%         axis([0 100 -10 10])
        subplot(4,1,3)
        plot(drawIndex, drawData11, drawIndex, drawData12, drawIndex, drawData13, drawIndex, drawData14, drawIndex, drawData15)
%         axis([0 100 -10 10])
        subplot(4,1,4)
        plot(drawIndex, drawData16, drawIndex, drawData17, drawIndex, drawData18, drawIndex, drawData19, drawIndex, drawData20)
%         axis([0 100 -10 10])
        
%         Can adjust the axes to something that involves one of the
%         initual_num values
        drawnow
        end
        
        i=i+1;


end
%% ----

catch err
%        rethrow(err);
    err
    fclose(s);
end

%% --
stopasync(s);
fclose(s)


