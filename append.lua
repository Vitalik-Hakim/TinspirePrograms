Define LibPub append(x,y)=
Func
:©concatenates lists
:Local z
:x:=string(x)
:x:=string(y)
:z:=mid(x,1,dim(x)-1)&","&mid(y,2,dim(y)-1)
:Return expr(z)
:EndFunc
