function p = selectPop(Parent)
    
    % 二元锦标赛选择法
    n = numel(Parent);  %读取父代种群个数
    index = randperm(n);  %随机生成整数序列
    p1 = Parent(index(1));  %序列第一名
    p2 = Parent(index(2));  %序列第二名
    
    if p1.y >= p2.y
        p = p1;    %选择较大的值
    else 
        p = p2;
    end
    
end