
% 1 meganta - sit
% 2 black - stand
% 3 red - jog
% 4 green -  jump
% 5 blue - walk 

win =40;
slide = 15;
training = [];
group = [];
c = 1;
for i = 1:5
    A = xlsread(strcat('a',num2str(i)),'Sheet1');
    
    x = medfilt1(A(:,1) - mean(A(:,1)),4);
    y = medfilt1(A(:,2) - mean(A(:,2)),4);
    z = medfilt1(A(:,3) - mean(A(:,3)),4);
    pr = medfilt1(A(:,4) - mean(A(:,4)),4);
    for j = 1:slide:size(A,1)-win
        P(1,c) = std(x(j:j+win));
        P(2,c) = std(y(j:j+win));
        P(3,c) = std(z(j:j+win));
        P(4,c) = std(pr(j:j+win));
        
        P(5,c) = max(pr(j:j+win));
        P(6,c) = area(pr(j:j+win));
        P(7,c) = min(pr(j:j+win));
        P(8,c) = std(pr(j:j+win));
        
        P(9,c) = mean(x(j:j+win).^2);
        P(10,c) = mean(y(j:j+win).^2);
        P(11,c) = mean(z(j:j+win).^2);
        
        Y(c) = i;
        c = c+1;
    end
    h = size(P',1);
    training = vertcat(training, P');
    if (i==1 || i==2)
        k = 1;
    else
        k = 2;
    end
    group = vertcat(group,repmat([k],h,1));
end
SVMStruct = svmtrain(training, group);

A = [];
c = 1;
A = xlsread('test\test3.xlsx','Sheet1');
 x = medfilt1(A(:,1) - mean(A(:,1)),4);
 y = medfilt1(A(:,2) - mean(A(:,2)),4);
 z = medfilt1(A(:,3) - mean(A(:,3)),4);
 pr = medfilt1(A(:,4) - mean(A(:,4)),4);
 for j = 1:slide:size(A,1)-win
        Q(1,c) = std(x(j:j+win));
        Q(2,c) = std(y(j:j+win));
        Q(3,c) = std(z(j:j+win));
        Q(4,c) = std(pr(j:j+win));
       
        Q(5,c) = max(pr(j:j+win));
        Q(6,c) = area(pr(j:j+win));
        Q(7,c) = min(pr(j:j+win));
        Q(8,c) = std(pr(j:j+win));
        
        Q(9,c) = mean(x(j:j+win).^2);
        Q(10,c) = mean(y(j:j+win).^2);
        Q(11,c) = mean(z(j:j+win).^2);
        c = c+1;
    end
static = 0;
dynamic = 0;
G = svmclassify(SVMStruct,Q');
for k=1:length(G)
    if (G(k)==1)
        static = static + 1;
    else
        dynamic = dynamic + 1;
    end
end
disp(static);
disp(dynamic);    
