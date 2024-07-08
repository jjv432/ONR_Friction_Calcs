clc
close all
clearvars -except RawData
format compact

%% Slipping Observations

%{
    
    Marker data not showing each marker.  Think it has something to do with
    removing ... from each of the columns.  May just need to use shorter
    names?

    Y is vertical.  Global isn't doing what I anticpated.  X and Z stil go
    around arc

    !! will likely have to translate to polar (at least) or spherical

%}
DataBool = 0;

if DataBool
    clearvars -except DataBool;
    RawData = readstruct("LocalBoomData_240610.json");
end

% figure()
%     plot3(RawData.BeigeRubber.Take1.BoomLeg_2406Marker1Z, RawData.BeigeRubber.Take1.BoomLeg_2406Marker1X, RawData.BeigeRubber.Take1.BoomLeg_2406Marker1Y)
% 
% 
% figure()
%     plot3(RawData.BeigeRubber.Take1.BoomLeg_2406Marker1Z, RawData.BeigeRubber.Take1.BoomLeg_2406Marker1X, RawData.BeigeRubber.Take1.Time)

%% Reframing coordinate system

R = 1.12; %Boom radius (meters)

Z_Data = RawData.BeigeRubber.Take1.BoomLeg_2406Marker1Z;
X_Data = RawData.BeigeRubber.Take1.BoomLeg_2406Marker1X;
Y_Data = RawData.BeigeRubber.Take1.BoomLeg_2406Marker1Y;

Time =  RawData.BeigeRubber.Take1.Time;


%%

%Normalized Data
X_Norm = X_Data - X_Data(1);
Z_Norm = Z_Data - Z_Data(1);

%Polar Coord Data
Z_Pol = Z_Norm - R;
X_Pol = X_Norm;

temp = islocalmax(Y_Data(1:1500));
[~, temps] = maxk(Y_Data(1:1500).*temp, 16);

figure()
    plot(Time, Y_Data);
    hold on
    for i = 1:length(temps)

            xline(Time(temps(i)), '--')

            hold on

    end
    
    





















