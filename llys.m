
f2=@(a)(30.6+61.2*a/13)*(6.5-7*a/13)-(27.2+61.2*a/13+5.1*(2+6*a/13)*(2+6*a/13));
a=-2.5:0.01:2.5;
l=length(a);
y2=zeros(l);
for i=1:l
    y2(i)=f2(a(i));
end
figure
plot(a,y2)
hold on
legend('Mmax')
xlabel('a/m')
ylabel('M/Nm')
title('M-a�仯ͼ')
