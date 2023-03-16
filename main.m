%遗传算法找特定区间fun(x)最大值
clc;clear;close all
syms x y
xmin = -10;
xmax = 10;

nVar = 10; % 自变量长度(二进制编码)
nPop = 30; % 种群规模
maxIt = 200; % 最大迭代次数
nPc= 0.8; % 子代比例 
nC = round(nPop * nPc / 2) * 2; % 子代规模，需进行圆整化
nMu = 0.05; % 变异概率

% 结果存放模板
template.x = [];  %二进制编码
template.x_dec = []; %二进制转化为十进制（考虑到区间为十进制，方便求y）
template.y = [];
best_indiv = zeros(maxIt, 1); %记录每次迭代的最优个体

% 父代种群结果存放
Parent = repmat(template, nPop, 1);

%初始化种群
for i = 1 : nPop
  Parent(i).x = randi([0, 1], 1, nVar);  %生成1行10列的一维数组
  Parent(i).x_dec = xmin + (xmax - xmin) * (bin2dec(num2str(Parent(i).x)) / (2^nVar - 1));
  Parent(i).y = fun(Parent(i).x_dec);
end

for It = 1 : maxIt
    
    % 子代种群结果存放数组
    Offspring = repmat(template, nC/2, 2);  %子代种群分成两列，方便观察交叉情况

    for j = 1 : nC/2
        % 选择
        p1 = selectPop(Parent);
        p2 = selectPop(Parent);
        % 交叉
        [Offspring(j, 1).x, Offspring(j, 2).x] = crossPop(p1.x, p2.x); %p1、p2为结构体，需要把x传进去
    end

    Offspring = Offspring(:);  %将子代种群两列形式转换为一列形式

    % 变异
    for k = 1 :nC
        Offspring(k).x = mutatePop(Offspring(k).x, nMu);
        Offspring(k).x_dec =  xmin + (xmax - xmin) * (bin2dec(num2str(Offspring(k).x)) / (2^nVar - 1));
        Offspring(k).y = fun(Offspring(k).x_dec);
    end
     % 合并种群
    newPop = [Parent; Offspring];   %父代和子代种群合并
    
    % 排序
    [~, so] = sort([newPop.y], 'descend');  %新种群降序排列，序列保存至so
    newPop = newPop(so);
    
    % 记录最优个体
    best_indiv(It, 1) = newPop(1, 1).y;    
    
    % 筛选
    Parent = newPop(1 : nPop);

    disp(['迭代次数：', num2str(It), '， 最大值为：', num2str(Parent(1).y)])
    
end
    % 绘制最优个体进化图
    plot(best_indiv,'LineWidth',2,'Color','r')
    xlabel('迭代次数')
    ylabel('最大值')
    title('y(max) = x.^3 + 3 * x + 15')
