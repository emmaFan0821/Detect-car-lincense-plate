function e=cutedge(pic)
    [m,n]=size(pic);
    top=1;bottom=m;left=1;right=n;   
    while sum(pic(top,:))==0 && top<=m     %Cut out the white area (crosscut)
        top=top+1;
    end
    while sum(pic(bottom,:))==0 && bottom>1   
        bottom=bottom-1;
    end
    while sum(pic(:,left))==0 && left<n        %Cut out white areas (longitudinally)
        left=left+1;
    end
    while sum(pic(:,right))==0 && right>=1
        right=right-1;
    end
    w=right-left;
    h=bottom-top;
    e=imcrop(pic,[left top w h]);
end