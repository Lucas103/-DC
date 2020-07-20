% ���������06�꾭���㷨�ĸĽ��棬ȥ���˹յ������Ӱ�졣
% ����ΪRR���У������Ϊ���ʼ�����
% ����������ʼ�������ֻ���deceleration��Ϊfalse����
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


% ȷ�����
left = filter([0, ones(1, T)/T], 1, rr);   %��RR���������T����λ  ��һ����0
left(1:max([T, L])) = NaN;                 %ǰ����RR��NAN

right = fliplr(filter(ones(1, T)/T, 1, fliplr(rr)));
right(end-max([T, L])+1:end) = NaN;

d = (right - left)*(deceleration*2 - 1);
anchors = find(d>0);  
 
% ȷ���յ�
for j = 2:length(anchors)-1
    dRR1 = rr(anchors(j))-rr(anchors(j)-1);
    dRR2 = rr(anchors(j)+1)-rr(anchors(j));
    if (dRR1*dRR2 > 0)
        new_anchors(j-1) = anchors(j);
    else
        new_anchors(j-1) = 0;
    end
end

%��ê����ȥ���յ�
new_anchors(new_anchors == 0) = [];

%���ʶ�ȷ������λУ��
prsa = nan(2*L+1, 1);
for ii = 1:2*L+1
   prsa(ii) = nanmean(rr(new_anchors - L + ii - 1));
end

%�������ʼ����ʻ������
cap = (prsa(L+1) + prsa(L+2) - prsa(L) - prsa(L-1))/4;
   
end