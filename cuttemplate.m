function block_temp=cuttemplate(bi_temp)
%% Cut the template horizontally
row_temp=cell(1,6);
pointer=0;
for i=1:6
    [row_temp{i},pointer]=horizoncut(bi_temp,pointer);
end
figure,
for i=1:6
    subplot(2,3,i);imshow(row_temp{i})
end

%% Cut the template vertically
block_temp=cell(6,6);
for i=1:6
    pointer=0;
    for j=1:6
        [block_temp{i,j},pointer]=verticalcut(row_temp{i},pointer);
        block_temp{i,j}=cutedge(block_temp{i,j});
        block_temp{i,j}=imresize(block_temp{i,j},[30,20]);
    end
end
figure,
k=1;
template_name=['A':'Z','1':'9','0'];
for i=1:6
    for j=1:6
        subplot(6,6,k);imshow(block_temp{i,j})
        imwrite(block_temp{i,j},['./model/',[template_name((i-1)*6+j),'.jpg']]); % save it in model folder
        k=k+1;
    end
end

%% horizoncut func & verticalcut func, similar with cutplate
    function [row_temp,pointer2]=horizoncut(bi_temp,pointer1)
        [m,n]=size(bi_temp);
        while sum(bi_temp(pointer1+1,:))==0 && pointer1<=m-2
            pointer1=pointer1+1;
        end
        pointer2=pointer1;
        while sum(bi_temp(pointer2+1,:))~=0 && pointer2<=m-2
            pointer2=pointer2+1;
        end
        row_temp=imcrop(bi_temp,[1 pointer1 n pointer2-pointer1]);    
    end
    function [block_temp,pointer2]=verticalcut(row_temp,pointer1)
        [m,n]=size(row_temp);
        while sum(row_temp(:,pointer1+1))==0 && pointer1<=n-2
            pointer1=pointer1+1;
        end
        pointer2=pointer1;
        while sum(row_temp(:,pointer2+1))~=0 && pointer2<=n-2
            pointer2=pointer2+1;
        end
        block_temp=imcrop(row_temp,[pointer1 1 pointer2-pointer1 m]); 
    end
end
