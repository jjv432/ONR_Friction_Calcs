function [MuK, MuS] = MuKSCalc(Beginning, End, FileName, StaticBool)
clearvars -except FileName End Beginning StaticBool Slider;

% Reading the 'useful' portions of the exported CSV only
SliderRaw = readmatrix(FileName, 'Range', 'A8');

%Organizing each column of the exported file.  This is hardcoded because it
%is assumed that the exported data will only have one marker with no rigid
%bodies. 
Slider.Frame = SliderRaw(Beginning:End, 1);
Slider.Time = SliderRaw(Beginning:End,2);
Slider.X = SliderRaw(Beginning:End,3);
Slider.Y = SliderRaw(Beginning:End,4);
Slider.Z = SliderRaw(Beginning:End,5);

%% Figure Creation 

%Reference to how to use 'datacursormode':
%https://www.mathworks.com/matlabcentral/answers/408991-how-to-extract-cursor-data-to-a-variable

%Creating a plot of the position of the slider as it moves down the ramp


fig = figure;
    plot(Slider.Z, Slider.Y)
    title('Sliding Plot')
    xlabel('x')
    ylabel('y')

% Enable data cursor mode.  This allows the user to select points on the
% plot that seem like the best beginning and end points to calculate mu
% between.
datacursormode on
dcm_obj = datacursormode(fig);

% Wait while the user to click
fprintf('Select one point, then shift click for a second point further down, then press "Enter"')
pause
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);

%% Sorting info_struct into points

%2 and 1 refer to the second and first points the user clicked on earlier
[Pos2, Pos1] = info_struct.Position;
[Index2, Index1]= info_struct.DataIndex;

%This figure shows the user where the points they selected are actually
%located
figure(3)
    plot(Slider.Z, Slider.Y)
    hold on
    plot(Pos2(1), Pos2(2), 'o')
    hold on
    plot(Pos1(1), Pos1(2), 'o')
    hold off
    legend("","Pos2", "Pos1")

%Calculating angle from the beginning and end positions selected
phi = abs(atand((Pos2(2) - Pos1(2)) / (Pos2(1) - Pos1(1))));

%Static coefficient of friction
if (StaticBool == 'y') || (StaticBool == 'Y')
    MuS = tand(phi);
else
    MuS = "UNRELIABLE";
end
%Calculating r, the linear distance between beginning and end positions of
%the slider
r = sqrt((Pos2(2) - Pos1(2))^2 + (Pos2(1) - Pos1(1))^2);

%% Calculating the approximate linear velocities at each pos1 and pos2

%Beginning and end time associated with the positions on the graph that the
%user clicked on
t_not_1 = Slider.Time(Index1);
t_1 = Slider.Time(Index1 + 1); %Useful for the linear approximation of V

t_not_2 = Slider.Time(Index2);
t_2 = Slider.Time(Index2+1); %Useful for the linear approximation of V


%Finding Vz at Pos1

Z_not_1 = Slider.Z(Index1);
Z_1 = Slider.Z(Index1+1);

Vz_1 = (Z_not_1-Z_1)/(t_not_1-t_1); % Linear approx


%Finding Vz at Pos2

Z_not_2 = Slider.Z(Index2);
Z_2 = Slider.Z(Index2+1);

Vz_2 = (Z_not_2-Z_2)/(t_not_2-t_2);


%Finding Vy at Pos1

Y_not_1 = Slider.Y(Index1);
Y_1 = Slider.Y(Index1+1);

Vy_1 = (Y_not_1-Y_1)/(t_not_1-t_1);


%Finding Vy at Pos2

Y_not_2 = Slider.Y(Index2);
Y_2 = Slider.Y(Index2+1);

Vy_2 = (Y_not_2-Y_2)/(t_not_2-t_2);


%Finding Vtot at both locations (beginning and end)

V_tot_not = sqrt(Vy_1^2 + Vz_1^2);
V_tot = sqrt(Vy_2^2 + Vz_2^2);

% Mu Calculation
g = 9.81;
delta_h = Pos1(2)-Pos2(2); % change in height between the beginning and end

% Value of mu calculated using an energy balance equation where Eo = K + PE
% and E = K + E_nc
MuK = (.5*(V_tot_not^2 - V_tot^2) +g*delta_h) / (g*cosd(phi)*r);

%% Cleanup

close all
fprintf("\n\nKinetic coefficient of friction: %f \n", MuK);
if (StaticBool == 'y') || (StaticBool == 'Y')
    fprintf("Static coefficient of friction: %f \n\n", MuS);
end

end