% Post processing on sensorized cannula

data = dlmread('data.txt', '\t');

% convert from counts to forces

% plot
if size(data,2)==11
figure
plot(datenum(data(:,1:6)),data(:,7:11))
elseif size(data,2)>11
figure
subplot(4,1,1)
plot(datenum(data(:,1:6)),data(:,7:11))
datetick('x','HH:MM:SS');
subplot(4,1,2)
plot(datenum(data(:,1:6)),data(:,12:16))
datetick('x','HH:MM:SS');
subplot(4,1,3)
plot(datenum(data(:,1:6)),data(:,17:21))
datetick('x','HH:MM:SS');
subplot(4,1,4)
plot(datenum(data(:,1:6)),data(:,22:26))
datetick('x','HH:MM:SS');
end



