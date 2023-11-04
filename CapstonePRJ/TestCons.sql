begin
    USER_FEATURES.REGISTRATION('khazar', 'khazar@gmail.com', '11');
    commit;
end;

begin
    USER_FEATURES.REGISTRATION('John', 'john@example.com', 'kkkkkkk1111111');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Alice', 'alice@example.com', 'aaaaaaaaaaa3333');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Michael', 'michael@example.com', 'michael123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Sarah', 'sarah@example.com', 'sarah123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('William', 'william@example.com', 'william123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Emma', 'emma@example.com', 'em444a123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Daniel', 'daniel@example.com', 'daniel123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Olivia', 'olivia@example.com', 'olivia123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('James', 'james@example.com', 'james123');
    commit;
end;
/

begin
    USER_FEATURES.REGISTRATION('Sophia', 'sophia@example.com', 'sophia123');
    commit;
end;
/



begin
    USER_FEATURES.SUBSCRIPTION('khazar@gmail.com', 'kkkkkkkkkkkkk111111', 2);
    commit;
end;

begin
    USER_FEATURES.SUBSCRIPTION('sarah@example.com', 'sarah123', 1);
    commit;
end;

declare
    deg number;
begin
    deg := USER_FEATURES.LOGIN('khazar@gmail.com', 'kkkkkkkkkkkkk111111');
    commit;
end;


begin
    USER_FEATURES.ADD_PROFILE('sarah@example.com', 'sarah123', 'helliann');
    commit;
end;

begin
    USER_FEATURES.ADD_PROFILE('sarah@example.com', 'sarah123', 'helios');
    commit;
end;

begin
    USER_FEATURES.ADD_PROFILE('sarah@example.com', 'sarah123', 'kids');
    commit;
end;

begin
    USER_FEATURES.ADD_PROFILE('sarah@example.com', 'sarah123', 'fail');
    commit;
end;



begin
    USER_FEATURES.ADD_PROFILE('michael@example.com', 'michael123', 'fail');
    commit;
end;


begin
    USER_FEATURES.SUBSCRIPTION('khazar@gmail.com','kkkkkkkkkkkkk111111',2);
end;

declare

    ptn number := 0;

begin
   ptn := USER_FEATURES.TOTAL_COST('khazar@gmail.com','kkkkkkkkkkkkk111111');
    DBMS_OUTPUT.PUT_LINE(ptn);
   commit ;
end;



delete PROFILES
where NICK_NAME = 'kids';

select count(p.USER_ID)

from PROFILES p
         inner join USERS u on p.USER_ID = u.USER_ID
where u.EMAIL = 'michael@example.com';


MERGE INTO RATINGS rt
USING (select c.CATEGORY_ID as categ, sum(w.VIEW_COUNT) as total
       from VIDEOS v
                inner join CATEGORY c on v.CATEGORY_ID = c.CATEGORY_ID
                inner join VIEWS w on v.VIDEO_ID = w.VIDEO_ID
       group by c.CATEGORY_ID
       order by total desc) counter
ON (rt.CATEGORY_ID = counter.categ)
WHEN MATCHED THEN
    UPDATE
    SET rt.TOTAL_VIEW_COUNT = counter.total
    WHEN NOT MATCHED THEN
INSERT (category_id, total_view_count)
    VALUES
    (categ,total);
commit;

select *
from RATINGS;

begin
    USER_FEATURES.REGISTRATION('elena','elena@gmail.com','psswrd111111');
end;

begin
    USER_FEATURES.DELETE_LESS_FOLLOWED(2890345);
    commit;
end;