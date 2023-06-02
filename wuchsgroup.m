function wuchseries=wuchsgroup(measurements)
% convert a group of measurements in wuchswerte
[a b]=size(measurements);
wuchseries=nan(a,b);
wuchseries(1,:)=measurements(1,:);
for i=2:a
    wuchseries(i,:)=wuchswerte(measurements(i,:));
end
%wuchseries=[measurements(1,:); wuchseries(:,:)];