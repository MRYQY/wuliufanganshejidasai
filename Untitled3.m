
figure
i = 1;
x = -2:.1:2;
hiddenSizes = [1; 5; 10; 30; 50; 80]; %隐层个数，分别取1、5、10、30、50和80
perf = zeros(size(hiddenSizes, 1),5); %保存拟合的误差值
for hs = 1:size(hiddenSizes, 1) %size(A,1)取矩阵的行数
    net = feedforwardnet( hiddenSizes(hs) ); %bp神经网络
    for k = 1:5
        t = cos(k * x);
        net = train(net, x, t);
        y = net(x);
        perf(hs, k) = perform(net, y, t);
        fprintf("hs = %d  k = %d : \n\tperf=%e\n\n", hs, k, perf(hs, k))
        subplot(size(hiddenSizes, 1),5,i); 
        i = i + 1;
        plot(x, t, 'r.',x, y,'g-');
        ax = gca; ax.YLim = [-1 1]; ax.XTick = []; ax.YTick = [];
    end
end
