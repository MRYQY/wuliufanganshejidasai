clear 
clc
%%���ݴ�����
OFG=xlsread('����8�����ն���-2.xlsx',"623����");%��ȡ��������
%%����ģ��

LL=4;%��Ϊ��
X=OFG(:,9:10);
cindex=kmeans(X,LL);%��������
xlswrite('�����������.xlsx',cindex,'����ģʽ')
v=zeros(length(cindex),1);%��λ����
w=zeros(length(cindex),1);%��λ����
Va=[2;3;6;10;13;15;25];
Wa=[4;6;15;17;30;40;50];
V=6;%�����
W=15;%������
choose=1;%ѡ����
xx=zeros(length(cindex),10);
fxx=zeros(1,10);  
q=zeros(length(cindex),1);%��������
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


        T=1000; %��ʼ���¶�ֵ
        T_min=1e-12; %�����¶��½�
        alpha=0.98; %�¶ȵ��½���
        k=1000; %������������ռ�Ĵ�С��
        x=getX(length(cindex),q); %����õ���ʼ��
        cr=st(x,v,w,V,W);
        while not(cr)
            x=getX(length(cindex),q); %����õ���ʼ��
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
    xlswrite('�����������2.xlsx',xx,strcat('·��',num2str(uu)))
                           
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