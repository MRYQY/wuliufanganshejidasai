test = [1 2 3;4 5 6;7 8 9;10 11 12];
for i=1:2
xlswrite('车辆配载情况.xlsx',test,strcat('路线',num2str(i)))
end