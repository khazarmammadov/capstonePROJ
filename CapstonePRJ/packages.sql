create or replace package user_features is

    procedure registration(p_name in varchar2, p_email in varchar2, p_password varchar2);

    procedure subscription(p_email in varchar2, p_password in varchar2, p_plan_id in number);

    function login(p_email varchar2, p_password varchar2) return number;

    procedure add_profile(p_email varchar2, p_password varchar2, p_nick_name varchar2);

    function total_cost(p_email varchar2, p_password varchar2) return number;

    procedure delete_less_followed(p_limit in number);


end user_features;


CREATE OR REPLACE PACKAGE BODY user_features AS

    PROCEDURE registration(p_name IN VARCHAR2, p_email IN VARCHAR2, p_password VARCHAR2) IS

    BEGIN
        IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN

            IF REGEXP_LIKE(p_password, '^.*[0-9]', 'c') AND
               REGEXP_LIKE(p_password, '^[a-zA-Z][a-zA-Z0-9]{7,}$', 'c') THEN

                insert into USERS (NAME, EMAIL, PASSWORD, CREATED_AT, UPDATE_AT, LAST_LOGIN)
                VALUES (p_name, p_email, p_password, sysdate, sysdate, sysdate);
                commit;
            ELSE

                RAISE_APPLICATION_ERROR(-20002,
                                        'Password is not suitable. It  should contain at least one digit and be at least 8 characters long, with the first character being a letter.');
            END IF;
        ELSE

            RAISE_APPLICATION_ERROR(-20001, 'E-mail is not suitable');
        END IF;

    END registration;

------------------------------------------------------------------------------------------------------------------------

    function login(p_email varchar2, p_password varchar2) return number is

        temp_password   varchar2(255);
        temp_user_id    number;
        temp_login_date date;

    begin
        select u.PASSWORD into temp_password from USERS u where EMAIL = p_email;

        if temp_password = p_password then

            DBMS_OUTPUT.PUT_LINE('Welcome...');
            temp_login_date := sysdate;

            select u.USER_ID into temp_user_id from USERS u where u.EMAIL = p_email;
            update USERS set LAST_LOGIN = temp_login_date where EMAIL = p_email;

            return temp_user_id;
        else
            raise_application_error(-20001, 'password incorrect...');
        end if;

        return temp_user_id;

    end login;

------------------------------------------------------------------------------------------------------------------------

    procedure subscription(p_email in varchar2, p_password in varchar2, p_plan_id in number) is

        temp_user_id number;
        temp_subs    number := 0;


    begin

        temp_user_id := user_features.LOGIN(p_email, p_password);

        if temp_user_id is not null then

            select USER_ID
            into temp_subs
            from SUBSCRIPTIONS
            where USER_ID = (select USER_ID from USERS where EMAIL = p_email);

            if temp_subs = 0 or temp_subs is null then

                insert into SUBSCRIPTIONS (USER_ID, PLAN_ID, VALID_TILL, CREATED_AT, UPDATE_AT)
                values (temp_user_id, p_plan_id, add_months(sysdate, 1), sysdate, sysdate);
                commit;

            else

                update SUBSCRIPTIONS set VALID_TILL = add_months(VALID_TILL, 1);
                update SUBSCRIPTIONS set UPDATE_AT = add_months(UPDATE_AT, 1);
                commit;

            end if;

        else
            raise_application_error(-20001, 'User authentication failed');

        end if;

    end subscription;

------------------------------------------------------------------------------------------------------------------------

    procedure add_profile(p_email varchar2, p_password varchar2, p_nick_name varchar2) is

        temp_user_id  number;
        count_profile number;

    begin

        temp_user_id := user_features.LOGIN(p_email, p_password);

        if temp_user_id is not null then

            select count(p.USER_ID)
            into count_profile
            from PROFILES p
                     inner join USERS u on p.USER_ID = u.USER_ID
            where u.EMAIL = p_email;
            commit;

            if count_profile < 3 then
                insert into PROFILES (USER_ID, NICK_NAME, CREATED_AT, UPDATE_AT)
                VALUES (temp_user_id, p_nick_name, sysdate, sysdate);
                commit;

            else
                raise_application_error(-20001, 'You can create max 3 profile!!!!!!!');
            end if;


        else
            raise_application_error(-20001, 'User authentication failed');

        end if;

    end add_profile;

------------------------------------------------------------------------------------------------------------------------

    function total_cost(p_email varchar2, p_password varchar2) return number is

        total_cst    number := 0;
        temp_user_id number := 0;
        month_count  number := 0;
        temp_price   number := 0;

    begin

        temp_user_id := user_features.LOGIN(p_email, p_password);

        if temp_user_id is not null then

            SELECT TRUNC(MONTHS_BETWEEN(valid_till, CREATED_AT))
            into month_count
            FROM SUBSCRIPTIONS
            where USER_ID = (select USER_ID from USERS where EMAIL = p_email);

            select p.PRICE
            into temp_price
            from SUBSCRIPTIONS s
                     inner join PLANS p on s.PLAN_ID = p.PLAN_ID
            where USER_ID = (select USER_ID from USERS where EMAIL = p_email);

            total_cst := temp_price * month_count;

            return total_cst;


        else
            raise_application_error(-20001, 'User authentication failed');

        end if;

        return total_cst;
    end total_cost;
------------------------------------------------------------------------------------------------------------------------

    procedure delete_less_followed(p_limit in number) is


    begin

        for vid in (select VIDEO_ID from VIDEOS)
            loop
                declare

                    v_count number := 0;

                begin

                    select VIEW_COUNT into v_count from VIEWS where VIDEO_ID = vid.VIDEO_ID;
                    if v_count < p_limit then

                        delete from VIEWS where VIDEO_ID = vid.VIDEO_ID;
                        commit;
                        delete from VIDEOS where VIDEO_ID = vid.VIDEO_ID;
                        commit;
                    end if;

                end;
            end loop;


    end delete_less_followed;

END user_features;










