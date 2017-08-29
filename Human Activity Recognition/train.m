
% 1 meganta - sit
% 2 black - stand
% 3 red - jog
% 4 green -  jump
% 5 blue - walk 

win =40;
slide = 15;
c = 1;
for i = 1:5
    A = xlsread(strcat('a',num2str(i)),'Sheet1');
    x = medfilt1(A(:,1) - mean(A(:,1)),4);
    y = medfilt1(A(:,2) - mean(A(:,2)),4);
    z = medfilt1(A(:,3) - mean(A(:,3)),4);
    p = medfilt1(A(:,4) - mean(A(:,4)),4);
    %air = medfilt1(A(:,5) - mean(A(:,5)),4);

    for j = 1:slide:size(A,1)-win
        P1(1,c) = std(x(j:j+win));
        P1(2,c) = std(y(j:j+win));
        P1(3,c) = std(z(j:j+win));
        P1(4,c) = std(p(j:j+win));
        
        P2(1,c) = max(p(j:j+win));
        P2(2,c) = area(p(j:j+win));
        P2(3,c) = min(p(j:j+win));
        P2(4,c) = std(p(j:j+win));
        
        P3(1,c) = mean(x(j:j+win).^2);
        P3(2,c) = mean(y(j:j+win).^2);
        P3(3,c) = mean(z(j:j+win).^2);
        
        Y(c) = i;
        c = c+1;
    end
end

A = xlsread('test\test3.xlsx','Sheet1');
%A = A(1185:1477,:);
x = medfilt1(A(:,1) - mean(A(:,1)),4);
y = medfilt1(A(:,2) - mean(A(:,2)),4);
z = medfilt1(A(:,3) - mean(A(:,3)),4);
p = medfilt1(A(:,5) - mean(A(:,5)),4); 
air = medfilt1(A(:,4),4);

c = 1;
activity = ones(1,int8((size(A,1)-win)/slide));
aqhi = ones(1,int8((size(A,1)-win)/slide));
ind = ones(1,int8((size(A,1)-win)/slide));

for j = 1:slide:size(A,1)-win
    Q(1) = std(x(j:j+win));
    Q(2) = std(y(j:j+win));
    Q(3) = std(p(j:j+win));
    tem = median(air(j:j+win));
    
    val = knn(vertcat(P1(1:2,:),P1(4,:)),Y,Q(1,1:3)',3);
    
    % AQHI
    
    if tem <12
        aqhi(c) = 1;
    elseif tem < 15
        aqhi(c) = 2;
    elseif tem <= 18
        aqhi(c) = 3;
    else
        aqhi(c) = 4;
    end

    if val == 1 || val == 2
        Q(1) = max(p(j:j+win));
        Q(2) = area(p(j:j+win));
        Q(3) = min(p(j:j+win));
        Q(4) = std(p(j:j+win));
        activity(c) = knn(P2(:,1:128),Y(1,1:128),Q(1,1:4)',5);
        ind = 3*(aqhi(c) - 1);
    end
    
    if val == 4
        Q(1) = std(x(j:j+win));
        Q(2) = std(y(j:j+win));
        Q(3) = std(z(j:j+win));
       
        val1 = knn(P1(1:3, 128:320),Y(1, 128:320),Q(1,1:3)',5);
        Q(1) = mean(x(j:j+win).^2);
        Q(2) = mean(y(j:j+win).^2);
        Q(3) = mean(z(j:j+win).^2);
        val2 = knn(P3(:, 128:320),Y(1, 128:320),Q(1,1:3)',5);
        if val1 == 4 || val2 == 4
            activity(c) = 4;
        else
            if val1 == 4
                val = val2;
            else
                val = val1;
            end
        end 
        if val == 4
            ind(c) = 3*(aqhi(c) - 1) + 2;
        elseif val == 5
             ind(c) = 3*(aqhi(c) - 1) + 1;
        end
    end

    if  val == 3 || val == 5
        Q(1) = std(y(j:j+win));
        Q(2) = std(p(j:j+win));
        activity(c) = knn(horzcat(P1(2:2:4,128:192),P1(2:2:4,256:320)),horzcat(Y(128:192),Y(256:320)),Q(1,1:2)',5);
        if activity(c) == 3
            ind(c) = 3*(aqhi(c) - 1) + 2;
        else
            ind(c) = 3*(aqhi(c) - 1) + 1;
        end
    end
    
    
    c = c+1;
    
end
figure(1),
temp = medfilt1(activity,3);
activity(2:length(activity)) = temp(2:length(temp));
scatter(1:c-1,activity);

%physical activity plot

figure(2),
bins = histc(activity,1:5);
c = 1;
s = {'Sitting: ';'Standing: ';'Jogging: ';'Jumping: ';'Walking: '};
str = {};
for i = 1:5
    if bins(i) ~= 0
        str(c,:) = s(i);
        c = c+1;
    end
end    
disp(bins);
h = pie(bins);
hText = findobj(h,'Type','text'); % text handles
percentValues = get(hText,'String'); % percent values
combinedstrings = strcat(str,percentValues); % text and percent values
set(hText,{'String'},combinedstrings);

%AQHI plot

figure(3),
bins = histc(aqhi,1:4);
c = 1;
s = {'Fresh Air: ';'Moderate Pollution: ';'High Pollution: ';'Very High Pollution: ';};
str = {};
for i = 1:4
    if bins(i) ~= 0
        str(c,:) = s(i);
        c = c+1;
    end
end    
disp(bins);
h = pie(bins);
hText = findobj(h,'Type','text'); % text handles
percentValues = get(hText,'String'); % percent values
combinedstrings = strcat(str,percentValues); % text and percent values
set(hText,{'String'},combinedstrings);

messages = {'You have not been doing much physical activity(sedentry) and the Air Quality around is Fresh Air, hence ideal to go out.',
    'You have been doing moderate physical activity, and the air quality outside if Fresh Air hence making it ideal.',
    'You have been doing vigorous physical activity, but since the Air Quality outside is Fresh Air, you are at no threat of exposure to polluted air.';
    'You have not been doing much physical activity(sedentry) and the Air outside is moderately polluted.',
    'You have been doing moderate physical activity, and the Air Quality outside is moderately polluted. You can continue unless you have symptoms of any respiratory disease.',
    'You have been doing vigorous physical activity and the Air Quality outside is moderately polluted, you should stop if you have any symptoms of respiratory problem.';
    'You have not been doing much physical activity(sedentry) and the Air Quality around is Highly Polluted, hence not ideal to go out.',
    'You have been doing moderate physical activity, and the air quality outside is Highly Polluted, hence you can reconsider/reschedule your activities making it ideal.',
    'You have been doing vigorous physical activity and since the Air Quality outside is Highly Polluted, you are at a threat of exposure to polluted air. So, you can reconsider/reschedule your physical activity.';
    'You have not been doing much physical activity(sedentry) and the Air outside is Very Highly Polluted. So you should not increase your physical activity.',
    'You have been doing moderate physical activity, and the Air Quality outside is Very Highly Polluted. You should lower down your activities immediately.',
    'You have been doing vigorous physical activity and the Air Quality outside is Very Highly Polluted. You should stop your activity with immediate effect.';
    };

st = strcat('Images\',num2str(median(ind)+1));
st =  strcat(st,'.png');

mess = imread(st);

figure(4),
imshow(mess);

