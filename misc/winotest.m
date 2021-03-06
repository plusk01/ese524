% Set up data for a Winograd convolution algorithm
% Copyright 1999 by Todd K. Moon

m{1} = [1 0];   m{2} = [1 -1];   m{3} = [1 1];  m{4} = [1 0 1];

mp = conv(conv(conv(m{1},m{2}),m{3}),m{4});
gammas = crtgammapoly(m);

a = [1 2 3]
b = [5 6 7]
                                             % Mult     Add
a0 = a(3);  b0 = b(3);					     % 
a1 = a(3)+a(2)+a(1);   b1 = b(3)+b(2)+b(1);  %           4
a2 = a(1)-a(2)+a(3);   b2 = b(1)-b(2)+b(3);  %           4
a3 = [a(2) a(3)-a(1)]; b3 = [b(2) b(3)-b(1)];%           2

s0 = a0*b0;                                  %  1
s1 = a1*b1;                                  %  1
s2 = a2*b2;                                  %  1
%s3 = conv(a3,b3);
% [q,s3] = polydiv(s3,m{4});
s3 = [a3(2)*b3(1)+a3(1)*b3(2)                %  3        2
	(a3(2)*b3(2)-a3(1)*b3(1))];

sres = {s0,s1,s2,s3};
snew = fromcrtpoly(sres,m,gammas)
[q,snew] = polydiv(snew,mp);
q
snew

svec = [s0; s1/4; s2/4; s3(2)/2; s3(1)/2];   % (3)(dyadic)
G = [1 0 0 0 0 ; 
	 0 1 -1 0 1;                             %           2
	 0 1 1 -1 0;                             %           2
	 0 1 -1 0 -1;                            %           2
	 -1 1 1 1 0]                             %           2
                                             % total:
											 % 6         20
G*svec

B1 = [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 1; 0 0 0 1 0; 0 0 0 0 1];
B2 = [1 0 0; 1 1 1; 1 -1 1; 1 0 -1; 0 1 0];
B = B1*B2;

A1 = diag([1,1/4,1/4,1/2,1/2,1/2]);
A2 = [1 0 0 0 0;
	  0 1 0 0 0;
	  0 0 1 0 0;
	  0 0 0 1 0 ;
	  0 0 0 -1 1;
	  0 0 0 1 1];
A3 = B2;
A = A1*A2*A3;

C1 = [1 0 0 0 0 
      0 1 -1 0 1
	  0 1 1 -1 0
	  0 1 -1 0 -1
	  -1 1 1 1 0];
C2 = [1 0 0 0 0 0
	  0 1 0 0 0 0 
	  0 0 1 0 0 0
	  0 0 0 1 0 -1
	  0 0 0 1 1 0];
C = C1*C2;

avec = A*a';
Adiag = diag(avec);

c = C*Adiag*B*b';