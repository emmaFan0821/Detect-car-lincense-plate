function[word,pointer2]=cutplate(after_cut,pointer1)
[m,n]=size(after_cut);
while sum(after_cut(:,pointer1+1))==0 && pointer1<=n-2 % Scan horizontally until you touch the column that is any white
    pointer1=pointer1+1;
end
pointer2=pointer1;
while sum(after_cut(:,pointer2+1))~=0 && pointer2<=n-2 % Scan horizontally until you touch the column that is all black
    pointer2=pointer2+1;
end
word=imcrop(after_cut,[pointer1 1 pointer2-pointer1 m]); 
word=cutedge(word); % cut black edges
word=imresize(word,[30,20]);
end

