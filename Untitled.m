clc
clear
load fisheriris
X = [1 1;1.2 1.3;1.4,1.5;0.9,0.99;0 0; 0.1 0.1;0.3 0.3;0.2 0.4];
y = [1,1,1,1,0,0,0,0];
rng(1); % For reproducibility
SVMModel = fitcsvm(X,y,'ClassNames',[false true],'Standardize',true,...
    'KernelFunction','rbf','BoxConstraint',1);

d = 0.01;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
N = size(xGrid,1);
Scores = zeros(N,2);

[~,score] = predict(SVMModel,xGrid);
Scores(:,1) = score(:,2);
[~,maxScore] = max(Scores,[],2);

figure
h(1:2) = gscatter(xGrid(:,1),xGrid(:,2),maxScore,[0.1 0.5 0.5; 0.5 0.1 0.5]);
hold on
h(3:4) = gscatter(X(:,1),X(:,2),y);
axis tight
hold off

