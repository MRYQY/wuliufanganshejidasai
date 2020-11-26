clear 
clc
%%数据处理部分
OFG=xlsread('附件8：两日订单-2.xlsx',"623订单");%读取订单数据
%%配送模型

LL=4;%类为四
X=OFG(:,9:10);
cindex=kmeans(X,LL);%聚类数据
xlswrite('车辆配载情况.xlsx',cindex,'配送模式')
v=zeros(length(cindex),1);%单位容量
w=zeros(length(cindex),1);%单位质量
Va=[2;3;6;10;13;15;25];
Wa=[4;6;15;17;30;40;50];
V=6;%总体积
W=15;%总质量
choose=1;%选择车辆
xx=zeros(length(cindex),10);
fxx=zeros(1,10);  
q=zeros(length(cindex),1);%货物数量
for uu=1:LL
    disp(uu)
    for i=1:length(cindex)
        if cindex(i)==uu
            v(i)=OFG(i,13); 
            w(i)=OFG(i,14);
            q(i)=OFG(i,1);
        end
    end

    for nn=1:20


        T=1000; %初始化温度值
        T_min=1e-12; %设置温度下界
        alpha=0.98; %温度的下降率
        k=1000; %迭代次数（解空间的大小）
        x=getX(length(cindex),q); %随机得到初始解
        cr=st(x,v,w,V,W);
        while not(cr)
            x=getX(length(cindex),q); %随机得到初始解
            cr=st(x,v,w,V,W);

        end
        while(T>T_min)
            for I=1:100
                fx=Fx(x,v,w,V,W);
                x_new=getnewX(x,length(cindex),q);
                cr=st(x,v,w,V,W);
                if cr
                    fx_new=Fx(x_new,v,w,V,W);
                    delta=fx_new-fx;
                    if (delta<0)
                        x=x_new;
                        fx=fx_new;
                    else
                        P=getP(delta,T);
                        if(P>rand)
                            x=x_new;
                            fx=fx_new;
                        end
                    end
                end
            end
            T=T*alpha;
        end
        xx(:,nn)=x;
        fxx(1,nn)=Fx(x_new,v,w,V,W);
        q=q-x;
    end
    xlswrite('车辆配载情况2.xlsx',xx,strcat('路线',num2str(uu)))
                           
end




function x=getX(N,q)

    x=zeros(N,1);
    for i=1:N
        x(i)=fix(rand*q(i));
    end
    
end
function x=getnewX(x,N,q)
    for j=1:N
        pp=fix(rand*N+1);
        if x(pp)<q(pp)
            x(pp)=x(pp)+1;
        end
    end
    for j=1:N
        pp=fix(rand*N+1);
        if x(pp)>0 && x(pp)<q(pp)
            x(pp)=x(pp)-1;
        end
    end
end
function fx=Fx(x,v,w,V,W)
    a=0;
    b=0;
    for i=1:length(x)
        a=a+v(i)*x(i);
        b=b+w(i)*x(i);
    end
    fx=(V/W-a/b)^2-a/V-b/W;
end
function p=getP(c,t)
    p=exp(-c/t);
end
function cr=st(x,v,w,V,W)
    a=0;
    b=0;
    for i=1:length(x)
        a=a+w(i)*x(i);
        b=b+v(i)*x(i);
    end
    if a<=W && b<=V
        cr=1;
    else
        cr=0;
    end
end