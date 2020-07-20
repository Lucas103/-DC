% 这个方法是06年经典算法的改进版，去除了拐点带来的影响。
% 输入为RR序列，输出即为心率减速力
% 如果想求心率加速力，只需把deceleration改为false即可
function cap = DCref(RR)
rr = RR(:)';
deceleration = true;
L = 20;
T = 5;
s = 3;

for i=1:(length(rr)-1)
    t1(i)=abs((rr(i+1)-rr(i))/rr(i));
end
m=find(t1>=0.05);
rr=rr(setdiff(1:length(rr),m));


% 确定瞄点
left = filter([0, ones(1, T)/T], 1, rr);   %将RR间期向后移T个单位  第一个变0
left(1:max([T, L])) = NaN;                 %前两个RR变NAN

right = fliplr(filter(ones(1, T)/T, 1, fliplr(rr)));
right(end-max([T, L])+1:end) = NaN;

d = (right - left)*(deceleration*2 - 1);
anchors = find(d>0);  
 
% 确定拐点
for j = 2:length(anchors)-1
    dRR1 = rr(anchors(j))-rr(anchors(j)-1);
    dRR2 = rr(anchors(j)+1)-rr(anchors(j));
    if (dRR1*dRR2 > 0)
        new_anchors(j-1) = anchors(j);
    else
        new_anchors(j-1) = 0;
    end
end

%从锚点中去除拐点
new_anchors(new_anchors == 0) = [];

%心率段确定及相位校正
prsa = nan(2*L+1, 1);
for ii = 1:2*L+1
   prsa(ii) = nanmean(rr(new_anchors - L + ii - 1));
end

%计算心率加速率或减速力
cap = (prsa(L+1) + prsa(L+2) - prsa(L) - prsa(L-1))/4;
   
end